import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:gereh/components/other/loading.dart';
import 'package:gereh/pages/map/view/marker.details.container.dart';
import 'package:gereh/constants/my_colors.dart';
import 'package:gereh/constants/my_strings.dart';
import 'package:gereh/pages/jobsList/controller/jobs_list_controller.dart';
import 'package:gereh/components/filterPage/view/filter_page.dart';
import 'package:gereh/pages/map/view/jobs_list_slider.dart';
import 'package:syncfusion_flutter_maps/maps.dart';
import '../controller/map_page_controller.dart';

final bucket = PageStorageBucket();

class JobsListOnMap extends StatefulWidget {
  const JobsListOnMap({Key? key}) : super(key: key);

  @override
  State<JobsListOnMap> createState() => _JobsListOnMapState();
}

class _JobsListOnMapState extends State<JobsListOnMap> {
  final controller = Get.put(permanent: true, MapPageController());
  final jobsListController = Get.find<JobsListController>();

  @override
  void initState() {
    controller.addMarkers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(left: 30.0),
          child: Column(
            children: floatingKeys(),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: PageStorage(
                bucket: bucket,
                child: SfMaps(
                  layers: [
                    MapTileLayer(
                      tooltipSettings: const MapTooltipSettings(),
                      urlTemplate: MyStrings.mapAddress + MyStrings.apiKey,
                      zoomPanBehavior: controller.mapZoomPanBehavior,
                      initialFocalLatLng: const MapLatLng(31.0, 54.0),
                      controller: controller.markerController,
                      markerBuilder: (BuildContext context, int index) {
                        bool isHiring =
                            controller.data[index].adType == '1' ? false : true;
                        bool isMyLocation =
                            controller.data[index].id == '0' ? true : false;

                        return MapMarker(
                          latitude: double.parse(controller.data[index].lat),
                          longitude: double.parse(controller.data[index].lon),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              isMyLocation
                                  // نمایش کانتینر خالی بالای مارکر لوکیشن کاربر بجای مشخصات یک شغل
                                  ? Container()
                                  : Obx(
                                      () => Visibility(
                                        visible: controller
                                            .adDetailsVisibility.value,
                                        child: AnimatedOpacity(
                                          opacity: controller.opacity.value,
                                          duration:
                                              const Duration(milliseconds: 200),
                                          child: MarkerDetailsContainer(
                                            data: controller.data,
                                            index: index,
                                            onTap: () {
                                              controller.currentImage.value = 1;
                                              showModalBottomSheet(
                                                backgroundColor:
                                                    Colors.transparent,
                                                context: context,
                                                useRootNavigator: true,
                                                isScrollControlled: true,
                                                elevation: 0,
                                                barrierColor:
                                                    Colors.transparent,
                                                builder: (context) {
                                                  controller.currentIndex
                                                      .value = index;
                                                  // حذف مارکر لوکیشن کاربر قبل از نمایش لیست
                                                  controller.data.removeWhere(
                                                      (element) =>
                                                          element.id == '0');
                                                  return JobsListSlider(
                                                    controller: controller,
                                                    mapZoomPanBehavior:
                                                        controller
                                                            .mapZoomPanBehavior,
                                                    data: controller.data,
                                                    ind: index,
                                                  );
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
                                                ? isMyLocation
                                                    ? 0
                                                    : 100.0
                                                : isMyLocation
                                                    ? 0
                                                    : 35,
                                      ),
                                      child: isMyLocation
                                          ? Lottie.asset(
                                              'assets/lottie/location indicator.json',
                                              width: 50,
                                              height: 50,
                                            )
                                          : isHiring
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
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> floatingKeys() {
    return [
      const SizedBox(height: 50),
      FloatingActionButton(
        heroTag: 'location',
        tooltip: 'دریافت موقعیت شما',
        backgroundColor: MyColors.black.withOpacity(0.8),
        child: const Icon(
          Icons.location_searching_rounded,
          size: 30,
          color: MyColors.notWhite,
        ),
        onPressed: () async {
          controller.toUserPostion();
        },
      ),
      const SizedBox(height: 10),
      FloatingActionButton(
        heroTag: 'filter',
        tooltip: 'فیلتر',
        backgroundColor: MyColors.black.withOpacity(0.8),
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
            (value) async {
              if (value != null) {
                jobsListController.query.value = value.toString();
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return const Loading();
                  },
                );
                await jobsListController.getAds();
                Get.back();
                controller.addMarkers();
              }
            },
          );
        },
      ),
      const SizedBox(height: 10),
      FloatingActionButton(
        heroTag: 'see',
        tooltip: 'نمایش جزئیات',
        backgroundColor: MyColors.black.withOpacity(0.8),
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
    ];
  }
}
