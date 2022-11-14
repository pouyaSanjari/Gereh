import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:gereh/controllers/jobs_list_controller.dart';
import 'package:gereh/models/adv_model.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

final box = GetStorage();

class MapTestController extends GetxController {
  late List<AdvModel> data;
  MapZoomPanBehavior mapZoomPanBehavior = MapZoomPanBehavior(
    zoomLevel: 5,
    maxZoomLevel: 20,
    minZoomLevel: 5,
    enableDoubleTapZooming: true,
    enableMouseWheelZooming: true,
  );
  MapTileLayerController markerController = MapTileLayerController();
  final jobsListController = Get.find<JobsListController>();

  RxMap<String, String> listitem = <String, String>{}.obs;
  RxBool adDetailsVisibility = false.obs;
  RxDouble opacity = 1.0.obs;
  RxDouble initialZoom = 5.1.obs;
  RxInt currentImage = 1.obs;
  RxInt currentIndex = 0.obs;
  RxBool isBookmarked = false.obs;
  Position position = Position(
      longitude: 0,
      latitude: 0,
      timestamp: DateTime.now(),
      accuracy: 0,
      altitude: 0,
      heading: 0,
      speed: 0,
      speedAccuracy: 0);
  late Box hive;

  Future<void> initializeHive() async {
    hive = await Hive.openBox('bookmarks');
  }

  @override
  void onInit() {
    // markerController = MapTileLayerController();

    addMarkers();
    initializeHive();
    super.onInit();
  }

  @override
  InternalFinalCallback<void> get onStart {
    addMarkers();
    return super.onStart;
  }

  @override
  void onReady() {
    addMarkers();
    super.onReady();
  }

  void toUserPostion() async {
    if (position.latitude == 0) {
      position = await determinePosition();
    }
    mapZoomPanBehavior.latLngBounds = MapLatLngBounds(
      MapLatLng(position.latitude - 0.1, position.longitude - 0.1),
      MapLatLng(position.latitude + 0.1, position.longitude + 0.1),
    );
  }

  Future<void> addMarkers() async {
    data = [];
    // برای رفع باگ
    await Future.delayed(Duration.zero);
    // دریافت اطلاعات از دیتابیس
    try {
      // await jobsListController.getAds();
      // حذف لودینگ
      // Get.back();
      // حذف مارکر ها در صورت وجود داشتن
      if (markerController.markersCount > 0) {
        markerController.clearMarkers();
      }

      int markerIndex = 1;
      // اضافه کردن مارکر های مورد نیاز
      for (var i = 0; i < jobsListController.jobsList.length; i++) {
        if (jobsListController.jobsList[i].locationBool) {
          data.add(jobsListController.jobsList[i]);
          markerController.insertMarker(markerIndex);
          markerIndex++;
        }
      }
      if (position.latitude == 0) {
        position = await determinePosition();
      }
      // اینجا برای اینکه بتونم یه مارکر دیگه اضافه کنم مجبور شدم به دیتا یه مورد الکی اضافه کنم که فقط موقعیت کاربر رو نگه داره
      data.add(AdvModel(
          'callNumber',
          'smsNumber',
          'emailAddress',
          'websiteAddress',
          'instagramid',
          'telegramId',
          'whatsappNumber',
          position.latitude.toString(),
          position.longitude.toString(),
          'time',
          false,
          false,
          false,
          false,
          false,
          false,
          false,
          false,
          false,
          false,
          'profission',
          'price',
          'address',
          '0',
          'advertizerId',
          'adType',
          'title',
          'category',
          'city',
          'descs',
          'gender',
          'workType',
          'workTime',
          'payMethod', []));
      markerController.insertMarker(markerIndex);
    } catch (e) {
      print(e);
      Get.back();
      Fluttertoast.showToast(msg: 'اتصال اینترنت خود را بررسی کنید!');
    }
  }

  void addBookmark(AdvModel advModel) {
    bool isExists = checkIfObjectExists(advModel);
    if (!isExists) {
      hive.add(advModel);
    }
  }

  void deleteBookmark(AdvModel advModel) {
    List<AdvModel> model = [];
    for (var i = 0; i < hive.length; i++) {
      model.add(hive.getAt(i));
    }
    for (var i = 0; i < model.length; i++) {
      if (model[i].id == advModel.id) {
        hive.deleteAt(i);
      }
    }
  }

  bool checkIfObjectExists(AdvModel advModel) {
    List<AdvModel> model = [];
    for (var i = 0; i < hive.length; i++) {
      model.add(hive.getAt(i));
    }

    for (var i = 0; i < model.length; i++) {
      if (model[i].id == advModel.id) {
        // object exists
        return true;
      }
    }
    return false;
  }

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
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium);
  }
}
