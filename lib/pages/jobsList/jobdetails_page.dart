import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:sarkargar/components/buttons/rounded.button.dart';
import 'package:sarkargar/components/image.viewer.dart';
import 'package:sarkargar/components/my.container.dart';
import 'package:sarkargar/controllers/job_details_controller.dart';
import 'package:sarkargar/services/uiDesign.dart';

import '../../constants/colors.dart';

class JobDetails extends StatefulWidget {
  final Map adDetails;
  final List images;
  const JobDetails({super.key, required this.adDetails, required this.images});

  @override
  State<JobDetails> createState() => _JobDetailsState();
}

class _JobDetailsState extends State<JobDetails> {
  UiDesign uiDesign = UiDesign();
  final controller = Get.put(JobDetailsController(), permanent: true);
  OverlayEntry? entry;

  @override
  Widget build(BuildContext context) {
    var images = widget.images;
    controller.initialData(ad: widget.adDetails);

    bool isHiring = controller.adType.value == '0' ? true : false;
    bool isHiringDayli = controller.hiringtype.value == '0' ? true : false;
    bool menVisibility = controller.men.value == '0' ? false : true;
    bool womenVisibility = controller.women.value == '0' ? false : true;

    controller.getAdvertizer();

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
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyContainer(
                        contentPadding: 0,
                        color: MyColors.black,
                        widgets: [imagesView(context, images)]),
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
                        Visibility(
                          visible: isHiring,
                          child: MyContainer(
                            height: 35,
                            width: 80,
                            contentPadding: 0,
                            color: isHiring ? MyColors.orange : MyColors.blue,
                            widgets: [
                              Center(
                                child: Text(
                                  isHiring ? 'استخدام' : 'تبلیغ',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 13),
                                ),
                              )
                            ],
                          ),
                        ),
                        Visibility(
                          visible: isHiring,
                          child: MyContainer(
                            height: 35,
                            width: 80,
                            contentPadding: 0,
                            color: isHiringDayli
                                ? MyColors.red
                                : MyColors.blueGrey,
                            widgets: [
                              Center(
                                child: Text(
                                  isHiringDayli ? 'روزمزد' : 'ماهیانه',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 13),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        cardWidget(
                          isMen: true,
                          visible: menVisibility,
                          isHiringDayli: isHiringDayli,
                          price: controller.mprice.value,
                          count: controller.men.value,
                        ),
                        cardWidget(
                          isMen: false,
                          visible: womenVisibility,
                          isHiringDayli: isHiringDayli,
                          count: controller.women.value,
                          price: controller.wprice.value,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
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
                    const SizedBox(height: 20),
                    Text(
                      textAlign: TextAlign.justify,
                      controller.descs.value,
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
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
                    const SizedBox(height: 20),
                    MyContainer(color: MyColors.red, widgets: [
                      Row(
                        children: const [
                          Icon(
                            Iconsax.warning_2,
                            color: Colors.white,
                          ),
                          Expanded(
                              child: Center(
                                  child: Text(
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18),
                                      'تذکر مهم!'))),
                          Icon(Iconsax.warning_2, color: Colors.white)
                        ],
                      ),
                      const Text(
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.justify,
                        'کاربر گرامی لطفا توجه فرمائید که سایت و اپلیکیشن سرکارگر هیچگونه مسئولیتی در قبال صحت اطلاعات درج شده در آگهی ندارد. لذا خواهشمند است قبل از مراجعه حضوری از صحت اطلاعات آگهی اطمینان حاصل فرمائید. همچنین از پرداخت مبلغ قبل از مراجعه حضوری و بدون اطمینان از صحت موارد مندرج در آگهی بپرهیزید.',
                      )
                    ]),
                    const SizedBox(height: 70),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Visibility cardWidget(
      {required bool visible,
      required bool isHiringDayli,
      required String count,
      required String price,
      required bool isMen}) {
    return Visibility(
      visible: visible,
      child: MyContainer(
        color: isMen
            ? const Color.fromARGB(255, 100, 181, 246)
            : const Color.fromARGB(255, 127, 78, 180),
        width: 150,
        height: 150,
        widgets: [
          Icon(
            isMen ? Iconsax.man : Iconsax.woman,
            size: 30,
            color: Colors.white,
          ),
          Row(
            children: [
              const Icon(
                Iconsax.people5,
                size: 18,
              ),
              Expanded(
                child: Center(
                  child: Text(
                    '$count نفر ${isMen ? 'آقا' : 'خانم'}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              const Icon(
                Iconsax.dollar_circle4,
                size: 18,
              ),
              Expanded(
                child: Center(
                  child: Text(
                    price == ''
                        ? 'توافقی'
                        : uiDesign.digi(
                            price,
                          ),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Icon(
                Iconsax.clock5,
                size: 18,
              ),
              Expanded(
                child: Center(
                  child: Text(
                    isHiringDayli ? '(روزانه)' : '(ماهیانه)',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
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
                  transition: Transition.rightToLeft,
                  () => ImageViewerPage(images: widget.images),
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
                        controller.makePhoneCall();
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
                        controller.textMe();
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
                        controller.launchInstagram();
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
  void dispose() {
    hideOverlay(true);
    super.dispose();
  }
}
