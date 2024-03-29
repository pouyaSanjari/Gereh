import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gereh/components/buttons/save_button.dart';
import 'package:gereh/constants/my_text_styles.dart';
import 'package:gereh/pages/profile_page/controller/saved_ads_page_controller.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:gereh/components/buttons/my_button.dart';
import 'package:gereh/components/other/icon_container.dart';
import 'package:gereh/components/imageViewer/view/image_viewer.dart';
import 'package:gereh/components/other/my_container.dart';
import 'package:gereh/components/other/my_row2.dart';
import 'package:gereh/constants/my_colors.dart';
import 'package:gereh/constants/my_strings.dart';
import 'package:gereh/pages/jobsList/controller/jobs_details_controller.dart';
import 'package:gereh/models/adv_model.dart';
import 'package:gereh/services/ui_design.dart';
import 'package:url_launcher/url_launcher.dart';

class JobDetails extends GetView<JobDetailsTestController> {
  const JobDetails({
    super.key,
    required this.data,
  });
  final AdvModel data;
  @override
  Widget build(BuildContext context) {
    bool isHiring = data.adType == '1' ? false : true;
    List sharayet = jsonDecode(data.sharayet);
    List mazaya = jsonDecode(data.mazaya);
    return MaterialApp(
      theme: UiDesign.cTheme(),
      debugShowCheckedModeBanner: false,
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            actions: [
              SaveButton(
                data: data,
                backColor: Colors.transparent,
              )
            ],
            leading: BackButton(
              onPressed: () {
                Navigator.pop(context);
                final svp = Get.put(SavedAdsPageController());
                svp.readData();
              },
            ),
            scrolledUnderElevation: 8,
            shadowColor: Colors.black,
            surfaceTintColor: Colors.grey,
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
                              imagesView(context, data.images),
                              const SizedBox(height: 30),
                              Text(
                                data.title,
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
                                    MyStrings.timeFunction(data.time),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: IconContainer(
                                          title: 'جنسیت',
                                          value: data.gender,
                                          icon: data.gender == 'آقا'
                                              ? Iconsax.man
                                              : Iconsax.woman,
                                          iconColor: MyColors.green,
                                        ),
                                      ),
                                      Expanded(
                                        child: IconContainer(
                                          title: 'دستمزد',
                                          value: data.price == 'توافقی'
                                              ? 'توافقی'
                                              : MyStrings.digi(data.price == ''
                                                  ? data.price
                                                  : data.price),
                                          icon: Iconsax.dollar_square,
                                          iconColor: MyColors.red,
                                        ),
                                      ),
                                      Expanded(
                                        child: IconContainer(
                                          title: 'شیوه پرداخت',
                                          value: data.payMethod,
                                          icon: Iconsax.wallet_money,
                                          iconColor: MyColors.orange,
                                        ),
                                      ),
                                      Expanded(
                                        child: IconContainer(
                                          title: 'نوع همکاری',
                                          value: data.workType,
                                          icon: Iconsax.home_wifi5,
                                          iconColor: MyColors.blue,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              const SizedBox(height: 30),
                              Visibility(
                                visible: isHiring,
                                child: MyRow2(
                                  icon: Iconsax.profile_2user,
                                  title: 'عنوان شغلی:',
                                  value: data.profission,
                                ),
                              ),
                              Visibility(
                                visible: isHiring,
                                maintainAnimation: true,
                                maintainState: true,
                                child: const Divider(
                                  height: 35,
                                ),
                              ),
                              MyRow2(
                                icon: Iconsax.category,
                                title: 'دسته بندی:',
                                value: data.category,
                              ),
                              const Divider(height: 35),
                              Visibility(
                                visible: sharayet.isEmpty,
                                child: Row(
                                  children: const [
                                    Icon(
                                      Iconsax.tick_square,
                                      color: Colors.green,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      'شرایط احراز',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 5),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: sharayet.length,
                                itemBuilder: (context, index) {
                                  return sharayet[index].toString().isNotEmpty
                                      ? Column(
                                          children: [
                                            Row(
                                              children: [
                                                const SizedBox(width: 10),
                                                Container(
                                                  width: 10,
                                                  height: 10,
                                                  decoration:
                                                      const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.black54,
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                Text(sharayet[index]),
                                              ],
                                            ),
                                            const SizedBox(height: 5),
                                          ],
                                        )
                                      : Container();
                                },
                              ),
                              const SizedBox(height: 10),
                              Visibility(
                                visible: mazaya.isEmpty,
                                child: Row(
                                  children: const [
                                    Icon(
                                      Iconsax.gift,
                                      color: MyColors.blue,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      'مزایا',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 5),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: mazaya.length,
                                itemBuilder: (context, index) {
                                  return mazaya[index]
                                          .toString()
                                          .trim()
                                          .isNotEmpty
                                      ? Column(
                                          children: [
                                            Row(
                                              children: [
                                                const SizedBox(width: 10),
                                                Container(
                                                  width: 10,
                                                  height: 10,
                                                  decoration:
                                                      const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.black54,
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                Text(mazaya[index]),
                                              ],
                                            ),
                                            const SizedBox(height: 5),
                                          ],
                                        )
                                      : Container();
                                },
                              ),
                              const SizedBox(height: 5),
                              const Text(
                                'توضیحات',
                                style: TextStyle(fontSize: 20),
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(data.descs,
                                          textAlign: TextAlign.justify),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              data.locationBool
                                  ? InkWell(
                                      onTap: () {
                                        MapsLauncher.launchCoordinates(
                                            double.parse(data.lat),
                                            double.parse(data.lon));
                                      },
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              'https://api.neshan.org/v2/static?key=service.3701bff2e5814681af87132d10abe63a&'
                                              'type=dreamy&zoom=15&center=${data.lat},${data.lon}'
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
                              return _ContactWithAdvertizer(data: data);
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
}

class _ContactWithAdvertizer extends StatelessWidget {
  const _ContactWithAdvertizer({
    Key? key,
    required this.data,
  }) : super(key: key);

  final AdvModel data;

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
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
                      borderRadius: BorderRadius.circular(10)),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'راه های ارتباطی',
                    style: MyTextStyles.titrTextStyle(),
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    Visibility(
                      visible: data.telegramBool,
                      child: InkWell(
                        onTap: () {
                          _launchInBrowser(
                              Uri.parse('https://t.me/${data.telegramId}'));
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.0),
                          child: IconContainer(
                            title: 'تلگرام',
                            value: '',
                            icon: FontAwesomeIcons.telegram,
                            iconColor: Colors.lightBlue,
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: data.instagramBool,
                      child: InkWell(
                        onTap: () {
                          _launchInBrowser(Uri.parse(
                              'instagram://user?username=${data.instagramid}'));
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.0),
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
                      visible: data.whatsappBool,
                      child: InkWell(
                        onTap: () {
                          _launchInBrowser(Uri.parse(
                              'https://wa.me/+98${data.whatsappNumber}:'));
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.0),
                          child: IconContainer(
                            title: 'واتس اپ',
                            value: '',
                            icon: FontAwesomeIcons.whatsapp,
                            iconColor: Colors.green,
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: data.chatBool,
                      child: InkWell(
                        onTap: () {},
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.0),
                          child: IconContainer(
                            title: 'چت',
                            value: '',
                            icon: Iconsax.sms_tracking,
                            iconColor: MyColors.orange,
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: data.websiteBool,
                      child: InkWell(
                        onTap: () {
                          _launchInBrowser(
                              Uri.parse('https://${data.websiteAddress}'));
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.0),
                          child: IconContainer(
                            title: 'وبسایت',
                            value: '',
                            icon: Iconsax.global,
                            iconColor: Colors.brown,
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: data.emailBool,
                      child: InkWell(
                        onTap: () {
                          _launchInBrowser(
                            Uri(
                              scheme: 'mailto',
                              path: data.emailAddress,
                              query:
                                  'subject=آگهی استخدام با عنوان: ${data.title} در اپلیکیشن گره',
                            ),
                          );
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.0),
                          child: IconContainer(
                            title: 'ایمیل',
                            value: '',
                            icon: Icons.alternate_email_outlined,
                            iconColor: Colors.deepPurple,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Visibility(
                  visible: data.callBool,
                  child: _MyRow(
                    onTap: () =>
                        _launchInBrowser(Uri.parse('tel:${data.callNumber}')),
                    icon: Iconsax.call,
                    text: data.callNumber.isNotEmpty
                        ? 'تماس تلفنی با: ${data.callNumber.substring(data.callNumber.length - 4)}***${data.callNumber.characters.take(4)}'
                        : '',
                    background: MyColors.green,
                  ),
                ),
                Visibility(
                  visible: data.smsBool,
                  child: _MyRow(
                    onTap: () =>
                        _launchInBrowser(Uri.parse('sms:${data.smsNumber}')),
                    icon: Iconsax.sms,
                    text: data.smsNumber.isEmpty
                        ? ''
                        : 'ارسال پیامک به: ${data.callNumber.substring(data.callNumber.length - 4)}***${data.callNumber.characters.take(4)}',
                    background: MyColors.blue,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MyRow extends StatelessWidget {
  final Function()? onTap;
  final IconData icon;
  final String text;
  final Color background;
  const _MyRow({
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
