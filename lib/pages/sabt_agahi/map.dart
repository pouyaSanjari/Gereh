import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sarkargar/constants/colors.dart';
import 'package:sarkargar/constants/my_strings.dart';

import 'package:sarkargar/services/ui_design.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

import '../../controllers/request_controller.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final controller = Get.put(RequestController());
  final uiDesign = UiDesign();
  String mapAddress =
      'https://map.ir/shiveh/xyz/1.0.0/Shiveh:Shiveh@EPSG:3857@png/{z}/{x}/{y}.png?x-api-key=';
  String apiKey =
      'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6ImYwYjNkZmEzYmU0MTEyOGEzZGNlNDVkOWQ1OTU0MmU5NmVmYjZhMjMwZWM5MjUzNzRiZGZiNGY1MWIzNmM4ZTI2NTBkZWQ5ZWUxMmU3MjM0In0.eyJhdWQiOiIxODc5NSIsImp0aSI6ImYwYjNkZmEzYmU0MTEyOGEzZGNlNDVkOWQ1OTU0MmU5NmVmYjZhMjMwZWM5MjUzNzRiZGZiNGY1MWIzNmM4ZTI2NTBkZWQ5ZWUxMmU3MjM0IiwiaWF0IjoxNjU4MjU4NTQ5LCJuYmYiOjE2NTgyNTg1NDksImV4cCI6MTY2MDg1MDU0OSwic3ViIjoiIiwic2NvcGVzIjpbImJhc2ljIl19.Kd5dqFBrzvJmtkVL-LqRsDE3tHw4SSFGxc_dFs9v_4DRRkfaiKxcgSj6iRGjWtQcJTF7kikj6RS9NNI4MV5xBbqSjSiblKWfRXTqtAtoE9a_FJO7yt_DmcSpuUf99bbwSs99UPmOX945iMEFVbJSS-KyHfcQ8Q_G3XwymmD4hjxGvEsV32KzyeXUuUswzL9RwUFjtAn-ix-9-9DSRuSAEFk9MN2FP8_o3YvJ2m-7xJwFYy6nfn-K5_EncWpyJfbFWzkge5VS7XP1Mrnn8Jui9EgcSJsEzQjDt4jHN5_ZIVW63_Mq2kD3VlVrgqM97BrJlTaDQcICxaqt55O5eu9X9A';
  String address = '';

  late MapLatLng _markerPosition;
  late MapZoomPanBehavior _mapZoomPanBehavior;
  late MapTileLayerController markerController;

  @override
  void initState() {
    markerController = MapTileLayerController();
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
        floatingActionButton: FloatingActionButton(
          onPressed: () => Get.back(result: [controller.address.value]),
          backgroundColor: MyColors.blueGrey,
          child: const Icon(
            FontAwesomeIcons.check,
            size: 25,
          ),
        ),

        appBar: AppBar(
          leading: InkWell(
              onTap: () => Get.back(),
              child: const Icon(Iconsax.arrow_right_3, color: Colors.black)),
          actions: [
            InkWell(
              onTap: () async {
                var currentLocatin = await _determinePosition();
                changeMarkerLocationUsingLatLon(
                    currentLocatin.latitude, currentLocatin.longitude);
              },
              child: const Padding(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: Icon(
                  Icons.location_searching_rounded,
                  color: Colors.black87,
                ),
              ),
            )
          ],
          title: const Text(
            'انتخاب موقعیت مکانی',
            style: TextStyle(color: Colors.black87),
          ),
        ),
        // To obtain the maps local point, we have added a gesture
        // detector to the map’s widget.
        body: Column(
          children: [
            Expanded(
              child: GestureDetector(
                onTapUp: (TapUpDetails details) {
                  changeMarkerLocationUsingTapPosition(details.localPosition);
                },
                child: SfMaps(
                  layers: [
                    MapTileLayer(
                      urlTemplate: MyStrings.mapAddres + MyStrings.apiKey,
                      zoomPanBehavior: _mapZoomPanBehavior,
                      initialFocalLatLng: const MapLatLng(31.0, 54.0),
                      controller: markerController,
                      markerBuilder: (BuildContext context, int index) {
                        return MapMarker(
                          latitude: _markerPosition.latitude,
                          longitude: _markerPosition.longitude,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Obx(() => Container(
                                  decoration: BoxDecoration(
                                      boxShadow: const [
                                        BoxShadow(
                                            color: Colors.black38,
                                            blurRadius: 15,
                                            spreadRadius: 1,
                                            offset: Offset(-5, 5))
                                      ],
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10)),
                                  width: 180,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(controller.address.value),
                                  ))),
                              const SizedBox(
                                height: 10,
                              ),
                              const Icon(FontAwesomeIcons.locationDot,
                                  color: MyColors.red, size: 30),
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

  void changeMarkerLocationUsingTapPosition(Offset position) {
    // We have converted the local point into latlng and inserted marker
    // in that position.
    _markerPosition = markerController.pixelToLatLng(position);
    if (markerController.markersCount > 0) {
      markerController.clearMarkers();
    }
    markerController.insertMarker(0);
// روی نقطه انتخاب شده زوم می کند
    _mapZoomPanBehavior.latLngBounds = MapLatLngBounds(
        MapLatLng(_markerPosition.latitude - 0.005,
            _markerPosition.longitude - 0.005),
        MapLatLng(_markerPosition.latitude + 0.005,
            _markerPosition.longitude + 0.005));

    controller.getAddressUsingLatLon(
        _markerPosition.latitude, _markerPosition.longitude);
    controller.selectedLat.value = _markerPosition.latitude;
    controller.selectedLon.value = _markerPosition.longitude;

    // getAddressUsingLatLon(_markerPosition.latitude, _markerPosition.longitude);
  }

  void changeMarkerLocationUsingLatLon(double lat, double lon) {
    _markerPosition = MapLatLng(lat, lon);
    if (markerController.markersCount > 0) {
      markerController.clearMarkers();
    }
    markerController.insertMarker(0);

    _mapZoomPanBehavior.latLngBounds = MapLatLngBounds(
        MapLatLng(_markerPosition.latitude - 0.005,
            _markerPosition.longitude - 0.005),
        MapLatLng(_markerPosition.latitude + 0.005,
            _markerPosition.longitude + 0.005));

    controller.getAddressUsingLatLon(
        _markerPosition.latitude, _markerPosition.longitude);
    controller.selectedLat.value = _markerPosition.latitude;
    controller.selectedLon.value = _markerPosition.longitude;
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}
