import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:sarkargar/components/buttons/rounded.button.dart';
import 'package:sarkargar/components/other/icon.container.dart';
import 'package:sarkargar/components/other/marker.details.container.dart';
import 'package:sarkargar/constants/colors.dart';
import 'package:sarkargar/constants/my_strings.dart';
import 'package:sarkargar/constants/my_text_styles.dart';
import 'package:sarkargar/controllers/jobs_list_controller.dart';
import 'package:sarkargar/models/adv_model.dart';
import 'package:sarkargar/pages/jobsList/filter_page.dart';
import 'package:sarkargar/pages/jobsList/job_details.dart';
import 'package:syncfusion_flutter_maps/maps.dart';
import '../../controllers/map.test.controller.dart';

class TestMap extends StatefulWidget {
  const TestMap({Key? key}) : super(key: key);

  @override
  State<TestMap> createState() => _TestMapState();
}

class _TestMapState extends State<TestMap> {
  final controller = Get.put(permanent: true, MapTestController());
  final jobsListController = Get.find<JobsListController>();

  late List<AdvModel> _data;
  late MapZoomPanBehavior _mapZoomPanBehavior;
  late MapTileLayerController markerController;

  @override
  void initState() {
    markerController = MapTileLayerController();
    _mapZoomPanBehavior = MapZoomPanBehavior(
      zoomLevel: 5,
      maxZoomLevel: 20,
      minZoomLevel: 5,
      enableDoubleTapZooming: true,
      enableMouseWheelZooming: true,
    );
    addMarkers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(left: 30.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FloatingActionButton(
                heroTag: 'location',
                tooltip: 'دریافت موقعیت شما',
                backgroundColor: MyColors.black,
                child: const Icon(
                  Icons.location_searching_rounded,
                  size: 30,
                  color: MyColors.notWhite,
                ),
                onPressed: () async {
                  toUserPostion();
                },
              ),
              FloatingActionButton(
                heroTag: 'filter',
                tooltip: 'فیلتر',
                backgroundColor: MyColors.black,
                child: const Icon(
                  Iconsax.filter,
                  size: 30,
                  color: MyColors.notWhite,
                ),
                onPressed: () async {
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FilterPage(),
                      )).then(
                    (value) {
                      if (value != null) {
                        jobsListController.query.value = value.toString();

                        return addMarkers();
                      }
                    },
                  );
                },
              ),
              FloatingActionButton(
                heroTag: 'see',
                tooltip: 'نمایش جزئیات',
                backgroundColor: MyColors.black,
                child: Obx(
                  () => Icon(
                    controller.adDetailsVisibility.value
                        ? Iconsax.eye_slash
                        : Iconsax.eye,
                    size: 30,
                    color: MyColors.notWhite,
                  ),
                ),
                onPressed: () {
                  controller.showHideAdsDetails();
                },
              )
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        body: Column(
          children: [
            Expanded(
              child: SfMaps(
                layers: [
                  MapTileLayer(
                    tooltipSettings: const MapTooltipSettings(),
                    urlTemplate: MyStrings.mapAddres + MyStrings.apiKey,
                    zoomPanBehavior: _mapZoomPanBehavior,
                    initialFocalLatLng: const MapLatLng(31.0, 54.0),
                    controller: markerController,
                    markerBuilder: (BuildContext context, int index) {
                      bool isHiring = _data[index].adType == '1' ? false : true;

                      return MapMarker(
                        latitude: double.parse(_data[index].lat),
                        longitude: double.parse(_data[index].lon),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Obx(
                              () => Visibility(
                                visible: controller.adDetailsVisibility.value,
                                child: AnimatedOpacity(
                                  opacity: controller.opacity.value,
                                  duration: const Duration(milliseconds: 200),
                                  child: MarkerDetailsContainer(
                                    data: _data,
                                    index: index,
                                    onTap: () {
                                      controller.currentImage.value = 1;
                                      showModalBottomSheet(
                                        backgroundColor: Colors.transparent,
                                        context: context,
                                        useRootNavigator: true,
                                        isScrollControlled: true,
                                        elevation: 0,
                                        barrierColor: Colors.transparent,
                                        builder: (context) {
                                          return bottomSheet(_data, index);
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                            AnimationConfiguration.synchronized(
                              child: FadeInAnimation(
                                curve: Curves.fastLinearToSlowEaseIn,
                                duration: const Duration(milliseconds: 2000),
                                child: Obx(
                                  // padding for when the above container is showing to avoid changing marker location and also
                                  // to fix bottom of pointer icon on it`s right position
                                  () => Padding(
                                    padding: EdgeInsets.only(
                                      bottom:
                                          controller.adDetailsVisibility.value
                                              ? 100.0
                                              : 35,
                                    ),
                                    child: isHiring
                                        ? SvgPicture.asset(
                                            'assets/SVG/hire.svg',
                                            width: 25,
                                          )
                                        : SvgPicture.asset(
                                            'assets/SVG/adv.svg',
                                            width: 25,
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomSheet(List<AdvModel> data, int ind) {
    controller.currentIndex.value = ind;
    return CarouselSlider.builder(
      options: CarouselOptions(
        viewportFraction: 0.85,
        initialPage: ind,
        enableInfiniteScroll: true,
        enlargeCenterPage: true,
        height: 320,
        pageViewKey: const PageStorageKey('value'),
        onPageChanged: (index, reason) {
          controller.currentIndex.value = ind;
        },
      ),
      itemCount: data.length,
      itemBuilder: (context, index, realIndex) {
        bool isHiring = data[index].adType == '1' ? false : true;

        return Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyRoundedButton(
                  icon: const Icon(
                    Icons.location_searching_rounded,
                    color: MyColors.black,
                  ),
                  backColor: Colors.white,
                  text: '',
                  onClick: () {
                    Future.delayed(
                      const Duration(milliseconds: 500),
                      () {
                        _mapZoomPanBehavior.latLngBounds = MapLatLngBounds(
                          MapLatLng(double.parse(data[index].lat) - 0.001,
                              double.parse(data[index].lon) - 0.001),
                          MapLatLng(double.parse(data[index].lat) + 0.001,
                              double.parse(data[index].lon) + 0.001),
                        );
                      },
                    );
                  },
                ),
                MyRoundedButton(
                  icon: const Icon(
                    Iconsax.bookmark,
                    color: MyColors.black,
                  ),
                  backColor: Colors.white,
                  text: '',
                  onClick: () {},
                )
              ],
            ),
            const SizedBox(height: 5),
            Expanded(
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => JobDetails(mod: data[index]),
                    ));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: MyColors.backgroundColor.withOpacity(0.99),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 30,
                            color: Colors.black.withOpacity(0.1),
                          ),
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 30,
                          )
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 8,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                data[index].images.isEmpty
                                    ? Container(
                                        decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.grey),
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        height: 80,
                                        width: 80,
                                        child: const Icon(
                                          Iconsax.gallery_slash,
                                          size: 55,
                                          color: Colors.grey,
                                        ),
                                      )
                                    : SizedBox(
                                        width: 80,
                                        height: 80,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: CachedNetworkImage(
                                              maxWidthDiskCache: 220,
                                              maxHeightDiskCache: 220,
                                              fit: BoxFit.cover,
                                              imageUrl: data[index].images[0]
                                                  ['image']),
                                        ),
                                      ),
                                const SizedBox(width: 5),
                                SizedBox(
                                  height: 80,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          data[index].title,
                                          style: MyTextStyles.titleTextStyle(
                                              Colors.black),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          const Icon(
                                            Iconsax.clock,
                                            color: Colors.grey,
                                            size: 15,
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            MyStrings.timeFunction(
                                                data[index].time),
                                            style: MyTextStyles
                                                .descriptionsTextStyle(
                                                    Colors.black),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 5),
                                      Row(
                                        children: [
                                          const Icon(
                                            Iconsax.category,
                                            color: Colors.grey,
                                            size: 15,
                                          ),
                                          const SizedBox(width: 5),
                                          Text(data[index].category)
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            isHiring
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        IconContainer(
                                          width: 40,
                                          height: 40,
                                          radius: 15,
                                          titleFontSize: 11,
                                          contentFontSize: 12,
                                          title: 'جنسیت',
                                          value: data[index].gender,
                                          icon: data[index].gender == 'آقا'
                                              ? Iconsax.man
                                              : Iconsax.woman,
                                          iconColor: MyColors.green,
                                        ),
                                        IconContainer(
                                          width: 40,
                                          height: 40,
                                          radius: 15,
                                          titleFontSize: 11,
                                          contentFontSize: 12,
                                          title: 'دستمزد',
                                          value: data[index].price == 'توافقی'
                                              ? 'توافقی'
                                              : MyStrings.digi(
                                                  data[index].price == ''
                                                      ? data[index].price
                                                      : data[index].price),
                                          icon: Iconsax.dollar_square,
                                          iconColor: MyColors.red,
                                        ),
                                        IconContainer(
                                          width: 40,
                                          height: 40,
                                          radius: 15,
                                          titleFontSize: 11,
                                          contentFontSize: 12,
                                          title: 'شیوه پرداخت',
                                          value: data[index].payMethod,
                                          icon: Iconsax.wallet_money,
                                          iconColor: MyColors.orange,
                                        ),
                                        IconContainer(
                                          width: 40,
                                          height: 40,
                                          radius: 15,
                                          titleFontSize: 11,
                                          contentFontSize: 12,
                                          title: 'نوع همکاری',
                                          value: data[index].workType,
                                          icon: Iconsax.home_wifi5,
                                          iconColor: MyColors.blue,
                                        )
                                      ],
                                    ),
                                  )
                                : SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 5),
                                        const Text(
                                          'توضیحات',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(data[index].descs)
                                      ],
                                    ),
                                  )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 65),
          ],
        );
      },
    );
  }

  Future<void> addMarkers() async {
    Future.delayed(
      Duration.zero,
      () => showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: Center(
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(214, 242, 245, 252),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Lottie.asset('assets/lottie/loading.json',
                    width: 80, height: 80),
              ),
            ),
          );
        },
      ),
    );

    _data = [];

    // دریافت اطلاعات از دیتابیس
    try {
      await jobsListController.getAds();
      // حذف لودینگ
      Get.back();
      // حذف مارکر ها در صورت وجود داشتن
      if (markerController.markersCount > 0) {
        markerController.clearMarkers();
      }

      int markerIndex = 0;
      // اضافه کردن مارکر های مورد نیاز
      for (var i = 0; i < jobsListController.jobsList.length; i++) {
        if (jobsListController.jobsList[i].locationBool) {
          _data.add(jobsListController.jobsList[i]);
          markerController.insertMarker(markerIndex);
          markerIndex++;
        }
      }
    } catch (e) {
      Get.back();
      Fluttertoast.showToast(msg: 'اتصال اینترنت خود را بررسی کنید!');
    }
  }

  void toUserPostion() async {
    Position position = await controller.determinePosition();
    _mapZoomPanBehavior.latLngBounds = MapLatLngBounds(
      MapLatLng(position.latitude - 0.1, position.longitude - 0.1),
      MapLatLng(position.latitude + 0.1, position.longitude + 0.1),
    );
  }
}
