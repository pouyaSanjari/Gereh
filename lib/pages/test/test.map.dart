import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:sarkargar/components/buttons/button.dart';
import 'package:sarkargar/components/marker.details.container.dart';
import 'package:sarkargar/constants/colors.dart';
import 'package:sarkargar/models/ad.details.model.dart';
import 'package:sarkargar/services/database.dart';
import 'package:syncfusion_flutter_maps/maps.dart';
import 'map.test.controller.dart';

class TestMap extends StatefulWidget {
  const TestMap({Key? key}) : super(key: key);

  @override
  State<TestMap> createState() => _TestMapState();
}

class _TestMapState extends State<TestMap> {
  final controller = Get.put(MapTestController());
  final String mapAddress =
      'https://map.ir/shiveh/xyz/1.0.0/Shiveh:Shiveh@EPSG:3857@png/{z}/{x}/{y}.png?x-api-key=';
  final String apiKey =
      'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjhmODZjYjc0MDg5MTI4NjAyNmQ3ODkyMDQ5NjVjZmI1MWRhZTY0MzE5MGEzMDgxMTQ3ZTBkNjQ0ZmM0MjE2NWYwZTZlYTgwNDgxY2Y0ZjJlIn0.eyJhdWQiOiIxOTYxMCIsImp0aSI6IjhmODZjYjc0MDg5MTI4NjAyNmQ3ODkyMDQ5NjVjZmI1MWRhZTY0MzE5MGEzMDgxMTQ3ZTBkNjQ0ZmM0MjE2NWYwZTZlYTgwNDgxY2Y0ZjJlIiwiaWF0IjoxNjY0NjE4NDE2LCJuYmYiOjE2NjQ2MTg0MTYsImV4cCI6MTY2NzEyNDAxNiwic3ViIjoiIiwic2NvcGVzIjpbImJhc2ljIl19.X4uuixNND2gEvlamTn73r9b4XxxF0GEQQsIFRJtxyxtHHQxAQRTzcG5CwZTn4zNtoVdQ6Iu9iQw6TMeOElaB2vmmrpefgtIShlM77uvpOcG-MpVoHIfEL248Jn4VK0_ATYDHTsivh9AiVJjwpHcas_hx9M10y0TiUHO52cNhCKsCWeO56qBeR8bo64dkxg0tLikGIEzAE2MmWJFQK74wfPjwRwB6PBUE_qoWLp2xLB9kDRNs9WZUwOblauWzAehT-C51hB749fDT40W2obzNa0eFtDh-JM1N1LXFvpZctykiUn0ZliobtqJSptqnOw2sRCkBuDLu6zwIm915Bn2OyQ';
  late List<Model> _data;
  late MapZoomPanBehavior _mapZoomPanBehavior;
  late MapTileLayerController markerController;
  @override
  void initState() {
    markerController = MapTileLayerController();
    _mapZoomPanBehavior = MapZoomPanBehavior(
      zoomLevel: 5,
      maxZoomLevel: 20,
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
                tooltip: 'دریافت موقعیت شما',
                backgroundColor: MyColors.black,
                child: const Icon(
                  Icons.location_searching_rounded,
                  size: 30,
                  color: MyColors.notWhite,
                ),
                onPressed: () async {
                  toPostion();
                },
              ),
              FloatingActionButton(
                tooltip: 'دریافت موقعیت شما',
                backgroundColor: MyColors.black,
                child: const Icon(
                  Iconsax.more_square,
                  size: 30,
                  color: MyColors.notWhite,
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
                    urlTemplate: mapAddress + apiKey,
                    zoomPanBehavior: _mapZoomPanBehavior,
                    initialFocalLatLng: const MapLatLng(31.0, 54.0),
                    controller: markerController,
                    markerBuilder: (BuildContext context, int index) {
                      return MapMarker(
                        latitude: _data[index].lat,
                        longitude: _data[index].lon,
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
                                        backgroundColor: Colors.transparent,
                                        context: context,
                                        useRootNavigator: true,
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
                                    child: const Icon(
                                      FontAwesomeIcons.mapPin,
                                      color: MyColors.blue,
                                      size: 30,
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

  Container bottomSheet(List<Model> data, int index) {
    List images = data[index].images;
    return Container(
      decoration: const BoxDecoration(
        color: MyColors.notWhite,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10),
        ),
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: [
            const SizedBox(height: 5),
            Container(
              height: 6,
              width: 40,
              decoration: BoxDecoration(
                  color: Colors.grey, borderRadius: BorderRadius.circular(10)),
            ),
            const SizedBox(height: 5),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              height: 200,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: PhotoViewGallery.builder(
                      wantKeepAlive: true,
                      itemCount: images.length,
                      customSize: Size(MediaQuery.of(context).size.width - 1,
                          double.infinity),
                      onPageChanged: (index) {
                        controller.current.value = index + 1;
                      },
                      backgroundDecoration:
                          BoxDecoration(color: Colors.grey[50]),
                      builder: (context, index) {
                        return PhotoViewGalleryPageOptions(
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
            const Expanded(child: SizedBox()),
            MyButton(
              fillColor: MyColors.blue,
              onClick: () {},
              width: MediaQuery.of(context).size.width * 0.7,
              child: const Text('مشاهده آگهی'),
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

    final database = AppDataBase();
    _data = [];

    try {
      List jobs = await database.getAds(
          query: "SELECT * FROM `requests` WHERE `city` = 'جیرفت'");
      Get.back();
      if (markerController.markersCount > 0) {
        markerController.clearMarkers();
      }

      int markerIndex = 0;
      for (var itemIndex = 0; itemIndex < jobs[0].length; itemIndex++) {
        List itemImage = jobs[1]
            .where((element) => element['adId'] == jobs[0][itemIndex]['id'])
            .toList();
        if (jobs[0][itemIndex]['locationlat'] != '') {
          _data.add(Model(
              lat: double.parse(jobs[0][itemIndex]['locationlat']),
              lon: double.parse(jobs[0][itemIndex]['locationlon']),
              title: '${jobs[0][itemIndex]['title']}',
              imageUrl: itemImage.isEmpty ? '' : itemImage[0]['image'],
              adId: jobs[1][itemIndex]['id'],
              category: jobs[0][itemIndex]['category'],
              images: itemImage));
          markerController.insertMarker(markerIndex);
          markerIndex++;
        }
      }
    } catch (e) {
      Get.back();
      Fluttertoast.showToast(msg: 'اتصال اینترنت خود را بررسی کنید!');
    }
  }

  void toPostion() async {
    Position position = await controller.determinePosition();
    _mapZoomPanBehavior.latLngBounds = MapLatLngBounds(
      MapLatLng(position.latitude - 0.1, position.longitude - 0.1),
      MapLatLng(position.latitude + 0.1, position.longitude + 0.1),
    );
  }
}
