import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:sarkargar/services/uiDesign.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

import '../../../controllers/request_controller.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final getController = Get.put(RequestController());
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
        floatingActionButton: FloatingActionButton(
          onPressed: () => Get.back(result: [getController.address.value]),
          backgroundColor: Colors.grey[50],
          child:
              const Icon(FontAwesomeIcons.check, size: 35, color: Colors.green),
        ),
        appBar: AppBar(
          title: const Text('انتخاب موقعیت مکانی'),
          centerTitle: true,
        ),
        // To obtain the maps local point, we have added a gesture
        // detector to the map’s widget.
        body: Column(
          children: [
            Expanded(
              child: GestureDetector(
                onTapUp: (TapUpDetails details) {
                  updateMarkerChange(details.localPosition);
                },
                child: SfMaps(
                  layers: [
                    MapTileLayer(
                      urlTemplate: mapAddress + apiKey,
                      zoomPanBehavior: _mapZoomPanBehavior,
                      initialFocalLatLng: const MapLatLng(31.0, 54.0),
                      controller: markerController,
                      markerBuilder: (BuildContext context, int index) {
                        return MapMarker(
                          latitude: _markerPosition.latitude,
                          longitude: _markerPosition.longitude,
                          child: const Icon(FontAwesomeIcons.locationDot,
                              color: Colors.black, size: 40),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            Obx(() => SizedBox(
                  height: 73,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text('آدرس:', style: UiDesign().titleTextStyle()),
                        Text(
                          getController.address.value,
                          style: UiDesign().descriptionsTextStyle(),
                        ),
                      ],
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  void updateMarkerChange(Offset position) {
    // We have converted the local point into latlng and inserted marker
    // in that position.
    _markerPosition = markerController.pixelToLatLng(position);
    if (markerController.markersCount > 0) {
      markerController.clearMarkers();
    }
    markerController.insertMarker(0);
    getController.getAddressUsingLatLon(
        _markerPosition.latitude, _markerPosition.longitude);
    getController.selectedLat.value = _markerPosition.latitude;
    getController.selectedLon.value = _markerPosition.longitude;

    // getAddressUsingLatLon(_markerPosition.latitude, _markerPosition.longitude);
  }
}
