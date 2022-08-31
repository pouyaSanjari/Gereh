import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sarkargar/services/uiDesign.dart';
import 'package:sarkargar/pages/chat/cubit/messages_cubit.dart';
import 'package:sarkargar/services/database.dart';
import 'package:sarkargar/services/in_app_database.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import '../Model/message_model.dart';

class ChatScreen extends StatefulWidget {
  final String myId;
  final String receiverName;
  final String receiverID;
  final String groupid;
  const ChatScreen(
      {Key? key,
      required this.myId,
      required this.receiverName,
      required this.groupid,
      required this.receiverID})
      : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver {
  final box = GetStorage();
  late io.Socket _socket;
  final TextEditingController _messageInputController = TextEditingController();
  final ImagePicker picker = ImagePicker();
  File? _image;
  UiDesign uiDesign = UiDesign();
  AppDataBase dataBase = AppDataBase();
  List messages = [];
  String id = '';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MessagesCubit, MessagesState>(
      builder: (context, state) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: UiDesign().cTheme(),
          home: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
                leading: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Iconsax.arrow_left,
                      color: Colors.black,
                    )),
                centerTitle: true,
                title: Text(widget.receiverName),
                elevation: 0),
            body: Stack(children: [
              Positioned(
                  bottom: 80,
                  right: 10,
                  child: _image != null
                      ? Container(
                          padding: const EdgeInsets.all(1),
                          color: Colors.grey,
                          child: Image.file(
                            _image!,
                            height: 60,
                            width: 60,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Container()),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: SafeArea(
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                pickImage();
                              },
                              icon: const Icon(Icons.image)),
                          Expanded(
                            child: uiDesign.chatTextField(
                                controller: _messageInputController),
                          ),
                          IconButton(
                            onPressed: () async {
                              if (_messageInputController.text
                                  .trim()
                                  .isNotEmpty) {
                                _sendMessage();
                                _messageInputController.clear();
                              }
                            },
                            icon: const Icon(Icons.send),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Positioned(
                  bottom: 150,
                  right: 25,
                  child: _image != null
                      ? CircleAvatar(
                          backgroundColor: Colors.red,
                          radius: 15,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _image = null;
                              });
                            },
                            child: const Icon(
                              Icons.close_rounded,
                              color: Colors.white,
                            ),
                          ),
                        )
                      : Container()),
            ]),
          ),
        );
      },
    );
  }

  _sendMessage() {
    _socket.emit('message', {
      'message': _messageInputController.text.trim(),
      'receiver': widget.receiverID,
      'sender': widget.myId,
      'groupid': widget.groupid
    });
  }

  _connectSocket() {
    _socket.emit('userConnected', widget.myId);
    _socket.onConnect((data) => print('Connection established'));
    _socket.onConnectError((data) => print('Connect Error: $data'));
    _socket.onDisconnect((data) => print('Socket.IO server disconnected'));
    _socket.on(
      'message',
      (data) {
        DBprovider.db.newMessage(
            message: data['message'],
            sender: data['senderUsername'],
            receiver: data['receiver'],
            sentAt: data['sentAt'].toString(),
            groupid: data['groupid'].toString());
      },
    );
  }

  Future pickImage() async {
    final image =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (image == null) {
      return;
    }
    final tempimage = File(image.path);

    _image = tempimage;
  }

  loadMessagesFromLocalDatabase() async {
    await DBprovider.db.initDB();
    List messages = await DBprovider.db.getMessages(groupid: widget.groupid);

    for (int i = 0; i < messages.length; i++) {
      Message(
          message: messages[i]['message'],
          senderUsername: messages[i]['sender'],
          sentAt: DateTime(messages[i]['date']),
          groupid: messages[i]['groupid'],
          receiver: messages[i]['receiver']);
    }

    return messages;
  }

  //دریافت پیام های خوانده نشده از سرور
  getUnreadMessagesFromServer() async {
    List messages = await dataBase.getUnreadMessages(groupId: widget.groupid);
    for (int i = 0; i < messages.length; i++) {
      if (messages[i]['sender'] != widget.myId) {
        Message(
            message: messages[i]['message'],
            senderUsername: messages[i]['sender'],
            sentAt: DateTime(
              int.parse(messages[i]['date']),
            ),
            groupid: messages[i]['groupid'],
            receiver: messages[i]['receiver']);

        await dataBase.setMessagesToReaded(messageId: messages[i]['id']);
        loadMessagesFromLocalDatabase();
      }
    }
  }

  @override
  void initState() {
    _socket = io.io(
      'http://192.168.75.24:3000',
      io.OptionBuilder()
          .setTransports(['websocket']).setQuery({'username': id}).build(),
    );
    _connectSocket();
    WidgetsBinding.instance.addObserver(this);
    loadMessagesFromLocalDatabase();
    getUnreadMessagesFromServer();

    _socket.connect();
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _messageInputController.dispose();
    _socket.disconnect();
    id = box.read('id');
    super.dispose();
  }
}
