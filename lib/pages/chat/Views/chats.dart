import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:sarkargar/services/uiDesign.dart';
import 'package:sarkargar/pages/chat/Views/chat_screen.dart';
import 'package:sarkargar/services/database.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import '../../../../services/in_app_database.dart';

class Chats extends StatefulWidget {
  const Chats({Key? key}) : super(key: key);

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  final box = GetStorage();
  late io.Socket _socket;
  AppDataBase dataBase = AppDataBase();
  UiDesign uiDesign = UiDesign();

  String id = '';

  List snap = [];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: UiDesign().cTheme(),
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.grey[50],
            centerTitle: true,
            title: const Text(
              'انتخاب گفتگو',
              style: TextStyle(color: Colors.black),
            ),
          ),
          body: FutureBuilder(
            future: getchatdetails(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Lottie.asset('assets/lottie/loading.json',
                      width: 80, height: 80),
                );
                //زمانی که اطلاعات رو از سرور دریافت کرده
              } else if (snapshot.hasData) {
                snap = snapshot.data;
                //زمانی که نتونسته اطلاعاتی دریافت کنه
              } else {
                return uiDesign.errorWidget(
                  () {},
                );
              }

              return RefreshIndicator(
                  onRefresh: () async {
                    await getchatdetails();
                    setState(() {
                      snap = snapshot.data;
                    });
                  },
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: snap.length,
                    itemBuilder: (BuildContext context, int index) {
                      String receiver = snap[index]['receiver'];
                      String sender = snap[index]['senderID'] != id.toString()
                          ? snap[index]['sender']
                          : receiver;
                      String groupid = snap[index]['groupid'];

                      return ListTile(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatScreen(
                                  receiverID:
                                      snap[index]['senderID'] != id.toString()
                                          ? snap[index]['senderID']
                                          : snap[index]['receiverID'],
                                  myId: id.toString(),
                                  groupid: groupid,
                                  //کسی که داریم بهش پیام میدیم درواقع کسیه که ما نیستیم:) و این استرینگ همونیه که ما نیستیم
                                  receiverName: sender),
                            )),
                        title: Text(sender),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider();
                    },
                  ));
            },
          ),
        ),
      ),
    );
  }

  getchatdetails() async {
    List chats = await dataBase.getChats(id: box.read('id'));
//پویای عزیز یا هر کسی که در آینده داری این کد رو میخونی
//نمیدونم تا اینجا رو متوجه شدی یا نه ولی مطمئنم
//این قسمت رو به هیچ عنوان متوجه نمیشی پس زیاد به مغذت فشار نیار :) و رد شو ازش
//فقط بدون اسم نفراتی که تو چت هستن رو بر اساس آیدیشون از دیتابیس می گیره، همین
    List chatdetails = [];

    for (int i = 0; i < chats.length; i++) {
      List qwe = [
        {
          "sender": await dataBase.getUserDetailsById(
              userId: int.parse(chats[i]['sender'])),
          "receiver": await dataBase.getUserDetailsById(
              userId: int.parse(chats[i]['receiver']))
        }
      ];
      chatdetails.add(qwe);
    }
    List senders = [];
    List receivers = [];
    for (int i = 0; i < chats.length; i++) {
      receivers.add(chatdetails[i][0]['receiver'][0]['name'] +
          ' ' +
          chatdetails[i][0]['receiver'][0]['family']);
      senders.add(chatdetails[i][0]['sender'][0]['name'] +
          ' ' +
          chatdetails[i][0]['sender'][0]['family']);
    }
    // print(receivers);
    List chat = [];
    for (int i = 0; i < chats.length; i++) {
      chat.add({
        "sender": senders[i],
        "senderID": chats[i]['sender'],
        "receiver": receivers[i],
        "receiverID": chats[i]['receiver'],
        "groupid": chats[i]['id']
      });
    }
    return chat;
  }

  _connectSocket() {
    _socket.emit('userConnected', id);
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

  @override
  void initState() {
    _socket = io.io(
      'http://192.168.75.24:3000',
      io.OptionBuilder()
          .setTransports(['websocket']).setQuery({'username': id}).build(),
    );
    super.initState();
  }
}
