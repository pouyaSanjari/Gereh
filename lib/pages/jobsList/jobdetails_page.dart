import 'package:cached_network_image/cached_network_image.dart';
import 'package:digit_to_persian_word/digit_to_persian_word.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:sarkargar/components/rounded.button.dart';
import 'package:sarkargar/services/database.dart';
import 'package:sarkargar/components/image.viewer.dart';
import 'package:sarkargar/controllers/job_details_controller.dart';
import 'package:sarkargar/services/uiDesign.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants/colors.dart';

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
  OverlayEntry? entry;

  @override
  Widget build(BuildContext context) {
    var images = widget.images;
    var ad = widget.adDetails;
    // printInfo(info: ad.toString());

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

    bool isHiring = controller.adType.value == '0' ? true : false;
    bool isHiringDayli = controller.hiringtype.value == '0' ? true : false;
    bool menVisibility = controller.men.value == '0' ? false : true;
    bool womenVisibility = controller.women.value == '0' ? false : true;
    controller.phonebool.value = ad['phonebool'] == '0' ? false : true;
    controller.smsbool.value = ad['smsbool'] == '0' ? false : true;
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
          floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
          appBar: appBar(context),
          floatingActionButton: FloatingActionButton.extended(
              backgroundColor: MyColors.red,
              onPressed: () {
                if (entry == null) {
                  showContactInfo();
                } else {
                  hideOverlay(false);
                }
              },
              label: Row(
                children: const [
                  Icon(Iconsax.call, size: 18),
                  Text(' برقراری ارتباط'),
                ],
              )),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SingleChildScrollView(
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
                        Expanded(
                          child: Text(
                            uiDesign.timeFunction(controller.time.value),
                            style: uiDesign.descriptionsTextStyle(),
                          ),
                        ),
                        Container(
                          height: 20,
                          width: 55,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color:
                                  isHiring ? MyColors.orange : MyColors.blue),
                          child: Center(
                            child: Text(
                              isHiring ? 'استخدام' : 'تبلیغ',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Visibility(
                          visible: isHiring,
                          child: Container(
                            height: 20,
                            width: 55,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: isHiringDayli
                                    ? MyColors.red
                                    : MyColors.blueGrey),
                            child: Center(
                              child: Text(
                                isHiringDayli ? 'روزمزد' : 'ماهیانه',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
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
                    const SizedBox(height: 10),
                    Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                            color: MyColors.bluewhite,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          controller.descs.value,
                          style: const TextStyle(fontSize: 15),
                        )),
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
                                      'https://api.neshan.org/v2/static?key=service.3701bff2e5814681af87132d10abe63a&type=dreamy&zoom=15&center=${controller.locationlat.value},${controller.locationlon.value}&width=700&height=400&marker=red'),
                            ),
                          )
                        //در صورتی که نقشه نداشته باشه کانتینر خالی نشون میده
                        : Container(),
                    Visibility(
                        visible: controller.locationbool.value,
                        child: Center(
                          child: Text(
                              'با کلیک بر بروی نقشه می توانید محل آگهی را مشاهده کنید.',
                              style: uiDesign.descriptionsTextStyle()),
                        )),
                    const Divider(height: 50),
                    Container(
                      width: 400,
                      decoration: BoxDecoration(
                        color: Colors.grey[350],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(children: const [
                          Text(
                            'تذکر مهم!',
                            style: TextStyle(color: MyColors.red, fontSize: 18),
                          ),
                          Text(
                            'کاربر گرامی لطفا توجه فرمائید که سایت و اپلیکیشن سرکارگر هیچگونه مسئولیتی در قبال صحت اطلاعات درج شده در آگهی ندارد. لذا خواهشمند است قبل از مراجعه حضوری از صحت اطلاعات آگهی اطمینان حاصل فرمائید. همچنین از پرداخت مبلغ قبل از مراجعه حضوری و بدون اطمینان از صحت موارد مندرج در آگهی بپرهیزید.',
                            textAlign: TextAlign.justify,
                          )
                        ]),
                      ),
                    ),
                    const SizedBox(height: 70)
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
      return Container();
    } else {
      return SizedBox(
        height: 250,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: InkWell(
                onTap: () => Get.to(
                  ImageViewerPage(images: widget.images),
                ),
                child: CachedNetworkImage(
                    width: MediaQuery.of(context).size.width,
                    maxHeightDiskCache: 687,
                    maxWidthDiskCache:
                        MediaQuery.of(context).size.width.toInt(),
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

  void showContactInfo() {
    entry = OverlayEntry(
      builder: (context) => Obx(
        () => AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          bottom: 20,
          left: controller.contactInfoPosition.value ? 10 : -100,
          curve: Curves.linear,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.black26, borderRadius: BorderRadius.circular(50)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Visibility(
                    visible: controller.phonebool.value,
                    child: MyRoundedButton(
                      icon: const Icon(Iconsax.call, color: Colors.white),
                      backColor: MyColors.green,
                      text: 'تماس',
                      onClick: () {
                        _makePhoneCall(
                            controller.advertizerNumber.value.toString());
                      },
                    ),
                  ),
                  Visibility(
                    visible: controller.smsbool.value,
                    child: MyRoundedButton(
                      icon: const Icon(Iconsax.sms, color: Colors.white),
                      backColor: MyColors.blue,
                      text: 'پیامک',
                      onClick: () {
                        _textMe(controller.advertizerNumber.value);
                      },
                    ),
                  ),
                  Visibility(
                    visible: controller.instagrambool.value,
                    child: MyRoundedButton(
                      icon: const Icon(Iconsax.instagram, color: Colors.white),
                      backColor: MyColors.red,
                      text: 'اینستاگرام',
                      onClick: () {
                        _launchInstagram(controller.instagramid.value);
                      },
                    ),
                  ),
                  Visibility(
                    visible: controller.chatbool.value,
                    child: MyRoundedButton(
                      icon:
                          const Icon(Iconsax.sms_tracking, color: Colors.white),
                      backColor: MyColors.orange,
                      text: 'چت',
                      onClick: () {},
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    final overlay = Overlay.of(context)!;
    overlay.insert(entry!);
    Future.delayed(
      const Duration(milliseconds: 50),
      () {
        controller.contactInfoPosition.value = true;
      },
    );
  }

  void hideOverlay(bool onDispose) async {
    await Future.delayed(
      const Duration(milliseconds: 1),
      () {
        controller.contactInfoPosition.value = false;
      },
    );
    await Future.delayed(
      // اگه زمان دیسپوز باشه سریعتر بسته میشه
      Duration(milliseconds: onDispose ? 100 : 300),
      () {
        entry?.remove();
        entry = null;
      },
    );
  }

  @override
  void dispose() async {
    hideOverlay(true);
    // Overlay.of(context)?.deactivate();

    // entry?.remove();
    // entry = null;
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }
}
