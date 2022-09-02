import 'package:cached_network_image/cached_network_image.dart';
import 'package:digit_to_persian_word/digit_to_persian_word.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:sarkargar/services/database.dart';
import 'package:sarkargar/services/image_viewer.dart';
import 'package:sarkargar/controllers/job_details_controller.dart';
import 'package:sarkargar/services/uiDesign.dart';
import 'package:url_launcher/url_launcher.dart';

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
    bool isHiring = controller.adType.value == '1' ? false : true;
    controller.hiringtype.value = ad['hiringtype'];
    bool isHiringDayli = controller.hiringtype.value == '1' ? true : false;
    controller.title.value = ad['title'];
    controller.category.value = ad['category'];
    controller.city.value = ad['city'];
    controller.address.value = ad['address'];
    controller.locationlat.value = ad['locationlat'];
    controller.locationlon.value = ad['locationlon'];
    controller.men.value = ad['men'];
    bool menVisibility =
        controller.men.value == '0' && controller.hiringtype.value == '0'
            ? false
            : true;
    controller.women.value = ad['women'];
    bool womenVisibility =
        controller.women.value == '0' && controller.hiringtype.value == '0'
            ? false
            : true;
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
                        Text(
                          uiDesign.timeFunction(controller.time.value),
                          style: uiDesign.descriptionsTextStyle(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Visibility(
                            visible: controller.phonebool.value,
                            child: uiDesign.roundedIconWithText(
                              icon:
                                  const Icon(Iconsax.call, color: Colors.white),
                              backColor: uiDesign.secondColor(),
                              text: 'تماس',
                              onClick: () {
                                _makePhoneCall(controller.advertizerNumber.value
                                    .toString());
                              },
                            ),
                          ),
                          uiDesign.roundedIconWithText(
                            icon: const Icon(Iconsax.sms, color: Colors.white),
                            backColor: uiDesign.fifthColor(),
                            text: 'پیامک',
                            onClick: () {
                              _textMe(controller.advertizerNumber.value);
                            },
                          ),
                          uiDesign.roundedIconWithText(
                            icon: const Icon(Iconsax.instagram,
                                color: Colors.white),
                            backColor: uiDesign.firstColor(),
                            text: 'اینستاگرام',
                            onClick: () {
                              _launchInstagram(controller.instagramid.value);
                            },
                          ),
                          uiDesign.roundedIconWithText(
                            icon: const Icon(Iconsax.sms_tracking,
                                color: Colors.white),
                            backColor: uiDesign.forthColor(),
                            text: 'چت',
                            onClick: () {},
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    row(
                        icon: Iconsax.category_2,
                        title: 'دسته بندی',
                        value: controller.category.value),
                    const Divider(height: 30),
                    row(
                        icon: Iconsax.location,
                        title: "آدرس",
                        value: controller.address.value == ''
                            ? controller.city.value
                            : controller.address.value),
                    const Divider(height: 30),
                    Visibility(
                      visible: menVisibility,
                      child: row(
                          icon: Iconsax.man,
                          title: 'تعداد نفرات آقا',
                          value: '${controller.men.value} نفر'),
                    ),
                    Visibility(
                        visible: menVisibility,
                        child: const Divider(height: 30)),
                    Visibility(
                      visible: menVisibility,
                      child: row(
                        icon: Iconsax.dollar_circle,
                        title: 'مبلغ پیشنهادی',
                        value: controller.mprice.value == ''
                            ? 'توافقی'
                            : uiDesign.digi(controller.mprice.value),
                      ),
                    ),
                    Visibility(
                        visible: menVisibility,
                        child: const Divider(height: 30)),
                    Visibility(
                      visible: womenVisibility,
                      child: row(
                          icon: Iconsax.woman,
                          title: 'تعداد نفرات خانم',
                          value: '${controller.women.value} نفر'),
                    ),
                    Visibility(
                        visible: womenVisibility,
                        child: const Divider(height: 30)),
                    Visibility(
                      visible: womenVisibility,
                      child: row(
                          icon: Iconsax.dollar_circle,
                          title: 'مبلغ پیشنهادی',
                          value: controller.wprice.value == ''
                              ? 'توافقی'
                              : uiDesign.digi(controller.wprice.value)),
                    ),
                    Visibility(
                        visible: womenVisibility,
                        child: const Divider(height: 30)),
                    Text('توضیحات', style: uiDesign.titleTextStyle()),
                    const SizedBox(height: 15),
                    Text(controller.descs.value),
                    const SizedBox(height: 15),
                    controller.locationbool.value
                        ? InkWell(
                            onTap: () {
                              MapsLauncher.launchCoordinates(
                                  double.parse(controller.locationlat.value),
                                  double.parse(controller.locationlon.value));
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                  imageUrl:
                                      'https://api.neshan.org/v2/static?key=service.3701bff2e5814681af87132d10abe63a&type=dreamy&zoom=14&center=${controller.locationlat.value},${controller.locationlon.value}&width=700&height=400&marker=red'),
                            ),
                          )
                        : Container(),
                    Visibility(
                        visible: controller.locationbool.value,
                        child: Center(
                          child: Text(
                              'با کلیک بر بروی نقشه می توانید محل آگهی را مشاهده کنید.',
                              style: uiDesign.descriptionsTextStyle()),
                        )),
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
    // ignore: deprecated_member_use
    await launch("https://www.instagram.com/$instagramID/",
        universalLinksOnly: true);
  }

  _textMe(String phone) async {
    // Android
    var uri = 'sms:$phone';
    await launchUrl(Uri.parse(uri));
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
}
