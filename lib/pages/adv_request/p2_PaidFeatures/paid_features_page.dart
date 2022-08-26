import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:sarkargar/services/uiDesign.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../../../controllers/request_controller.dart';
import 'map.dart';

class PaidFeatures extends StatefulWidget {
  const PaidFeatures({Key? key}) : super(key: key);

  @override
  State<PaidFeatures> createState() => _PaidFeaturesState();
}

class _PaidFeaturesState extends State<PaidFeatures> {
  final controller = Get.put(RequestController());
  late SharedPreferences sharedPreferences;

  UiDesign uiDesign = UiDesign();
  final ImagePicker picker = ImagePicker();

  bool image = false;
  double imageSelectionHight = 0;
  int id = 0;

  TextEditingController instagramController = TextEditingController();
  List<String> uploadedImages = [];
  List snap = [];

  String address = '';

  @override
  Widget build(BuildContext context) {
    snap = controller.images;
    return SingleChildScrollView(
      child: Column(
        children: [
          Text('|     ویژگی های رایگان     |',
              style: uiDesign.titleTextStyle()),
          const Divider(),
          Obx(
            () => listTiles(
                leading: Iconsax.call,
                iconColor: Colors.green,
                title: 'نمایش شماره تلفن',
                switc: uiDesign.cSwitch(controller.phoneBool.value, (value) {
                  controller.phoneBool.value = value;
                  if (value == false) {
                    controller.chatBool.value = true;
                  }
                }),
                sub:
                    'کاربران می توانند مستقیما با شما تماس بگیرند یا پیام ارسال کنند.'),
          ),
          Obx(
            () => listTiles(
                leading: Iconsax.sms,
                iconColor: Colors.orangeAccent,
                title: 'چت',
                switc: uiDesign.cSwitch(controller.chatBool.value, (value) {
                  controller.chatBool.value = value;
                  if (value == false) {
                    controller.phoneBool.value = true;
                  }
                }),
                sub:
                    'کاربران می توانند از طریق چت درون برنامه ای با شما ارتباط برقرار کنند.'),
          ),
          const SizedBox(height: 50),
          Text('|  ویژگی های غیر رایگان  |', style: uiDesign.titleTextStyle()),
          Text(
            textAlign: TextAlign.center,
            'توجه فرمایید که به ازای هر کدام از گذینه های زیر'
            ' مبلغ 5 هزار تومان به هزینه ثبت آگهی افزوده خواهد شد، در صورتی که '
            'هیچ کدام را انتخاب نکنید هزینه ای پرداخت نخواهید کرد.',
            style: uiDesign.descriptionsTextStyle(),
          ),
          const Divider(),
          Obx(
            () => listTiles(
                leading: Iconsax.gallery,
                iconColor: Colors.lightBlueAccent,
                title: 'تصاویر نمونه کار',
                switc: uiDesign.cSwitch(controller.imageSelectionBool.value,
                    (value) {
                  controller.imageSelectionBool.value = value;
                  value == true
                      ? controller.imageSelectionHeight.value = 210
                      : controller.imageSelectionHeight.value = 0;
                }),
                sub:
                    'افزودن تصویر به آگهی موجب تعامل بیشتر کاربران با آگهی شما خواهد شد.'),
          ),
          //###########################################################################################
          //###########################################################################################
          //###########################################################################################
          Obx(
            () => AnimatedSize(
              curve: Curves.easeOut,
              duration: const Duration(milliseconds: 500),
              child: SizedBox(
                height: controller.imageSelectionHeight.value,
                child: Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FutureBuilder(
                            future: getImages(),
                            builder: (BuildContext context,
                                AsyncSnapshot<dynamic> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: Lottie.asset(
                                      'assets/lottie/loading.json',
                                      width: 80,
                                      height: 80),
                                );
                              }
                              if (snapshot.hasData) {
                                snap = snapshot.data;
                              }
                              if (snapshot.data == null) {
                                return uiDesign.errorWidget(
                                  () => setState(() {}),
                                );
                              }

                              if (snapshot.data.isEmpty) {
                                return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'تصویری موجود نیست می توانید با دکمه پایین یکی اضافه کنید.',
                                        style: uiDesign.titleTextStyle(),
                                        textAlign: TextAlign.center,
                                      ),
                                      uiDesign.cRawMaterialButton(
                                        fillColor: Colors.green,
                                        text: '     افزودن تصویر     ',
                                        onClick: () => uploadImage(),
                                      )
                                    ],
                                  ),
                                );
                              }

                              return GridView.builder(
                                physics: const BouncingScrollPhysics(),
                                itemCount: 8,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 4,
                                        mainAxisSpacing: 10,
                                        crossAxisSpacing: 10),
                                itemBuilder: (context, int index) {
                                  if (snap.length < index + 1) {
                                    return InkWell(
                                      onTap: () => uploadImage(),
                                      child: Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: const Icon(
                                            Iconsax.gallery_add,
                                            size: 35,
                                          )),
                                    );
                                  } else {
                                    return InkResponse(
                                      onLongPress: () {
                                        //حذف تصویر انتخاب شده
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: const Center(
                                                child: Text('تصویر حذف شود؟')),
                                            content: const Directionality(
                                              textDirection: TextDirection.rtl,
                                              child: Text(
                                                  'آیا مطمئن هستید که میخواهید این تصویر را حذف کنید؟ در صورت تایید امکان بازیابی تصویر وجود ندارد.'),
                                            ),
                                            actions: [
                                              TextButton(
                                                  onPressed: () async {
                                                    await deleteImage(
                                                        snap[index]['id']);
                                                    if (!mounted) return;
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text(
                                                    "حذف",
                                                    style: TextStyle(
                                                        color:
                                                            Colors.redAccent),
                                                  )),
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text("لغو"))
                                            ],
                                          ),
                                        );
                                      },
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => Dialog(
                                            insetPadding:
                                                const EdgeInsets.all(0),
                                            backgroundColor: Colors.black,
                                            child: Column(
                                              children: [
                                                Expanded(
                                                  child: CachedNetworkImage(
                                                    imageUrl: snap[index]
                                                        ['image'],
                                                  ),
                                                ),
                                                IconButton(
                                                    splashColor: Colors.white,
                                                    icon: const Icon(
                                                        Icons.arrow_back,
                                                        color: Colors.white,
                                                        size: 30),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    }),
                                                const SizedBox(height: 20)
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
                                  }
                                },
                              );
                            }),
                      ),
                    ),
                    const Text(
                        '(با نگه داشتن روی تصویر می توانید آن را حذف کنید)')
                  ],
                ),
              ),
            ),
          ),
          //###########################################################################################
          //###########################################################################################
          //###########################################################################################
          const SizedBox(height: 20),
          Obx(
            () => listTiles(
                leading: Iconsax.map_1,
                iconColor: Colors.brown,
                title: 'نمایش مکان روی نقشه',
                switc: uiDesign.cSwitch(controller.locationSelectionBool.value,
                    (value) {
                  controller.locationSelectionState(value);
                }),
                sub:
                    'این قابلیت را اضافه می کند که کاربر با کلیک بر روی یک دکمه مکان دقیق موقعیت مورد نظر شما را مشاهده کند.'),
          ),
          Obx(
            () => AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.linear,
              child: AnimatedContainer(
                height: controller.locationSelectionHeight.value,
                duration: const Duration(milliseconds: 300),
                child: Column(
                  children: [
                    uiDesign.cRawMaterialButton(
                      fillColor: uiDesign.mainColor(),
                      text: '   انتخاب موقعیت از روی نقشه   ',
                      onClick: () => Get.to(() => const MapPage())
                          ?.then((value) => address = value[0]),
                    ),
                    Obx(() => Text(controller.address.value)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Obx(
            () => listTiles(
                leading: Iconsax.instagram,
                iconColor: Colors.redAccent,
                title: 'آیدی اینستاگرام',
                switc: uiDesign.cSwitch(
                    controller.instagramIdSelectionBool.value, (value) {
                  controller.instagramIdSelectionState(value);
                }),
                sub:
                    'کابران به راحتی می توانند صفحه اینستاگرام شما را مشاهده کنند.'),
          ),
          Obx(
            () => AnimatedContainer(
              height: controller.instagramIdSelectionHeight.value,
              duration: const Duration(milliseconds: 500),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: uiDesign.cTextField(
                  length: 30,
                  hint: 'بدون @',
                  error: controller.selectedInstagramIdError.value == ''
                      ? null
                      : controller.selectedInstagramIdError.value,
                  icon: Icon(Iconsax.location,
                      size: controller.instagramIdSelectionHeight.value / 3),
                  labeltext: 'آیدی اینستاگرام خود را وارد کنید.',
                  control: instagramController,
                  onSubmit: (value) => print(value),
                  onChange: (value) {
                    if (instagramController.text
                        .contains(RegExp(r'[@#$&-+()?!;:*+%-]'))) {
                      controller.selectedInstagramIdError.value =
                          'کاراکتر غیر مجاز!';
                    } else {
                      controller.selectedInstagramIdError.value = '';
                    }

                    // if (instagramController.text.contains(' ')) {
                    //   controller.selectedInstagramIdError.value =
                    //       'کاراکتر غیر مجاز!';
                    // } else {
                    //   controller.selectedInstagramIdError.value = '';
                    // }
                    controller.selectedInstagramId.value = value;
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ListTile listTiles(
      {required IconData leading,
      required Color iconColor,
      required String title,
      required Widget switc,
      required String sub}) {
    return ListTile(
      minLeadingWidth: 5,
      leading: Icon(leading, color: iconColor),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(title, style: uiDesign.titleTextStyle()), switc],
      ),
      subtitle: Text(sub, style: uiDesign.descriptionsTextStyle()),
      contentPadding: EdgeInsets.zero,
    );
  }

  sharedInitial() async {
    sharedPreferences = await SharedPreferences.getInstance();
    id = sharedPreferences.getInt('id') ?? 0;
  }

  getImages() async {
    controller.images.clear();
    Uri url =
        Uri.parse('http://sarkargar.ir/phpfiles/userimages/getimages.php');
    var jsonresponse = await http.post(url, body: {'userid': id.toString()});
    List result = convert.jsonDecode(jsonresponse.body);
    for (int i = 0; i < result.length; i++) {
      uploadedImages.add(result[i]['image']);
    }
    controller.images.isEmpty ? controller.images.value = uploadedImages : null;
    return result;
  }

  deleteImage(String imageId) async {
    Uri url =
        Uri.parse('http://sarkargar.ir/phpfiles/userimages/deletefile.php');
    await http.post(url, body: {'imageid': imageId});
    setState(() {
      snap;
    });
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
    Map<String, String> other = {'id': id.toString()};
    request.fields.addAll(other);
    Fluttertoast.showToast(msg: 'درحال آپلود...');
    await request.send();

    setState(() {
      snap;
    });
  }

  @override
  // ignore: must_call_super
  void initState() {
    instagramController.text = controller.selectedInstagramId.value;
    sharedInitial();
  }
}
