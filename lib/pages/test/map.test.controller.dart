import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

final box = GetStorage();

class MapTestController extends GetxController {
  RxMap<String, String> listitem = <String, String>{}.obs;
  RxBool adDetailsVisibility = false.obs;
  RxDouble opacity = 1.0.obs;
  RxDouble initialZoom = 5.1.obs;
  RxInt current = 1.obs;

  RxString query =
      "SELECT * FROM `requests` WHERE `city` = '${box.read('city')}'".obs;

  void showHideAdsDetails() {
    if (adDetailsVisibility.value) {
      opacity.value = 0;
      Future.delayed(
        const Duration(milliseconds: 200),
        () {
          adDetailsVisibility.value = false;
        },
      );
    } else {
      adDetailsVisibility.value = true;
      Future.delayed(
        const Duration(milliseconds: 200),
        () {
          opacity.value = 1;
        },
      );
    }
  }

  Future<Position> determinePosition() async {
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
