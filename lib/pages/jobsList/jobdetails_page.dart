import 'package:cached_network_image/cached_network_image.dart';
import 'package:digit_to_persian_word/digit_to_persian_word.dart';
import 'package:dio/dio.dart';
import 'package:expandable_fab_menu/expandable_fab_menu.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sarkargar/services/database.dart';
import 'package:sarkargar/services/image_viewer.dart';
import 'package:sarkargar/controllers/job_details_controller.dart';
import 'package:sarkargar/services/uiDesign.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class JobDetails extends StatefulWidget {
  final Map adDetails;
  final List images;
  // ignore: use_key_in_widget_constructors
  const JobDetails({required this.adDetails, required this.images});

  @override
  State<JobDetails> createState() => _JobDetailsState();
}

class _JobDetailsState extends State<JobDetails> {
  UiDesign uiDesign = UiDesign();
  final controller = Get.put(JobDetailsController());
  final database = AppDataBase();

  @override
  Widget build(BuildContext context) {
    var images = widget.images;
    var ad = widget.adDetails;
    controller.advertizer.value = ad['advertizerid'];
    controller.adType.value = ad['adtype'];
    controller.hiringtype.value = ad['hiringtype'];
    controller.title.value = ad['title'];
    controller.category.value = ad['category'];
    controller.city.value = ad['city'];
    controller.address.value = ad['address'];
    controller.locationlat.value = ad['locationlat'];
    controller.locationlon.value = ad['locationlon'];
    controller.men.value = ad['men'];
    controller.women.value = ad['women'];
    controller.mprice.value = ad['mprice'];
    controller.wprice.value = ad['wprice'];
    controller.descs.value = ad['descs'];
    controller.time.value = ad['time'];
    controller.instagramid.value = ad['instagramid'];

    controller.phonebool.value = ad['phonebool'] == '0' ? false : true;
    controller.chatbool.value = ad['chatbool'] == '0' ? false : true;
    controller.photobool.value = ad['photobool'] == '0' ? false : true;
    controller.locationbool.value = ad['locationbool'] == '0' ? false : true;
    controller.instagrambool.value = ad['instagrambool'] == '0' ? false : true;
    getAdvertizer();

    return MaterialApp(
      theme: uiDesign.cTheme(),
      debugShowCheckedModeBanner: false,
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: actionButtons(),
          appBar: appBar(context),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    imagesView(context, images),
                    const SizedBox(height: 5),
                    Text(controller.title.value,
                        style: uiDesign.titleTextStyle()),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(Iconsax.clock, size: 15, color: Colors.grey),
                        const SizedBox(width: 5),
                        Text(uiDesign.timeFunction(controller.time.value),
                            style: uiDesign.descriptionsTextStyle()),
                      ],
                    ),
                    const SizedBox(height: 30),
                    row(
                        icon: Iconsax.location,
                        title: "آدرس",
                        value: controller.address.value == ''
                            ? controller.city.value
                            : controller.address.value),
                    const Divider(height: 30),
                    row(
                        icon: Iconsax.category_2,
                        title: 'دسته بندی',
                        value: controller.category.value),
                    const Divider(height: 30),
                    row(
                        icon: Iconsax.man,
                        title: 'تعداد نفرات آقا',
                        value: '${controller.men.value} نفر'),
                    const Divider(height: 30),
                    row(
                      icon: Iconsax.dollar_circle,
                      title: 'مبلغ پیشنهادی',
                      value: uiDesign.digi(controller.mprice.value),
                    ),
                    const Divider(height: 30),
                    row(
                        icon: Iconsax.woman,
                        title: 'تعداد نفرات خانم',
                        value: '${controller.women.value} نفر'),
                    const Divider(height: 30),
                    row(
                        icon: Iconsax.dollar_circle,
                        title: 'مبلغ پیشنهادی',
                        value: controller.wprice.value == ''
                            ? 'توافقی'
                            : uiDesign.digi(controller.wprice.value)),
                    const Divider(height: 30),
                    Text('توضیحات', style: uiDesign.titleTextStyle()),
                    const SizedBox(height: 15),
                    Text(controller.descs.value),
                    const SizedBox(height: 15),
                    controller.locationbool.value
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                                imageUrl:
                                    'https://map.ir/static?width=700&height=400&markers=color:red'
                                    '|${controller.locationlon.value},${controller.locationlat.value}&zoom_level=17&x-api-key=${controller.apiKey}'),
                          )
                        : Container(),
                    const SizedBox(height: 90)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Row row(
      {required IconData icon, required String title, required String value}) {
    return Row(children: [
      Icon(icon, color: Colors.grey),
      const SizedBox(width: 10),
      Text(title, style: const TextStyle(fontSize: 15)),
      Expanded(
        child: Text(value,
            textAlign: TextAlign.end,
            style: const TextStyle(
                fontSize: 15, textBaseline: TextBaseline.alphabetic)),
      ),
    ]);
  }

  Widget imagesView(BuildContext context, List<dynamic> images) {
    if (images.isEmpty) {
      return Container(
        height: 150,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(15)),
        child: const Icon(
          Iconsax.gallery_slash,
          size: 100,
          color: Colors.grey,
        ),
      );
    } else {
      return SizedBox(
        height: 250,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              child: InkWell(
                onTap: () => Get.to(ImageViewerPage(images: widget.images),
                    transition: Transition.cupertino,
                    duration: const Duration(milliseconds: 300)),
                child: CachedNetworkImage(
                    width: MediaQuery.of(context).size.width,
                    imageUrl: images[0]['image'],
                    fit: BoxFit.cover),
              ),
            ),
            Container(
              width: 25,
              height: 25,
              decoration: const BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: Center(
                  child: Text(
                images.length.toString(),
                style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              )),
            )
          ],
        ),
      );
    }
  }

  ExpandableFabMenu actionButtons() {
    return ExpandableFabMenu(
      fabAlignment: Alignment.bottomCenter,
      backgroundColor: Colors.black,
      animatedIcon: AnimatedIcons.menu_close,
      marginRight: 30,
      marginLeft: 20,
      onOpen: () => initialContact(),
      onClose: () => debugPrint('DIAL CLOSED'),
      scrollVisible: true, //bool
      overlayColor: Colors.black,
      overlayOpacity: 0.5,
      onPress: () {},
      children: controller.contact,
      child: const Icon(Iconsax.add),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      actions: const [
        Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Icon(
            Iconsax.save_add,
            color: Colors.black,
          ),
        )
      ],
      elevation: 0,
      title: const Text('جزئیات آگهی'),
      centerTitle: true,
      leading: IconButton(
          icon: const Icon(
            Iconsax.arrow_right_3,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          }),
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  Future<void> _launchInstagram(String instagramID) async {
    await launch("https://www.instagram.com/$instagramID/",
        universalLinksOnly: true);
  }

  getAdvertizer() async {
    var user = await database.getUserDetailsById(
        userId: int.parse(controller.advertizer.value));
    controller.advertizerNumber.value = user[0]['number'];
  }

  String digi(String number) {
    String digit = DigitToWord.toWord(number, StrType.NumWord, isMoney: true);
    return digit;
  }

  mapImg() async {
    Uri url = Uri.parse(
        'https://map.ir/static?width=700&height=500&markers=color:red|label:a|51.394912,35.72164&zoom_level=17&x-api-key=eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6ImYwYjNkZmEzYmU0MTEyOGEzZGNlNDVkOWQ1OTU0MmU5NmVmYjZhMjMwZWM5MjUzNzRiZGZiNGY1MWIzNmM4ZTI2NTBkZWQ5ZWUxMmU3MjM0In0.eyJhdWQiOiIxODc5NSIsImp0aSI6ImYwYjNkZmEzYmU0MTEyOGEzZGNlNDVkOWQ1OTU0MmU5NmVmYjZhMjMwZWM5MjUzNzRiZGZiNGY1MWIzNmM4ZTI2NTBkZWQ5ZWUxMmU3MjM0IiwiaWF0IjoxNjU4MjU4NTQ5LCJuYmYiOjE2NTgyNTg1NDksImV4cCI6MTY2MDg1MDU0OSwic3ViIjoiIiwic2NvcGVzIjpbImJhc2ljIl19.Kd5dqFBrzvJmtkVL-LqRsDE3tHw4SSFGxc_dFs9v_4DRRkfaiKxcgSj6iRGjWtQcJTF7kikj6RS9NNI4MV5xBbqSjSiblKWfRXTqtAtoE9a_FJO7yt_DmcSpuUf99bbwSs99UPmOX945iMEFVbJSS-KyHfcQ8Q_G3XwymmD4hjxGvEsV32KzyeXUuUswzL9RwUFjtAn-ix-9-9DSRuSAEFk9MN2FP8_o3YvJ2m-7xJwFYy6nfn-K5_EncWpyJfbFWzkge5VS7XP1Mrnn8Jui9EgcSJsEzQjDt4jHN5_ZIVW63_Mq2kD3VlVrgqM97BrJlTaDQcICxaqt55O5eu9X9A');
    await http.get(url);
  }

// این متد مقادیر تماس با آگهی دهند را تکمیل میکند
  void initialContact() {
    if (controller.contact.isEmpty) {
      if (controller.phonebool.value) {
        controller.contact.add(ExpandableFabMenuItem(
          child: const Icon(Iconsax.call, color: Colors.white),
          title: "تماس تلفنی",
          titleColor: Colors.white,
          subtitle: "مستقیما با آگهی دهنده تماس بگیرید.",
          subTitleColor: Colors.white,
          backgroundColor: Colors.blue,
          onTap: () =>
              _makePhoneCall(controller.advertizerNumber.value.toString()),
        ));
      }
      if (controller.chatbool.value) {
        controller.contact.add(ExpandableFabMenuItem(
          child: const Icon(Iconsax.sms_tracking, color: Colors.white),
          title: "چت",
          titleColor: Colors.white,
          subtitle: "یک گفتگوی درون برنامه ای شروع کنید.",
          subTitleColor: Colors.white,
          backgroundColor: Colors.indigo,
          onTap: () => debugPrint('FOURTH CHILD'),
        ));
      }
      if (controller.instagrambool.value) {
        controller.contact.add(ExpandableFabMenuItem(
          child: const Icon(Iconsax.instagram, color: Colors.white),
          title: "اینستاگرام",
          titleColor: Colors.white,
          subtitle: 'به صفحه اینستاگرام این آگهی بروید.',
          subTitleColor: Colors.white,
          backgroundColor: Colors.redAccent,
          onTap: () => _launchInstagram(controller.instagramid.value),
        ));
      }
    }
  }
}
