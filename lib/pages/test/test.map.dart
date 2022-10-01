import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sarkargar/constants/colors.dart';
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
  String mapAddress =
      'https://map.ir/shiveh/xyz/1.0.0/Shiveh:Shiveh@EPSG:3857@png/{z}/{x}/{y}.png?x-api-key=';
  String apiKey =
      // 'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6ImYwYjNkZmEzYmU0MTEyOGEzZGNlNDVkOWQ1OTU0MmU5NmVmYjZhMjMwZWM5MjUzNzRiZGZiNGY1MWIzNmM4ZTI2NTBkZWQ5ZWUxMmU3MjM0In0.eyJhdWQiOiIxODc5NSIsImp0aSI6ImYwYjNkZmEzYmU0MTEyOGEzZGNlNDVkOWQ1OTU0MmU5NmVmYjZhMjMwZWM5MjUzNzRiZGZiNGY1MWIzNmM4ZTI2NTBkZWQ5ZWUxMmU3MjM0IiwiaWF0IjoxNjU4MjU4NTQ5LCJuYmYiOjE2NTgyNTg1NDksImV4cCI6MTY2MDg1MDU0OSwic3ViIjoiIiwic2NvcGVzIjpbImJhc2ljIl19.Kd5dqFBrzvJmtkVL-LqRsDE3tHw4SSFGxc_dFs9v_4DRRkfaiKxcgSj6iRGjWtQcJTF7kikj6RS9NNI4MV5xBbqSjSiblKWfRXTqtAtoE9a_FJO7yt_DmcSpuUf99bbwSs99UPmOX945iMEFVbJSS-KyHfcQ8Q_G3XwymmD4hjxGvEsV32KzyeXUuUswzL9RwUFjtAn-ix-9-9DSRuSAEFk9MN2FP8_o3YvJ2m-7xJwFYy6nfn-K5_EncWpyJfbFWzkge5VS7XP1Mrnn8Jui9EgcSJsEzQjDt4jHN5_ZIVW63_Mq2kD3VlVrgqM97BrJlTaDQcICxaqt55O5eu9X9A';
      'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjhmODZjYjc0MDg5MTI4NjAyNmQ3ODkyMDQ5NjVjZmI1MWRhZTY0MzE5MGEzMDgxMTQ3ZTBkNjQ0ZmM0MjE2NWYwZTZlYTgwNDgxY2Y0ZjJlIn0.eyJhdWQiOiIxOTYxMCIsImp0aSI6IjhmODZjYjc0MDg5MTI4NjAyNmQ3ODkyMDQ5NjVjZmI1MWRhZTY0MzE5MGEzMDgxMTQ3ZTBkNjQ0ZmM0MjE2NWYwZTZlYTgwNDgxY2Y0ZjJlIiwiaWF0IjoxNjY0NjE4NDE2LCJuYmYiOjE2NjQ2MTg0MTYsImV4cCI6MTY2NzEyNDAxNiwic3ViIjoiIiwic2NvcGVzIjpbImJhc2ljIl19.X4uuixNND2gEvlamTn73r9b4XxxF0GEQQsIFRJtxyxtHHQxAQRTzcG5CwZTn4zNtoVdQ6Iu9iQw6TMeOElaB2vmmrpefgtIShlM77uvpOcG-MpVoHIfEL248Jn4VK0_ATYDHTsivh9AiVJjwpHcas_hx9M10y0TiUHO52cNhCKsCWeO56qBeR8bo64dkxg0tLikGIEzAE2MmWJFQK74wfPjwRwB6PBUE_qoWLp2xLB9kDRNs9WZUwOblauWzAehT-C51hB749fDT40W2obzNa0eFtDh-JM1N1LXFvpZctykiUn0ZliobtqJSptqnOw2sRCkBuDLu6zwIm915Bn2OyQ';
  late List<Model> _data;
  // late MapLatLng _markerPosition;
  late MapZoomPanBehavior _mapZoomPanBehavior;
  late MapTileLayerController markerController;

  @override
  void initState() {
    markerController = MapTileLayerController();
    addMarkers();
    _mapZoomPanBehavior = MapZoomPanBehavior(
      zoomLevel: 5,
      maxZoomLevel: 20,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: Column(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  if (controller.showContainer.value) {
                    controller.opacity.value = 0;
                    Future.delayed(
                      const Duration(milliseconds: 200),
                      () {
                        controller.showContainer.value = false;
                      },
                    );
                  } else {
                    controller.showContainer.value = true;
                    Future.delayed(
                      const Duration(milliseconds: 200),
                      () {
                        controller.opacity.value = 1;
                      },
                    );
                  }
                },
                child: SfMaps(
                  layers: [
                    MapTileLayer(
                      tooltipSettings: MapTooltipSettings(),
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
                                  visible: controller.showContainer.value,
                                  child: AnimatedOpacity(
                                    opacity: controller.opacity.value,
                                    duration: const Duration(milliseconds: 200),
                                    child: MarkerDetailsContainer(
                                        data: _data, index: index),
                                  ),
                                ),
                              ),
                              AnimationConfiguration.synchronized(
                                child: FadeInAnimation(
                                  curve: Curves.fastLinearToSlowEaseIn,
                                  duration: const Duration(milliseconds: 2500),
                                  child: Obx(
                                    // padding for when the above container is showing to avoid changing marker location
                                    () => Padding(
                                      padding: EdgeInsets.only(
                                          bottom: controller.showContainer.value
                                              ? 65.0
                                              : 0),
                                      child: const Icon(
                                          FontAwesomeIcons.locationDot,
                                          color: MyColors.red,
                                          size: 30),
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

  Future<void> addMarkers() async {
    final database = AppDataBase();
    _data = [];
    List jobs = await database.getAds(
        query: "SELECT * FROM `requests` WHERE `city` = 'جیرفت'");
    if (markerController.markersCount > 0) {
      markerController.clearMarkers();
    }

    int index = 0;
    for (var i = 0; i < jobs[0].length; i++) {
      List itemImage = jobs[1]
          .where((element) => element['adId'] == jobs[0][i]['id'])
          .toList();
      if (jobs[0][i]['locationlat'] != '') {
        _data.add(Model(
            lat: double.parse(jobs[0][i]['locationlat']),
            lon: double.parse(jobs[0][i]['locationlon']),
            title: '${jobs[0][i]['title']}',
            imageUrl: itemImage.isEmpty ? '' : itemImage[0]['image']));
        markerController.insertMarker(index);
        index++;
      }
    }
  }
}

class MarkerDetailsContainer extends StatelessWidget {
  final List<Model> data;
  final int index;

  const MarkerDetailsContainer({
    super.key,
    required this.index,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Container(
        decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                  blurRadius: 20,
                  color: Colors.black26,
                  spreadRadius: 0,
                  blurStyle: BlurStyle.normal)
            ],
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(4))),
        width: 170,
        height: 60,
        child: Row(
          children: [
            SizedBox(
                height: 60,
                width: 60,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                    child: data[index].imageUrl == ''
                        ? Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(5)),
                            height: 60,
                            width: 60,
                            child: const Icon(
                              Iconsax.gallery_slash,
                              size: 30,
                              color: Colors.grey,
                            ),
                          )
                        : CachedNetworkImage(
                            imageUrl: data[index].imageUrl, fit: BoxFit.cover),
                  ),
                )),
            SizedBox(width: 100, child: Text(data[index].title)),
          ],
        ),
      ),
    );
  }
}

class Model {
  double lat;
  double lon;
  String title;
  String imageUrl;

  Model(
      {required this.lat,
      required this.lon,
      required this.title,
      required this.imageUrl});
}
