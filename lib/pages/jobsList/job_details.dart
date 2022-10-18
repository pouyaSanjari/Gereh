import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:sarkargar/components/buttons/button.dart';
import 'package:sarkargar/components/other/icon.container.dart';
import 'package:sarkargar/components/pages/image.viewer.dart';
import 'package:sarkargar/components/other/my.container.dart';
import 'package:sarkargar/components/other/my_row2.dart';
import 'package:sarkargar/constants/colors.dart';
import 'package:sarkargar/constants/my_strings.dart';
import 'package:sarkargar/controllers/jobs.details.test.controller.dart';
import 'package:sarkargar/models/adv_model.dart';
import 'package:sarkargar/services/ui_design.dart';
import 'package:url_launcher/url_launcher.dart';

class JobDetails extends GetView<JobDetailsTestController> {
  final Map adDetails;
  final List images;
  const JobDetails({super.key, required this.adDetails, required this.images});
  @override
  Widget build(BuildContext context) {
    log(adDetails.toString());
    AdvModel mod = AdvModel.fromJson(adDetails);
    bool isHiring = mod.adType == '1' ? false : true;
    return MaterialApp(
      theme: UiDesign.cTheme(),
      debugShowCheckedModeBanner: false,
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            actions: [
              InkWell(
                onTap: () {},
                child: const SizedBox(
                  width: 50,
                  child: Icon(
                    Iconsax.save_add,
                    color: Colors.black,
                  ),
                ),
              )
            ],
            leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Iconsax.arrow_right_3,
                color: MyColors.black,
              ),
            ),
            elevation: 0,
            backgroundColor: Colors.white,
            title: const Text(
              'جزئیات آگهی',
            ),
            centerTitle: true,
          ),
          body: Stack(
            children: [
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              imagesView(context, images),
                              const SizedBox(height: 30),
                              Text(
                                mod.title,
                                style: const TextStyle(
                                  color: MyColors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  MyStrings.timeFunction(mod.time),
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Visibility(
                                visible: isHiring,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 20.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      IconContainer(
                                        title: 'جنسیت',
                                        value: mod.gender,
                                        icon: mod.gender == 'آقا'
                                            ? Iconsax.man
                                            : Iconsax.woman,
                                        iconColor: MyColors.green,
                                        backgroundColor: const Color.fromARGB(
                                            158, 220, 239, 207),
                                      ),
                                      IconContainer(
                                        title: 'دستمزد',
                                        value: mod.price == 'توافقی'
                                            ? 'توافقی'
                                            : MyStrings.digi(mod.price == ''
                                                ? mod.price
                                                : mod.price),
                                        icon: Iconsax.dollar_square,
                                        backgroundColor: const Color.fromARGB(
                                            140, 251, 221, 217),
                                        iconColor: MyColors.red,
                                      ),
                                      IconContainer(
                                        title: 'شیوه پرداخت',
                                        value: mod.payMethod,
                                        icon: Iconsax.wallet_money,
                                        iconColor: MyColors.orange,
                                        backgroundColor: const Color.fromARGB(
                                            105, 254, 236, 196),
                                      ),
                                      IconContainer(
                                        title: 'نوع همکاری',
                                        value: mod.workType,
                                        icon: Iconsax.home_wifi5,
                                        iconColor: MyColors.blue,
                                        backgroundColor: MyColors.bluewhite,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 30),
                              MyRow2(
                                icon: Iconsax.profile_2user,
                                title: 'عنوان شغلی:',
                                value: mod.profission,
                              ),
                              const Divider(
                                height: 35,
                              ),
                              MyRow2(
                                icon: Iconsax.category,
                                title: 'دسته بندی:',
                                value: mod.category,
                              ),
                              const Divider(height: 35),
                              const Text(
                                'توضیحات',
                                style: TextStyle(fontSize: 20),
                              ),
                              const SizedBox(height: 5),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(mod.descs,
                                    textAlign: TextAlign.justify),
                              ),
                              const SizedBox(height: 10),
                              mod.locationBool
                                  ? InkWell(
                                      onTap: () {
                                        MapsLauncher.launchCoordinates(
                                            mod.lat, mod.lon);
                                      },
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              'https://api.neshan.org/v2/static?key=service.3701bff2e5814681af87132d10abe63a&'
                                              'type=dreamy&zoom=15&center=${mod.lat},${mod.lon}'
                                              '&width=700&height=400&marker=red',
                                        ),
                                      ),
                                    )

                                  //در صورتی که نقشه نداشته باشه کانتینر خالی نشون میده
                                  : Container(),
                              const SizedBox(height: 30),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color:
                                      const Color.fromARGB(71, 255, 178, 168),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('در این آگهی تخلفی می بینید؟'),
                                      TextButton.icon(
                                          onPressed: () {},
                                          icon: const Text('گزارش آگهی'),
                                          label: const Icon(Iconsax.danger))
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 80),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                height: 60,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    const SizedBox(width: 10),
                    Expanded(
                      child: MyButton(
                        // height: 50,
                        onClick: () {
                          showModalBottomSheet(
                            backgroundColor: Colors.transparent,
                            context: context,
                            builder: (context) {
                              return SingleChildScrollView(
                                child: Container(
                                  decoration: const BoxDecoration(
                                      color: Color(0xfff2f5fc),
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(15),
                                      )),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 6,
                                            width: 40,
                                            decoration: BoxDecoration(
                                                color: Colors.grey,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                          ),
                                          const SizedBox(height: 8),
                                          Wrap(
                                            alignment: WrapAlignment.center,
                                            children: [
                                              InkWell(
                                                onTap: () {},
                                                child: const Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 15.0),
                                                  child: IconContainer(
                                                      title: 'تلگرام',
                                                      value: '',
                                                      icon: FontAwesomeIcons
                                                          .telegram,
                                                      iconColor:
                                                          Colors.lightBlue,
                                                      backgroundColor:
                                                          Color.fromARGB(104,
                                                              155, 223, 255)),
                                                ),
                                              ),
                                              Visibility(
                                                visible: true,
                                                child: InkWell(
                                                  onTap: () {},
                                                  child: const Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 15.0),
                                                    child: IconContainer(
                                                        title: 'اینستاگرام',
                                                        value: '',
                                                        icon: Iconsax.instagram,
                                                        iconColor: MyColors.red,
                                                        backgroundColor:
                                                            Color.fromARGB(87,
                                                                250, 170, 160)),
                                                  ),
                                                ),
                                              ),
                                              Visibility(
                                                visible: true,
                                                child: InkWell(
                                                  onTap: () {},
                                                  child: const Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 15.0),
                                                    child: IconContainer(
                                                        title: 'واتس اپ',
                                                        value: '',
                                                        icon: FontAwesomeIcons
                                                            .whatsapp,
                                                        iconColor: Colors.green,
                                                        backgroundColor:
                                                            Color.fromARGB(67,
                                                                114, 168, 116)),
                                                  ),
                                                ),
                                              ),
                                              Visibility(
                                                visible: true,
                                                child: InkWell(
                                                  onTap: () {},
                                                  child: const Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 15.0),
                                                    child: IconContainer(
                                                        title: 'چت',
                                                        value: '',
                                                        icon: Iconsax
                                                            .sms_tracking,
                                                        iconColor:
                                                            MyColors.orange,
                                                        backgroundColor:
                                                            Color.fromARGB(68,
                                                                232, 202, 138)),
                                                  ),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {},
                                                child: const Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 15.0),
                                                  child: IconContainer(
                                                      title: 'وبسایت',
                                                      value: '',
                                                      icon: Iconsax.global,
                                                      iconColor: Colors.brown,
                                                      backgroundColor:
                                                          Color.fromARGB(
                                                              60, 107, 99, 40)),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {},
                                                child: const Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 15.0),
                                                  child: IconContainer(
                                                    title: 'ایمیل',
                                                    value: '',
                                                    icon: Icons
                                                        .alternate_email_outlined,
                                                    iconColor:
                                                        Colors.deepPurple,
                                                    backgroundColor:
                                                        Color.fromARGB(
                                                            50, 106, 60, 120),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          MyRow(
                                            icon: Iconsax.call,
                                            text:
                                                'تماس تلفنی با: ${controller.phoneNumber.value}',
                                            background: MyColors.green,
                                          ),
                                          MyRow(
                                            icon: Iconsax.sms,
                                            text:
                                                'ارسال پیامک به: ${controller.phoneNumber.value}',
                                            background: MyColors.blue,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        radius: 5,
                        fillColor: Colors.blueAccent,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Iconsax.call_calling5, color: Colors.white),
                            SizedBox(width: 5),
                            Text(
                              'تماس با آگهی دهنده',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    MyButton(
                      radius: 5,
                      fillColor: Colors.grey[300],
                      onClick: () {},
                      child: Row(children: const [
                        Icon(
                          Iconsax.paperclip,
                          color: MyColors.black,
                        ),
                        SizedBox(width: 5),
                        Text(
                          'ارسال رزومه',
                          style: TextStyle(color: Colors.black),
                        )
                      ]),
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
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
                  transition: Transition.rightToLeftWithFade,
                  () => ImageViewerPage(images: images),
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

  Future<void> launchInstagram({required String id}) async {
    // ignore: deprecated_member_use
    await launch("https://www.instagram.com/$id/", universalLinksOnly: true);
  }
}

class MyRow extends StatelessWidget {
  final Function()? onTap;
  final IconData icon;
  final String text;
  final Color background;
  const MyRow({
    Key? key,
    this.onTap,
    required this.icon,
    required this.text,
    required this.background,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: MyContainer(
        height: 70,
        color: background,
        widgets: [
          Row(
            children: [
              const SizedBox(width: 10),
              Icon(
                icon,
                size: 25,
                color: Colors.grey[100],
              ),
              const SizedBox(width: 10),
              Text(
                text,
                style: const TextStyle(color: Colors.white, fontSize: 17),
              )
            ],
          )
        ],
      ),
    );
  }
}
