import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gereh/services/hive_actions.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:gereh/components/buttons/button.dart';
import 'package:gereh/components/other/icon.container.dart';
import 'package:gereh/components/pages/image_viewer.dart';
import 'package:gereh/components/other/my.container.dart';
import 'package:gereh/components/other/my_row2.dart';
import 'package:gereh/constants/colors.dart';
import 'package:gereh/constants/my_strings.dart';
import 'package:gereh/controllers/jobs.details.test.controller.dart';
import 'package:gereh/models/adv_model.dart';
import 'package:gereh/services/ui_design.dart';
import 'package:url_launcher/url_launcher.dart';

class JobDetails extends GetView<JobDetailsTestController> {
  final AdvModel mod;
  const JobDetails({
    super.key,
    required this.mod,
  });
  @override
  Widget build(BuildContext context) {
    bool isHiring = mod.adType == '1' ? false : true;
    return MaterialApp(
      theme: UiDesign.cTheme(),
      debugShowCheckedModeBanner: false,
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            actions: [SaveButton(data: mod), const SizedBox(width: 10)],
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
            scrolledUnderElevation: 3,
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
                              imagesView(context, mod.images),
                              const SizedBox(height: 30),
                              Text(
                                mod.title,
                                style: const TextStyle(
                                  color: MyColors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Icon(
                                    Iconsax.clock,
                                    color: Colors.grey,
                                    size: 15,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    MyStrings.timeFunction(mod.time),
                                    style: const TextStyle(
                                        color: Colors.grey, fontSize: 12),
                                  ),
                                ],
                              ),
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
                                      ),
                                      IconContainer(
                                        title: 'دستمزد',
                                        value: mod.price == 'توافقی'
                                            ? 'توافقی'
                                            : MyStrings.digi(mod.price == ''
                                                ? mod.price
                                                : mod.price),
                                        icon: Iconsax.dollar_square,
                                        iconColor: MyColors.red,
                                      ),
                                      IconContainer(
                                        title: 'شیوه پرداخت',
                                        value: mod.payMethod,
                                        icon: Iconsax.wallet_money,
                                        iconColor: MyColors.orange,
                                      ),
                                      IconContainer(
                                        title: 'نوع همکاری',
                                        value: mod.workType,
                                        icon: Iconsax.home_wifi5,
                                        iconColor: MyColors.blue,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
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
                                            double.parse(mod.lat),
                                            double.parse(mod.lon));
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
                                                    iconColor: Colors.lightBlue,
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
                                                      title: 'اینستاگرام',
                                                      value: '',
                                                      icon: Iconsax.instagram,
                                                      iconColor: MyColors.red,
                                                    ),
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
                                                    ),
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
                                                      icon:
                                                          Iconsax.sms_tracking,
                                                      iconColor:
                                                          MyColors.orange,
                                                    ),
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
                                                  ),
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
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          MyRow(
                                            icon: Iconsax.call,
                                            text:
                                                'تماس تلفنی با: ${mod.callNumber}',
                                            background: MyColors.green,
                                          ),
                                          MyRow(
                                            icon: Iconsax.sms,
                                            text:
                                                'ارسال پیامک به: ${mod.smsNumber}',
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
                  () => ImageViewer(images: images),
                ),
                child: CachedNetworkImage(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    maxHeightDiskCache:
                        MediaQuery.of(context).size.height.toInt(),
                    maxWidthDiskCache:
                        MediaQuery.of(context).size.width.toInt(),
                    imageUrl: images[0]['image'],
                    fit: BoxFit.cover),
              ),
            ),
            Container(
              width: 35,
              height: 25,
              decoration: const BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(12),
                      topLeft: Radius.circular(12))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Iconsax.gallery5,
                    color: Colors.white,
                    size: 18,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    images.length.toString(),
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ],
              ),
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

class SaveButton extends StatefulWidget {
  final AdvModel data;
  const SaveButton({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  State<SaveButton> createState() => _SaveButtonState();
}

class _SaveButtonState extends State<SaveButton> {
  bool isAvailable = false;

  void checkAvailability() async {
    isAvailable = await HiveActions.checkIfObjectExists(
        advModel: widget.data, box: 'bookmarks');
    setState(() {});
  }

  @override
  void initState() {
    checkAvailability();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      radius: 10,
      splashColor: isAvailable
          ? Colors.black.withOpacity(0.3)
          : MyColors.red.withOpacity(0.3),
      onTap: () async {
        var hive = await Hive.openBox('bookmarks');
        isAvailable
            ? HiveActions.deleteBookmark(advModel: widget.data, hive: hive)
            : HiveActions.addBookmark(advModel: widget.data, hive: hive);
        checkAvailability();
      },
      child: SizedBox(
        child: Icon(
          isAvailable ? FontAwesomeIcons.bookBookmark : FontAwesomeIcons.book,
          color: isAvailable ? MyColors.red : Colors.black,
        ),
      ),
    );
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
