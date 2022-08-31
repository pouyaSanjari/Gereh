import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:sarkargar/services/uiDesign.dart';
import 'package:sarkargar/pages/jobsList/jobdetails_page.dart';
import 'package:sarkargar/services/database.dart';

import '../../controllers/jobs_list_controller.dart';

class MyRequests extends StatefulWidget {
  const MyRequests({Key? key}) : super(key: key);

  @override
  State<MyRequests> createState() => _MyRequestsState();
}

class _MyRequestsState extends State<MyRequests> {
  final controller = Get.put(JobsListController());
  final box = GetStorage();

  //لیست های استفاده شده در لیست شغل ها
  List snat = [];
  List snap = [];
  UiDesign uiDesign = UiDesign();
  AppDataBase dataBase = AppDataBase();
  TextEditingController searchTC = TextEditingController();

  //نشون میده که فیلتری انجام دادیم یا نه
  bool isFiltered = false;
  String databaseQuery = '';
  String selectedCategory = '';
  String selectedCity = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: uiDesign.cTheme(),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.grey[50],
          title: Text('لیست آگهی های جاری شما'),
        ),
        body: buildFutureBuilder(),
      ),
    );
  }

  FutureBuilder buildFutureBuilder() {
    return FutureBuilder(
      future: dataBase.getAds(
          query:
              "SELECT * FROM `requests` WHERE `advertizerid` = '${box.read('id')}'"),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        //برای زمانی که در حال دریافت اطلاعات از سرور هست
        if (snapshot.connectionState == ConnectionState.waiting &&
            controller.jobsList.isEmpty) {
          return Center(
            child: Lottie.asset('assets/lottie/loading.json',
                width: 80, height: 80),
          );
          //زمانی که اطلاعات رو از سرور دریافت کرده
        } else if (snapshot.hasData) {
          snap = snapshot.data[0];
          controller.jobsList.value = snap.reversed.toList();
          controller.jobsImages.value = snapshot.data[1];

          // ignore: todo
          //TODO: این صفحه رو طراحی کن
          // زمانی که اتصال برقرار شده ولی اطلاعاتی وجود نداشته
          if (snap.isEmpty) {
            return const Center(
              child: Text('هنوز هیچ آگهی ثبت نکردید.'),
            );
          }
          //زمانی که نتونسته اطلاعاتی دریافت کنه
        } else if (controller.jobsList.isEmpty) {
          return uiDesign.errorWidget(
            () => setState(() {
              dataBase.getAds(
                  query:
                      "SELECT * FROM `requests` WHERE `advertizerid` = '${box.read('id')}'");
            }),
          );
        }

        return Obx(
          () => RefreshIndicator(
            onRefresh: () async {
              snap = await dataBase.getAds(
                  query:
                      "SELECT * FROM `requests` WHERE `advertizerid` = '${box.read('id')}'");
              if (snap.isNotEmpty) {
                controller.jobsList.value = snap[0].reversed.toList();
                controller.jobsImages.value = snap[1].reversed.toList();
              }
            },
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemCount: controller.jobsList.length,
              itemBuilder: (BuildContext context, int index) {
                var category = controller.jobsList[index]['category'];
                var adtype = controller.jobsList[index]['adtype'] == '0'
                    ? 'استخدام'
                    : 'تبلیغ';
                Color adTypeBgColor =
                    controller.jobsList[index]['adtype'] == '0'
                        ? const Color(0xff888d79)
                        : const Color.fromARGB(255, 92, 139, 184);

                bool instagrambool =
                    controller.jobsList[index]['instagrambool'] == '0'
                        ? false
                        : true;
                bool phonebool = controller.jobsList[index]['phonebool'] == '0'
                    ? false
                    : true;
                bool chatbool = controller.jobsList[index]['chatbool'] == '0'
                    ? false
                    : true;
                bool locationbool =
                    controller.jobsList[index]['locationbool'] == '0'
                        ? false
                        : true;

                var itemImage = controller.jobsImages
                    .where((element) =>
                        element['adId'] == controller.jobsList[index]['id'])
                    .toList();

                var address = controller.jobsList[index]['address'] == ''
                    ? controller.jobsList[index]['city']
                    : controller.jobsList[index]['address'];
                var title = controller.jobsList[index]['title'];
                return ListTile(
                  onTap: () {
                    Get.to(
                        () => JobDetails(
                            adDetails: controller.jobsList[index],
                            images: itemImage),
                        transition: Transition.cupertino,
                        duration: const Duration(milliseconds: 200),
                        popGesture: true);
                  },
                  title: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 110,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                    child: Text(title,
                                        style: const TextStyle(fontSize: 20))),
                                Row(children: [
                                  const Icon(Iconsax.category_2, size: 14),
                                  const SizedBox(width: 6),
                                  Text(category,
                                      style: const TextStyle(fontSize: 12))
                                ]),
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    const Icon(Iconsax.location, size: 15),
                                    const SizedBox(width: 5),
                                    Expanded(
                                      child: Text(
                                        address,
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        //ستون آیکون ها و نوع آگهی
                        Padding(
                          padding: const EdgeInsets.only(left: 2.0),
                          child: SizedBox(
                            height: 110,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  height: 47,
                                  decoration: BoxDecoration(
                                      color: adTypeBgColor,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Center(
                                    child: RotatedBox(
                                        quarterTurns: 1,
                                        child: Text(
                                          adtype,
                                          textScaleFactor: 0.6,
                                          style: const TextStyle(
                                              color: Colors.white),
                                        )),
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Visibility(
                                          visible: phonebool,
                                          child: const Icon(Iconsax.call,
                                              size: 15)),
                                      Visibility(
                                          visible: chatbool,
                                          child: const Icon(Iconsax.sms,
                                              size: 15)),
                                      Visibility(
                                          visible: instagrambool,
                                          child: const Icon(Iconsax.instagram,
                                              size: 15)),
                                      Visibility(
                                          visible: locationbool,
                                          child: const Icon(Iconsax.location,
                                              size: 15)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        //ستون تصویر آگهی
                        if (itemImage.isEmpty)
                          Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(5)),
                                height: 110,
                                width: 110,
                                child: const Icon(
                                  Iconsax.gallery_slash,
                                  size: 55,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                  uiDesign.timeFunction(
                                      controller.jobsList[index]['time']),
                                  style: const TextStyle(
                                      color: Color.fromARGB(255, 109, 109, 109),
                                      fontSize: 12)),
                            ],
                          )
                        else
                          ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                CachedNetworkImage(
                                  imageUrl: itemImage[0]['image'],
                                  height: 110,
                                  width: 110,
                                  fit: BoxFit.cover,
                                ),
                                Container(
                                  height: 30,
                                  width: 110,
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      colors: [
                                        Colors.black,
                                        Colors.transparent
                                      ],
                                    ),
                                  ),
                                ),
                                Text(
                                    uiDesign.timeFunction(
                                        controller.jobsList[index]['time']),
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 12)),
                              ],
                            ),
                          )
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Divider(
                    endIndent: 15, indent: 15, height: 5, thickness: 1);
              },
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }
}
