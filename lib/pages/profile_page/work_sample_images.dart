import 'dart:convert' as convert;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sarkargar/services/uiDesign.dart';

class WorkSamples extends StatefulWidget {
  final int id;
  final bool isownder;
  const WorkSamples({Key? key, required this.id, required this.isownder})
      : super(key: key);

  @override
  State<WorkSamples> createState() => _WorkSamplesState();
}

class _WorkSamplesState extends State<WorkSamples> {
  UiDesign uiDesign = UiDesign();
  List snap = [];
  List<String> images = [];
  final ImagePicker picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.deepPurpleAccent,
            onPressed: () {
              uploadImage();
            },
            child: const Icon(
              Iconsax.gallery_add,
              size: 30,
            ),
          ),
          appBar: AppBar(
            actions: [
              InkWell(
                onTap: () => Navigator.pop(context),
                child: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.black,
                ),
              )
            ],
            leading: const Icon(
              Icons.info_outline,
              color: Colors.black,
            ),
            elevation: 0,
            backgroundColor: Colors.grey[50],
            centerTitle: true,
            title: const Text(
              'تصاویر نمونه کار',
              style: TextStyle(color: Colors.black),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FutureBuilder(
                future: getImages(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: Text('لطفا منتظر بمانید'));
                  }
                  if (snapshot.hasData) {
                    snap = snapshot.data;
                  }
                  if (snapshot.data == null) {
                    return uiDesign.errorWidget(
                      () => setState(() {
                        snap;
                      }),
                    );
                  }

                  if (snapshot.data.isEmpty) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('images/not_found.png'),
                        const Text(
                            'تصویری موجود نیست می توانید با دکمه پایین یکی اضافه کنید'),
                      ],
                    );
                  }

                  return GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: snap.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10),
                    itemBuilder: (context, int index) {
                      return InkResponse(
                        onLongPress: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title:
                                  const Center(child: Text('تصویر حذف شود؟')),
                              content: const Directionality(
                                textDirection: TextDirection.rtl,
                                child: Text(
                                    'آیا مطمئن هستید که میخواهید این تصویر را حذف کنید؟ در صورت تایید امکان بازیابی تصویر وجود ندارد.'),
                              ),
                              actions: [
                                TextButton(
                                    onPressed: () async {
                                      await deleteImage(snap[index]['id']);
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      "حذف",
                                      style: TextStyle(color: Colors.redAccent),
                                    )),
                                TextButton(onPressed: () {}, child: Text("لغو"))
                              ],
                            ),
                          );
                        },
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => Dialog(
                              insetPadding: EdgeInsets.all(0),
                              backgroundColor: Colors.black,
                              child: Column(
                                children: [
                                  Expanded(
                                    child: CachedNetworkImage(
                                      imageUrl: snap[index]['image'],
                                    ),
                                  ),
                                  IconButton(
                                      splashColor: Colors.white,
                                      icon: Icon(Icons.arrow_back,
                                          color: Colors.white, size: 30),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      }),
                                  SizedBox(height: 20)
                                ],
                              ),
                            ),
                          );
                        },
                        child: CachedNetworkImage(
                          imageUrl: snap[index]['image'],
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  );
                }),
          ),
        ),
      ),
    );
  }

  getImages() async {
    Uri url =
        Uri.parse('http://sarkargar.ir/phpfiles/userimages/getimages.php');
    var response = await http.post(url, body: {'userid': widget.id.toString()});
    List jsonResponse = convert.jsonDecode(response.body);
    for (int i = 0; i < jsonResponse.length; i++) {
      images.add(jsonResponse[i]['image']);
    }
    return jsonResponse;
  }

  uploadImage() async {
    final image =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (image == null) {
      return;
    }
    var url =
        Uri.parse('http://sarkargar.ir/phpfiles/userimages/upload_image.php');
    var request = http.MultipartRequest('POST', url);
    request.files
        .add(await http.MultipartFile.fromPath('photo[0]', image.path));
    Map<String, String> other = {'id': widget.id.toString()};
    request.fields.addAll(other);

    await request.send();
    setState(() {
      snap;
    });
  }

  deleteImage(String imageId) async {
    Uri url =
        Uri.parse('http://sarkargar.ir/phpfiles/userimages/deletefile.php');
    await http.post(url, body: {'imageid': imageId});
    setState(() {
      snap;
    });
  }

  @override
  void initState() {
    getImages();
    super.initState();
  }
}
