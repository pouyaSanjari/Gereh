import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:sarkargar/components/buttons/button.dart';
import 'package:sarkargar/components/other/icon.container.dart';
import 'package:sarkargar/components/other/marker.details.container.dart';
import 'package:sarkargar/components/pages/image.viewer.dart';
import 'package:sarkargar/constants/colors.dart';
import 'package:sarkargar/constants/my_strings.dart';
import 'package:sarkargar/constants/my_text_styles.dart';
import 'package:sarkargar/controllers/jobs_list_controller.dart';
import 'package:sarkargar/models/adv_model_test.dart';
import 'package:sarkargar/pages/jobsList/filter_page.dart';
import 'package:sarkargar/pages/jobsList/job_details.dart';
import 'package:syncfusion_flutter_maps/maps.dart';
import 'map.test.controller.dart';

class TestMap extends StatefulWidget {
  const TestMap({Key? key}) : super(key: key);

  @override
  State<TestMap> createState() => _TestMapState();
}

class _TestMapState extends State<TestMap> {
  final controller = Get.put(MapTestController());
  final jobsListController = Get.put(JobsListController());

  late List<AdvModelTest> _data;
  late MapZoomPanBehavior _mapZoomPanBehavior;
  late MapTileLayerController markerController;

  @override
  void initState() {
    markerController = MapTileLayerController();
    _mapZoomPanBehavior =
        MapZoomPanBehavior(zoomLevel: 5, maxZoomLevel: 20, minZoomLevel: 5);

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
                tooltip: 'نمایش جزئیات',
                backgroundColor: MyColors.black,
                child: const Icon(
                  Iconsax.filter,
                  size: 30,
                  color: MyColors.notWhite,
                ),
                onPressed: () {
                  Get.to(() => FilterPage())?.then((value) {
                    if (value != null) {
                      controller.query.value = value.toString();

                      return addMarkers();
                    }
                  });
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
                                      controller.current.value = 1;
                                      showModalBottomSheet(
                                        // backgroundColor: Colors.transparent,
                                        context: context,
                                        useRootNavigator: true,
                                        isScrollControlled: true,
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(15))),
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
                                  // padding for when the above container is showing to avoid changing marker location
                                  () => Padding(
                                    padding: EdgeInsets.only(
                                      bottom:
                                          controller.adDetailsVisibility.value
                                              ? 65.0
                                              : 0,
                                    ),
                                    child: isHiring
                                        ? Image.asset(
                                            width: 40,
                                            height: 40,
                                            'images/hire_map_marker.png')
                                        : Image.asset(
                                            width: 40,
                                            height: 40,
                                            'images/adv_map_marker.png'),
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

  Widget bottomSheet(List<AdvModelTest> data, int index) {
    bool isHiring = data[index].adType == '1' ? false : true;
    List images = data[index].images;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 5),
            Container(
              height: 6,
              width: 40,
              decoration: BoxDecoration(
                  color: Colors.grey, borderRadius: BorderRadius.circular(10)),
            ),
            const SizedBox(height: 5),
            data[index].images.isEmpty
                ? const SizedBox(height: 20)
                : SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 200,
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: PhotoViewGallery.builder(
                            wantKeepAlive: true,
                            itemCount: images.length,
                            customSize: Size(
                                MediaQuery.of(context).size.width - 1,
                                double.infinity),
                            onPageChanged: (i) {
                              controller.current.value = i + 1;
                            },
                            backgroundDecoration:
                                BoxDecoration(color: Colors.grey[50]),
                            builder: (context, index) {
                              return PhotoViewGalleryPageOptions(
                                onTapUp: (context, details, controllerValue) {
                                  Get.to(
                                    () => ImageViewerPage(
                                        images: images,
                                        currentIndex:
                                            controller.current.value - 1),
                                    transition: Transition.downToUp,
                                  );
                                },
                                minScale: PhotoViewComputedScale.contained * 1,
                                maxScale: PhotoViewComputedScale.contained * 1,
                                imageProvider: CachedNetworkImageProvider(
                                  images[index]['image'],
                                  scale: Get.mediaQuery.size.aspectRatio,
                                ),
                              );
                            },
                            loadingBuilder: (context, event) => Center(
                              child: SizedBox(
                                width: 50.0,
                                height: 50.0,
                                child: CircularProgressIndicator(
                                  value: event == null
                                      ? 0
                                      : event.cumulativeBytesLoaded.toDouble(),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.bottomCenter,
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Obx(
                            () => Container(
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 2),
                                child: Text(
                                  '${data[index].images.length} / ${controller.current.value}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
            Text(
              data[index].title,
              style: MyTextStyles.titleTextStyle(Colors.black),
            ),
            Visibility(
              visible: isHiring,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconContainer(
                      title: 'جنسیت',
                      value: data[index].gender,
                      icon: data[index].gender == 'آقا'
                          ? Iconsax.man
                          : Iconsax.woman,
                      iconColor: MyColors.green,
                      backgroundColor: const Color.fromARGB(158, 220, 239, 207),
                    ),
                    IconContainer(
                      title: 'دستمزد',
                      value: data[index].price == 'توافقی'
                          ? 'توافقی'
                          : MyStrings.digi(data[index].price == ''
                              ? data[index].price
                              : data[index].price),
                      icon: Iconsax.dollar_square,
                      backgroundColor: const Color.fromARGB(140, 251, 221, 217),
                      iconColor: MyColors.red,
                    ),
                    IconContainer(
                      title: 'شیوه پرداخت',
                      value: data[index].payMethod,
                      icon: Iconsax.wallet_money,
                      iconColor: MyColors.orange,
                      backgroundColor: const Color.fromARGB(105, 254, 236, 196),
                    ),
                    IconContainer(
                      title: 'نوع همکاری',
                      value: data[index].workType,
                      icon: Iconsax.home_wifi5,
                      iconColor: MyColors.blue,
                      backgroundColor: MyColors.bluewhite,
                    )
                  ],
                ),
              ),
            ),
            const Divider(),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'توضیحات',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const Icon(
                  Iconsax.clock,
                  color: Colors.grey,
                  size: 15,
                ),
                const SizedBox(width: 5),
                Text(
                  MyStrings.timeFunction(data[index].time),
                  style: MyTextStyles.descriptionsTextStyle(Colors.black),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Text(
                data[index].descs,
                textAlign: TextAlign.justify,
              ),
            ),
            MyButton(
              fillColor: MyColors.blue,
              onClick: () {
                Get.to(JobDetails(mod: data[index]),
                    transition: Transition.downToUp);
              },
              width: MediaQuery.of(context).size.width * 0.7,
              child: Text(
                'مشاهده آگهی',
                style: MyTextStyles.titleTextStyle(Colors.white),
              ),
            ),
          ],
        ),
      ),
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

    final box = GetStorage();
    // دریافت اطلاعات از دیتابیس
    try {
      List<AdvModelTest> jobs =
          await jobsListController.getAds(query: controller.query.value);
      // حذف لودینگ
      Get.back();
      // حذف مارکر ها در صورت وجود داشتن
      if (markerController.markersCount > 0) {
        markerController.clearMarkers();
      }

      int markerIndex = 0;
      // اضافه کردن مارکر های مورد نیاز
      for (var i = 0; i < jobs.length; i++) {
        if (jobs[i].locationBool) {
          _data.add(jobs[i]);
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
