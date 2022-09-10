import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:sarkargar/controllers/jobs_list_controller.dart';
import 'package:sarkargar/services/select_city.dart';
import 'package:sarkargar/services/uiDesign.dart';
import 'package:sarkargar/pages/jobsList/jobdetails_page.dart';
import 'package:sarkargar/services/database.dart';

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
          resizeToAvoidBottomInset: false,
          appBar: appBar(),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() => Row(children: controller.chips.values.toList())),
              Expanded(child: buildFutureBuilder()),
            ],
          ),
        ),
      ),
    );
  }

//0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

  AppBar appBar() {
    return AppBar(
      actions: const [SizedBox(width: 15)],
      leading: IconButton(
          onPressed: () {
            controller.getFilters();
          },
          icon: const Icon(
            Iconsax.filter,
            color: Colors.black,
          )),
      elevation: 0,
      titleSpacing: 0,
      title: uiDesign.cTextField(
        onSubmit: (value) {
          controller.searches.add(value);
          controller.searchMethod();
          searchTC.clear();
          controller.addSearchFilterChip(
            chipText: value.toString(),
            onDeleted: () {
              searchTC.clear();
              controller.searches.removeWhere((element) => element == value);
              controller.searchMethod();
              controller.chips.remove('search');
            },
          );
        },
        textInputAction: TextInputAction.search,
        icon: const Icon(Iconsax.search_normal_1),
        labeltext: 'جستجو',
        control: searchTC,
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
                controller.chips.removeWhere((key, value) => key == 'search');
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
                itemCount: controller.searchedList.isEmpty
                    ? controller.jobsList.length
                    : controller.searchedList.length,
                itemBuilder: (BuildContext context, int index) {
                  var category = '';
                  var adtype = '';
                  Color adTypeBgColor = const Color(0xff888d79);
                  bool instagrambool = false;
                  bool phonebool = false;
                  bool chatbool = false;
                  bool locationbool = false;
                  List itemImage = [];
                  var address = '';
                  var title = '';
                  if (controller.searchedList.isEmpty) {
                    category = controller.jobsList[index]['category'];
                    adtype = controller.jobsList[index]['adtype'] == '0'
                        ? 'استخدام'
                        : 'تبلیغ';
                    adTypeBgColor = controller.jobsList[index]['adtype'] == '0'
                        ? uiDesign.forthColor()
                        : uiDesign.fifthColor();

                    instagrambool =
                        controller.jobsList[index]['instagrambool'] == '0'
                            ? false
                            : true;
                    phonebool = controller.jobsList[index]['phonebool'] == '0'
                        ? false
                        : true;
                    chatbool = controller.jobsList[index]['chatbool'] == '0'
                        ? false
                        : true;
                    locationbool =
                        controller.jobsList[index]['locationbool'] == '0'
                            ? false
                            : true;

                    itemImage = controller.jobsImages
                        .where((element) =>
                            element['adId'] == controller.jobsList[index]['id'])
                        .toList();

                    address = controller.jobsList[index]['address'] == ''
                        ? controller.jobsList[index]['city']
                        : controller.jobsList[index]['address'];
                    title = controller.jobsList[index]['title'];
                  } else {
                    category = controller.searchedList[index]['category'];
                    adtype = controller.searchedList[index]['adtype'] == '0'
                        ? 'استخدام'
                        : 'تبلیغ';
                    adTypeBgColor =
                        controller.searchedList[index]['adtype'] == '0'
                            ? uiDesign.forthColor()
                            : uiDesign.fifthColor();

                    instagrambool =
                        controller.searchedList[index]['instagrambool'] == '0'
                            ? false
                            : true;
                    phonebool =
                        controller.searchedList[index]['phonebool'] == '0'
                            ? false
                            : true;
                    chatbool = controller.searchedList[index]['chatbool'] == '0'
                        ? false
                        : true;
                    locationbool =
                        controller.searchedList[index]['locationbool'] == '0'
                            ? false
                            : true;

                    itemImage = controller.jobsImages
                        .where((element) =>
                            element['adId'] ==
                            controller.searchedList[index]['id'])
                        .toList();

                    address = controller.searchedList[index]['address'] == ''
                        ? controller.searchedList[index]['city']
                        : controller.searchedList[index]['address'];
                    title = controller.searchedList[index]['title'];
                  }
                  return ListTile(
                    onTap: () {
                      Get.to(
                        () {
                          // در صورتی که سرچ کرده باشی یا نه
                          if (controller.searchedList.isEmpty) {
                            return JobDetails(
                                adDetails: controller.jobsList[index],
                                images: itemImage);
                          } else {
                            return JobDetails(
                                adDetails: controller.searchedList[index],
                                images: itemImage);
                          }
                        },
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
}
