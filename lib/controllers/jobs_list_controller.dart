import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class JobsListController extends GetxController {
  RxBool isInTheTopOfList = true.obs;
  double listPosition = 0;

  final box = GetStorage();
  RxList jobsList = [].obs;
  RxList searchedList = [].obs;
  RxList jobsImages = [].obs;
  RxList<String> citiesList = <String>[].obs;
  RxList<String> provienceList = <String>[].obs;

  RxMap<String, String> searchMap = {'': ''}.obs;

  RxBool cityNamesEnabled = false.obs;

  RxString city = ''.obs;
  RxString provience = ''.obs;
  RxString searchText = ''.obs;

  RxMap<String, Widget> chips = <String, Widget>{}.obs;

  Future<bool> searchMethod() async {
    searchedList.clear();
    searchedList.value = jobsList;
    if (searchMap.isNotEmpty) {
      searchMap.forEach(
        (key, value) {
          searchedList.value = searchedList.where(
            (p0) {
              return p0[key].toString().contains(value);
            },
          ).toList();
        },
      );
    }

    // چک می کنیم نتیحه داده یا نه
    if (searchedList.isEmpty) {
      searchMap.clear();
      Fluttertoast.showToast(msg: 'موردی یافت نشد');
      return false;
    } else {
      return true;
    }
  }

  void initialData() async {
    cityNamesEnabled.value = box.read('cityNamesEnabled') ?? false;
    city.value = box.read('city') ?? '';
    provience.value = box.read('provience') ?? '';
  }

  @override
  void onInit() {
    initialData();
    super.onInit();
  }
}
