import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:sarkargar/components/error.page.dart';
import 'package:sarkargar/components/filter.dialog.dart';
import 'package:sarkargar/components/textFields/text.field.dart';
import 'package:sarkargar/controllers/jobs_list_controller.dart';
import 'package:sarkargar/pages/test/job.details.page.test.dart';
import 'package:sarkargar/services/uiDesign.dart';
import 'package:sarkargar/pages/jobsList/jobdetails_page.dart';
import 'package:sarkargar/services/database.dart';

import '../../components/select.city.dart';
import '../../constants/colors.dart';

final bucket = PageStorageBucket();

class JobsList extends StatefulWidget {
  const JobsList({Key? key}) : super(key: key);

  @override
  State<JobsList> createState() => _JobsListState();
}

class _JobsListState extends State<JobsList> {
  final controller = Get.put(JobsListController());
  final box = GetStorage();
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
          appBar: appBar(),
          resizeToAvoidBottomInset: false,
          body: PageStorage(
            bucket: bucket,
            child: buildFutureBuilder(),
          ),
        ),
      ),
    );
  }

//0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

  AppBar appBar() {
    return AppBar(
      scrolledUnderElevation: 0,

      // snap: true,
      actions: const [SizedBox(width: 15)],
      leadingWidth: 40,
      leading: IconButton(
          onPressed: () {
            Get.dialog(const FilterDialog());
          },
          icon: Obx(
            () => Icon(
              controller.searchedList.isNotEmpty
                  ? Iconsax.filter_edit
                  : Iconsax.filter_add,
              color: controller.searchedList.isNotEmpty
                  ? MyColors.red
                  : MyColors.black,
            ),
          )),
      titleSpacing: 0,
      title: MyTextField(
        onChange: (value) {
          if (value.isNotEmpty) {
            controller.searchMap.addAll({'title': value.toString()});
            controller.searchMethod();
          } else {
            controller.searchMap
                .removeWhere((key, value) => key == 'title' || key == '');
            print(controller.searchMap);
            controller.searchMap.isEmpty
                ? controller.searchedList.clear()
                : controller.searchMethod();
            controller.city.value = '';
            controller.city.value = box.read('city');
          }
        },
        textInputAction: TextInputAction.search,
        icon: const Icon(Iconsax.search_normal),
        labeltext: 'جستجو',
        control: searchTC,
        suffix: Padding(
          padding: const EdgeInsets.only(left: 0.0),
          child: InkWell(
            radius: 30,
            splashColor: MyColors.red,
            onTap: () {
              Get.to(() => const SelectCity(
                    isFirstTime: false,
                  ))?.then((value) {
                if (value != null) {
                  box.write('city', value);
                  controller.city.value = value;
                }
              });
            },
            child: SizedBox(
                width: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(width: 3),
                    const Icon(
                      Iconsax.location,
                      size: 15,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 3),
                    Obx(
                      () => Text(controller.city.value,
                          style: uiDesign.descriptionsTextStyle()),
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }

//0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

  Obx buildFutureBuilder() {
    return Obx(
      () => MediaQuery.removePadding(
        removeTop: true,
        context: context,
        child: FutureBuilder(
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
              return MyErrorPage(referesh: () {
                setState(() {});
              });
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
                  key: const PageStorageKey('value'),
                  itemCount: controller.searchedList.isEmpty
                      ? controller.jobsList.length
                      : controller.searchedList.length,
                  itemBuilder: (BuildContext context, int index) {
                    var item = [];
                    item.clear();
                    controller.searchedList.isEmpty
                        ? item = controller.jobsList
                        : item = controller.searchedList;
                    var category = item[index]['category'];
                    var adtype =
                        item[index]['adtype'] == '0' ? 'استخدام' : 'تبلیغ';
                    Color adTypeBgColor = item[index]['adtype'] == '0'
                        ? MyColors.orange
                        : MyColors.red;

                    bool instagrambool =
                        item[index]['instagrambool'] == '0' ? false : true;
                    bool phonebool =
                        item[index]['phonebool'] == '0' ? false : true;
                    bool chatbool =
                        item[index]['chatbool'] == '0' ? false : true;
                    bool locationbool =
                        item[index]['locationbool'] == '0' ? false : true;
                    List itemImage = controller.jobsImages
                        .where(
                            (element) => element['adId'] == item[index]['id'])
                        .toList();
                    var address = item[index]['address'] == ''
                        ? item[index]['city']
                        : item[index]['address'];
                    var title = item[index]['title'];

                    return Directionality(
                      textDirection: TextDirection.rtl,
                      child: Obx(
                        () => ListTile(
                          onTap: () {
                            if (controller.searchedList.isEmpty) {
                              Get.to(() => JobDetailsPageTest(
                                  adDetails: controller.jobsList[index],
                                  images: itemImage));
                            } else {
                              Get.to(() => JobDetails(
                                  adDetails: controller.searchedList[index],
                                  images: itemImage));
                            }
                          },
                          title: Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 110,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                          child: Text(title,
                                              style: const TextStyle(
                                                  fontSize: 20))),
                                      Row(children: [
                                        const Icon(Iconsax.category_2,
                                            size: 14),
                                        const SizedBox(width: 6),
                                        Text(category,
                                            style:
                                                const TextStyle(fontSize: 12))
                                      ]),
                                      const SizedBox(height: 2),
                                      Row(
                                        children: [
                                          const Icon(Iconsax.location,
                                              size: 15),
                                          const SizedBox(width: 5),
                                          Expanded(
                                            child: Text(
                                              address,
                                              style:
                                                  const TextStyle(fontSize: 12),
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
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
                                                child: const Icon(
                                                    Iconsax.instagram,
                                                    size: 15)),
                                            Visibility(
                                                visible: locationbool,
                                                child: const Icon(
                                                    Iconsax.location,
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
                                          border:
                                              Border.all(color: Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(5)),
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
                                            color: Color.fromARGB(
                                                255, 109, 109, 109),
                                            fontSize: 12)),
                                  ],
                                )
                              else
                                ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5)),
                                  child: Stack(
                                    alignment: Alignment.bottomCenter,
                                    children: [
                                      CachedNetworkImage(
                                        imageUrl: itemImage[0]['image'],
                                        height: 110,
                                        width: 110,
                                        filterQuality: FilterQuality.low,
                                        maxWidthDiskCache: 302,
                                        maxHeightDiskCache: 302,
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
                                          uiDesign.timeFunction(controller
                                              .jobsList[index]['time']),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12)),
                                    ],
                                  ),
                                )
                            ],
                          ),
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
      ),
    );
  }
}
