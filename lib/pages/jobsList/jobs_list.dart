import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:sarkargar/components/pages/error.page.dart';
import 'package:sarkargar/constants/my_strings.dart';
import 'package:sarkargar/controllers/jobs_list_controller.dart';
import 'package:sarkargar/models/adv_model_test.dart';
import 'package:sarkargar/pages/jobsList/filter_page.dart';
import 'package:sarkargar/pages/jobsList/job_details.dart';
import 'package:sarkargar/services/ui_design.dart';
import '../../components/pages/select.city.dart';
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
  double height = 130;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: UiDesign.cTheme(),
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
      excludeHeaderSemantics: true,
      scrolledUnderElevation: 0,
      actions: [
        InkWell(
          onTap: () =>
              Get.to(() => const SelectCity(isFirstTime: false))?.then((value) {
            controller.city.value = value;
            return box.write('city', value);
          }),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              children: [
                const Icon(
                  Iconsax.location,
                  size: 15,
                  color: Colors.grey,
                ),
                const SizedBox(width: 3),
                Obx(
                  () => Text(controller.city.value,
                      style: UiDesign.descriptionsTextStyle()),
                ),
              ],
            ),
          ),
        )
      ],
      title: OpenContainer(
        onClosed: (data) {
          if (data != null) {
            controller.query.value = data.toString();
          }
        },
        openShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        closedColor: Colors.transparent,
        transitionDuration: const Duration(milliseconds: 500),
        openBuilder: (BuildContext context,
            void Function({Object? returnValue}) action) {
          return FilterPage();
        },
        closedBuilder: (BuildContext context, void Function() action) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: InkWell(
              onTap: () => action.call(),
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.brown.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(children: const [
                    SizedBox(width: 10),
                    Icon(
                      Iconsax.search_normal,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'جستجو',
                      style: TextStyle(color: Colors.grey),
                    )
                  ]),
                ),
              ),
            ),
          );
        },
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
          future: controller.getAds(query: controller.query.value),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            List<AdvModelTest> newData;

            //برای زمانی که در حال دریافت اطلاعات از سرور هست
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Lottie.asset('assets/lottie/loading.json',
                    width: 80, height: 80),
              );
              //زمانی که اطلاعات رو از سرور دریافت کرده
            } else if (snapshot.hasData) {
              List<AdvModelTest> data = snapshot.data;
              newData = data.reversed.toList();

              // زمانی که اتصال برقرار شده ولی اطلاعاتی وجود نداشته
              //TODO: این صفحه رو طراحی کن
              if (data.isEmpty) {
                return const Center(
                  child: Text('برای شهر شما آگهی وجود ندارد.'),
                );
              }
              //زمانی که نتونسته اطلاعاتی دریافت کنه
            } else {
              return MyErrorPage(referesh: () {
                setState(() {});
              });
            }

            return RefreshIndicator(
              backgroundColor: MyColors.notWhite,
              onRefresh: () async {
                controller.city.value = box.read('city');
              },
              child: ListView.separated(
                key: const PageStorageKey('value'),
                itemCount: newData.length,
                itemBuilder: (BuildContext context, int index) {
                  var adtype =
                      newData[index].adType == '0' ? 'استخدام' : 'تبلیغ';
                  Color adTypeBgColor = newData[index].adType == '0'
                      ? MyColors.orange
                      : MyColors.red;

                  return Directionality(
                    textDirection: TextDirection.rtl,
                    child: ListTile(
                      onTap: () {
                        Get.to(
                          () => JobDetails(
                            mod: newData[index],
                          ),
                        );
                      },
                      title: Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: height,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                      child: Text(newData[index].title,
                                          style:
                                              const TextStyle(fontSize: 20))),
                                  Row(children: [
                                    const Icon(Iconsax.category_2, size: 14),
                                    const SizedBox(width: 6),
                                    Text(newData[index].category,
                                        style: const TextStyle(fontSize: 12))
                                  ]),
                                  const SizedBox(height: 2),
                                  Row(
                                    children: [
                                      const Icon(Iconsax.location, size: 15),
                                      const SizedBox(width: 5),
                                      Expanded(
                                        child: Text(
                                          newData[index].address,
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
                              height: height,
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
                                          visible: newData[index].callBool,
                                          child: const Icon(Iconsax.call,
                                              size: 15),
                                        ),
                                        Visibility(
                                          visible: newData[index].chatBool,
                                          child:
                                              const Icon(Iconsax.sms, size: 15),
                                        ),
                                        Visibility(
                                          visible: newData[index].instagramBool,
                                          child: const Icon(Iconsax.instagram,
                                              size: 15),
                                        ),
                                        Visibility(
                                          visible: newData[index].locationBool,
                                          child: const Icon(Iconsax.location,
                                              size: 15),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          //ستون تصویر آگهی
                          if (newData[index].images.isEmpty)
                            Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(5)),
                                  height: height,
                                  width: height,
                                  child: const Icon(
                                    Iconsax.gallery_slash,
                                    size: 55,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                    MyStrings.timeFunction(newData[index].time),
                                    style: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 109, 109, 109),
                                        fontSize: 12)),
                              ],
                            )
                          else
                            ClipRRect(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(5),
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: newData[index].images[0]['image'],
                                    height: height,
                                    width: height,
                                    filterQuality: FilterQuality.low,
                                    maxWidthDiskCache: 302,
                                    maxHeightDiskCache: 302,
                                    fit: BoxFit.cover,
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    child: Container(
                                      height: 30,
                                      width: height,
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
                                          colors: [
                                            Colors.black54,
                                            Colors.transparent
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    child: Text(
                                        MyStrings.timeFunction(
                                            newData[index].time),
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 12)),
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: Container(
                                      height: 20,
                                      width: 35,
                                      decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(6)),
                                          color: Colors.black45),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Iconsax.gallery5,
                                            size: 15,
                                            color: Colors.white,
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            newData[index]
                                                .images
                                                .length
                                                .toString(),
                                            style: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
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
            );
          },
        ),
      ),
    );
  }
}
