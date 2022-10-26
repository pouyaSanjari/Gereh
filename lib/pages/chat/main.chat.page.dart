import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';

class MainChatPage extends StatefulWidget {
  const MainChatPage({Key? key}) : super(key: key);

  @override
  State<MainChatPage> createState() => _MainChatPageState();
}

late MapController mapController;

class _MainChatPageState extends State<MainChatPage> {
  @override
  void initState() {
    mapController = MapController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const String mapAddress =
        'https://map.ir/shiveh/xyz/1.0.0/Shiveh:Shiveh@EPSG:3857@png/{z}/{x}/{y}.png?x-api-key=';
    const String apiKey =
        'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjhmODZjYjc0MDg5MTI4NjAyNmQ3ODkyMDQ5NjVjZmI1MWRhZTY0MzE5MGEzMDgxMTQ3ZTBkNjQ0ZmM0MjE2NWYwZTZlYTgwNDgxY2Y0ZjJlIn0.eyJhdWQiOiIxOTYxMCIsImp0aSI6IjhmODZjYjc0MDg5MTI4NjAyNmQ3ODkyMDQ5NjVjZmI1MWRhZTY0MzE5MGEzMDgxMTQ3ZTBkNjQ0ZmM0MjE2NWYwZTZlYTgwNDgxY2Y0ZjJlIiwiaWF0IjoxNjY0NjE4NDE2LCJuYmYiOjE2NjQ2MTg0MTYsImV4cCI6MTY2NzEyNDAxNiwic3ViIjoiIiwic2NvcGVzIjpbImJhc2ljIl19.X4uuixNND2gEvlamTn73r9b4XxxF0GEQQsIFRJtxyxtHHQxAQRTzcG5CwZTn4zNtoVdQ6Iu9iQw6TMeOElaB2vmmrpefgtIShlM77uvpOcG-MpVoHIfEL248Jn4VK0_ATYDHTsivh9AiVJjwpHcas_hx9M10y0TiUHO52cNhCKsCWeO56qBeR8bo64dkxg0tLikGIEzAE2MmWJFQK74wfPjwRwB6PBUE_qoWLp2xLB9kDRNs9WZUwOblauWzAehT-C51hB749fDT40W2obzNa0eFtDh-JM1N1LXFvpZctykiUn0ZliobtqJSptqnOw2sRCkBuDLu6zwIm915Bn2OyQ';

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              print(mapController.center);
            },
            label: const Text('data')),
        body: FlutterMap(
          mapController: mapController,
          options: MapOptions(
            maxZoom: 19.4,
            interactiveFlags: InteractiveFlag.pinchZoom |
                InteractiveFlag.drag |
                InteractiveFlag.flingAnimation |
                InteractiveFlag.pinchMove,
            rotation: 0,
            center: LatLng(31.0, 54.0),
            onPositionChanged: (position, hasGesture) {},
            zoom: 5,
            controller: mapController,
          ),
          layers: [
            TileLayerOptions(
              keepBuffer: 5,
              maxZoom: 20,
              urlTemplate: mapAddress + apiKey,
              retinaMode: true,
            )
          ],
        ),
      ),
    );
  }
}
