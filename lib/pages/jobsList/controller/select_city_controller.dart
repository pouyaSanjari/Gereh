import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gereh/constants/my_strings.dart';
import 'package:gereh/services/database.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

final box = GetStorage();

class SelectCityController extends GetxController {
  @override
  void onInit() {
    city.value = box.read('city') ?? '';
    getCitiesList();
    super.onInit();
  }

  RxString city = ''.obs;
  RxList cities = [].obs;
  RxList searched = [].obs;
  RxString categoryError = ''.obs;
  List ostan = [];
  RxString searchValue = ''.obs;
  Rx<TextEditingController> searchTEC = TextEditingController().obs;
  final appDataBase = AppDataBase();

  void updateSearchValue(String value) {
    searchValue.value = searchTEC.value.text.toString();
    search();
  }

  getCitiesList() async {
    if (cities.isEmpty) {
      cities.value = await appDataBase.getCitiesAndProvinces();
    }
    for (var i = 0; i < cities.length; i++) {
      if (cities[i]['parent'] == '0') {
        ostan.add(cities[i]);
      }
    }
  }

  List<Widget> citiesList(String parent) {
    List<Widget> items = [];
    for (var i = 0; i < cities.length; i++) {
      if (cities[i]['parent'] == parent) {
        items.add(InkWell(
          onTap: () {
            city.value = cities[i]['title'];
            Get.back(result: city.value);
          },
          child: ListTile(
            title: Text(cities[i]['title']),
          ),
        ));
      }
    }

    return items;
  }

  search() {
    searched.clear();
    for (var i = 0; i < cities.length; i++) {
      if (cities[i]['title'].toString().contains(searchValue) &&
          cities[i]['parent'] != '0') {
        searched.add(cities[i]['title']);
      }
    }
  }

  getCityNameByLocation() async {
    var currentLocation = await _determinePosition();
    var url = Uri.parse(
        'https://map.ir/fast-reverse?lat=${currentLocation.latitude}&lon=${currentLocation.longitude}');
    var response =
        await http.get(url, headers: {"x-api-key": MyStrings.apiKey});

    var json = convert.jsonDecode(convert.utf8.decode(response.bodyBytes));

    String recievedCity = json['city'].toString().trim();
    String county = json['county'].toString().trim();
    String state = json['province'].toString().trim();

    if (city.trim().isNotEmpty) {
      city.value = recievedCity.trim();
    } else if (county.trim().isNotEmpty) {
      city.value = county.trim();
    } else {
      city.value = state.trim();
    }
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
