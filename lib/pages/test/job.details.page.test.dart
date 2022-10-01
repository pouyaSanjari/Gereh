import 'package:cached_network_image/cached_network_image.dart';
import 'package:digit_to_persian_word/digit_to_persian_word.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:sarkargar/components/icon.container.dart';
import 'package:sarkargar/components/image.viewer.dart';
import 'package:sarkargar/components/my.container.dart';
import 'package:sarkargar/constants/colors.dart';
import 'package:sarkargar/controllers/jobs.details.test.controller.dart';
import 'package:sarkargar/services/uiDesign.dart';
import 'package:url_launcher/url_launcher.dart';

class JobDetailsPageTest extends StatelessWidget {
  final Map adDetails;
  final List images;
  JobDetailsPageTest(
      {super.key, required this.adDetails, required this.images});
  final controller = Get.put(JobDetailsTestController());
  @override
  Widget build(BuildContext context) {
    // adDetails.forEach((key, value) {
    //   print(key + ' === ' + value);
    // });

    bool isHiring = adDetails['adtype'] == '1' ? false : true;
    bool hiringDayli = adDetails['hiringtype'] == '0' ? true : false;

    return MaterialApp(
      theme: UiDesign().cTheme(),
      debugShowCheckedModeBanner: false,
      home: Stack(
        children: [
          SafeArea(
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Scaffold(
                backgroundColor: Colors.white,
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
                body: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          imagesView(context, images),
                          const SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: Text(
                              adDetails['title'],
                              style: const TextStyle(
                                color: MyColors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Visibility(
                            visible: isHiring,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 20.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  IconContainer(
                                    title: 'جنسیت',
                                    value: gender(adDetails['gender']),
                                    icon: Iconsax.people,
                                    iconColor: MyColors.green,
                                    backgroundColor: const Color.fromARGB(
                                        158, 220, 239, 207),
                                  ),
                                  IconContainer(
                                    title: 'دستمزد',
                                    value: adDetails['mprice'] == '' &&
                                            adDetails['wprice'] == ''
                                        ? 'توافقی'
                                        : digi(adDetails['mprice'] == ''
                                            ? adDetails['wprice']
                                            : adDetails['mprice']),
                                    icon: Iconsax.wallet_1,
                                    backgroundColor: const Color.fromARGB(
                                        140, 251, 221, 217),
                                    iconColor: MyColors.red,
                                  ),
                                  IconContainer(
                                    title: 'نوع استخدام',
                                    value: adDetails['hiringtype'] == '0'
                                        ? 'روزمزد'
                                        : 'ماهیانه',
                                    icon: Iconsax.brifecase_timer,
                                    iconColor: MyColors.orange,
                                    backgroundColor: const Color.fromARGB(
                                        105, 254, 236, 196),
                                  ),
                                  IconContainer(
                                    title: 'شهر',
                                    value: adDetails['city'],
                                    icon: Iconsax.map_1,
                                    iconColor: MyColors.blue,
                                    backgroundColor: MyColors.bluewhite,
                                  )
                                ],
                              ),
                            ),
                          ),
                          const Divider(),
                          const Text(
                            'توضیحات',
                            style: TextStyle(fontSize: 20),
                          ),
                          const SizedBox(height: 5),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(adDetails['descs'],
                                textAlign: TextAlign.justify),
                          ),
                          const SizedBox(height: 10),
                          adDetails['locationbool'] == '1'
                              ? InkWell(
                                  onTap: () {
                                    MapsLauncher.launchCoordinates(
                                        double.parse(adDetails['locationlat']),
                                        double.parse(adDetails['locationlon']));
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: CachedNetworkImage(
                                        imageUrl:
                                            'https://api.neshan.org/v2/static?key=service.3701bff2e5814681af87132d10abe63a&'
                                            'type=dreamy&zoom=15&center=${adDetails['locationlat']},${adDetails['locationlon']}'
                                            '&width=700&height=400&marker=red'),
                                  ),
                                )

                              //در صورتی که نقشه نداشته باشه کانتینر خالی نشون میده
                              : Container(),
                          const SizedBox(height: 30),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color.fromARGB(71, 255, 178, 168),
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
                        ]),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
              bottom: 0,
              height: 60,
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  InkWell(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Material(
                        color: Colors.white,
                        child: Container(
                          decoration: BoxDecoration(
                              boxShadow: const [
                                BoxShadow(
                                  spreadRadius: 0,
                                  blurRadius: 2,
                                  offset: Offset(-1, 2),
                                  color: Colors.grey,
                                ),
                              ],
                              color: MyColors.black,
                              borderRadius: BorderRadius.circular(10)),
                          child: const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.0),
                              child: Text(
                                'ارسال رزومه',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
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
                                                    iconColor: Colors.lightBlue,
                                                    backgroundColor:
                                                        Color.fromARGB(104, 155,
                                                            223, 255)),
                                              ),
                                            ),
                                            Visibility(
                                              visible: true,
                                              child: InkWell(
                                                onTap: () {},
                                                child: const Padding(
                                                  padding: EdgeInsets.symmetric(
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
                                                  padding: EdgeInsets.symmetric(
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
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 15.0),
                                                  child: IconContainer(
                                                      title: 'چت',
                                                      value: '',
                                                      icon:
                                                          Iconsax.sms_tracking,
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
                                                  iconColor: Colors.deepPurple,
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
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Material(
                          color: Colors.white,
                          child: Container(
                            decoration: BoxDecoration(
                                boxShadow: const [
                                  BoxShadow(
                                    spreadRadius: 0,
                                    blurRadius: 2,
                                    offset: Offset(-1, 2),
                                    color: MyColors.red,
                                  ),
                                ],
                                color: MyColors.red,
                                borderRadius: BorderRadius.circular(10)),
                            child: const Center(
                              child: Text(
                                'تماس با آگهی دهنده',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ))
        ],
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
    await launch("https://www.instagram.com/${id}/", universalLinksOnly: true);
  }

  String digi(String number) {
    String digit = DigitToWord.toWord(number, StrType.NumWord, isMoney: true);
    return digit;
  }

  String gender(String gender) {
    print(gender);
    if (gender == '0') {
      return 'آقا';
    } else if (gender == '1') {
      return 'خانم';
    } else {
      return 'مهم نیست';
    }
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
