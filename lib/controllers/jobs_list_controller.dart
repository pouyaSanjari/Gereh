import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class JobsListController extends GetxController {
  final box = GetStorage();
  RxList jobsList = [].obs;
  RxList searchedList = [].obs;

  RxList searches = [].obs;
  RxMap<String, String> search = {'sdfgsd': 'asdfasdf'}.obs;
  RxList jobsImages = [].obs;
  RxList<String> citiesList = <String>[].obs;
  RxList<String> provienceList = <String>[].obs;
  RxBool cityNamesEnabled = false.obs;
  RxString city = ''.obs;
  RxString provience = ''.obs;
  RxString searchText = ''.obs;

  RxMap<String, Widget> chips = <String, Widget>{}.obs;

// به ازای هرکدام از مقادیر لیست جستجو یک جستجو در لیست مشاغل انجام میده
  void searchMethod() async {
    print(searches);
    if (searches.isNotEmpty) {
      searchedList.clear();
      for (var element in searches) {
        searchedList.value = jobsList.where((p0) {
          var elementAsString = p0.toString();
          return elementAsString.contains(element);
        }).toList();
      }
    } else {
      searchedList.clear();
    }
  }

  void searchMap() async {
    searchedList.clear();
    searchedList.value = jobsList;
    search.forEach(
      (key, value) {
        searchedList.value = searchedList.where(
          (p0) {
            return p0[key].toString().contains(value);
          },
        ).toList();
      },
    );
    if (searchedList.isEmpty) {
      Fluttertoast.showToast(msg: 'موردی یافت نشد');
    }
  }

  void initialData() async {
    cityNamesEnabled.value = box.read('cityNamesEnabled') ?? false;
    city.value = box.read('city') ?? '';
    provience.value = box.read('provience') ?? '';
  }

  @override
  void onInit() {
    city.value = box.read('city');
    initialData();
    super.onInit();
  }
}
