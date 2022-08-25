import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:sarkargar/pages/jobsList/filter_screen.dart';
import 'package:sarkargar/controllers/jobs_list_controller.dart';
import 'package:sarkargar/services/uiDesign.dart';
import 'package:sarkargar/pages/jobsList/jobdetails_page.dart';
import 'package:sarkargar/services/database.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'city_selection.dart';

class JobsList extends StatefulWidget {
  const JobsList({Key? key}) : super(key: key);

  @override
  State<JobsList> createState() => _JobsListState();
}

class _JobsListState extends State<JobsList> {
  final controller = Get.put(JobsListController());
  late SharedPreferences sharedPreferences;
  List snap = [];
  UiDesign uiDesign = UiDesign();
  AppDataBase dataBase = AppDataBase();
  TextEditingController searchTC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: uiDesign.cTheme(),
      debugShowCheckedModeBanner: false,
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: appBar(),
            body: buildFutureBuilder()),
      ),
    );
  }

//0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

  AppBar appBar() {
    return AppBar(
      leading: IconButton(
          onPressed: () {
            getFilters();
          },
          icon: const Icon(
            Iconsax.filter,
            color: Colors.black,
          )),
      titleSpacing: 0,
      actions: [
        IconButton(
            onPressed: () {
              Get.to(() => GetLocation(isFirstTime: false));
            },
            // ignore: prefer_const_constructors
            icon: Icon(
              size: 25,
              Iconsax.map_1,
              color: Colors.black,
            )),
      ],
      elevation: 0,
      backgroundColor: Colors.grey[50],
      title: uiDesign.cTextField(
        suffix: InkWell(
          onTap: () {
            searchTC.clear();
          },
          child: const Icon(
            Iconsax.close_circle,
            color: Colors.black,
            size: 25,
          ),
        ),
        textInputAction: TextInputAction.search,
        onSubmit: (value) {},
        icon: const Icon(Iconsax.search_normal_1),
        labeltext: 'جستجو',
        control: searchTC,
        onChange: (value) {
          searchMethod(value);
        },
      ),
    );
  }

//0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

  Obx buildFutureBuilder() {
    return Obx(
      () => FutureBuilder(
        future: dataBase.getAds(
            query:
                "SELECT * FROM `requests` WHERE `city` = '${controller.city.value}'"),
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

            // زمانی که اتصال برقرار شده ولی اطلاعاتی وجود نداشته
            //TODO: این صفحه رو طراحی کن
            if (snap.isEmpty) {
              return const Center(
                child: Text('برای شهر شما آگهی وجود ندارد.'),
              );
            }
            //زمانی که نتونسته اطلاعاتی دریافت کنه
          } else if (controller.jobsList.isEmpty) {
            return uiDesign.errorWidget(
              () {
                setState(() {
                  dataBase.getAds(
                      query:
                          "SELECT * FROM `requests` WHERE `city` = '${controller.city.value}'");
                });
              },
            );
          }

          return Obx(
            () => RefreshIndicator(
              onRefresh: () async {
                snap = await dataBase.getAds(
                    query:
                        "SELECT * FROM `requests` WHERE `city` = '${controller.city.value}'");
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
                  bool phonebool =
                      controller.jobsList[index]['phonebool'] == '0'
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
                      );
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
                                          style:
                                              const TextStyle(fontSize: 20))),
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
                                        borderRadius:
                                            BorderRadius.circular(10)),
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
                                        color:
                                            Color.fromARGB(255, 109, 109, 109),
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
      ),
    );
  }

//0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

  void getFilters() async {
    await Get.to(() => const FilterScreen())?.then((value) {
      if (value != null) {
        controller.jobsList.value = value;
      } else {
        setState(() {
          snap;
        });
      }
    });
  }

  void searchMethod(String val) {
    if (val.isNotEmpty) {
      controller.jobsList.value = controller.jobsList.where((element) {
        var elementAsString = element.toString();
        return elementAsString.contains(val);
      }).toList();
    } else {
      setState(() {
        snap;
      });
    }
  }
}
