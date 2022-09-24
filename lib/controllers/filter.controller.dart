import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'jobs_list_controller.dart';

class FilterController extends GetxController {
  final box = GetStorage();
  RxList<double> ghimat = [0.0, 1.0].obs;
  RxInt adType = 3.obs;
  RxInt hiringType = 3.obs;
  RxInt gender = 3.obs;
  RxInt minPrice = 0.obs;
  RxInt maxPrice = 1000000.obs;
  final categoryTEController = TextEditingController().obs;
  final jobsListController = Get.find<JobsListController>();

  void setFilter() async {
    // jobsListController.searchMap.clear();
    // عدد 3 به معنای غیر فعال بودن است
    if (adType.value != 3) {
      jobsListController.searchMap.addAll({'adtype': adType.value.toString()});
    }
    if (hiringType.value != 3) {
      jobsListController.searchMap
          .addAll({'hiringtype': hiringType.value.toString()});
    }
    if (gender.value != 3) {
      jobsListController.searchMap.addAll({'gender': gender.value.toString()});
    }
    if (categoryTEController.value.text != '') {
      jobsListController.searchMap
          .addAll({'category': categoryTEController.value.text});
    }
    if (jobsListController.searchMap.isEmpty) {
      Fluttertoast.showToast(msg: 'حداقل یک مورد را انتخاب کنید');
      return;
    }
    Future<bool> search = jobsListController.searchMethod();
    if (await search) {
      Get.back();
    } else {
      jobsListController.city.value = '';
      jobsListController.city.value = box.read('city');
      Get.back();
    }
  }

  void deleteFilter() {
    Get.back();
    adType.value = 3;
    hiringType.value = 3;
    gender.value = 3;
    categoryTEController.value.text = '';
    jobsListController.searchMap.clear();
    jobsListController.searchedList.clear();
    jobsListController.city.value = '';
    jobsListController.city.value = box.read('city');
  }

  void convertNumber({required List<double> value}) {
    // مقداری بین 0 تا 1 بر میگردونه پس ضربش می کنیم تا به عدد دلخواه برسیم
    ghimat.value = value;
    if (hiringType.value == 1) {
      minPrice.value = (value[0] * 30000000).round();
    } else {
      minPrice.value = (value[0] * 1000000).round();
    }
    if (hiringType.value == 1) {
      maxPrice.value = (value[1] * 30000000).round();
    } else {
      maxPrice.value = (value[1] * 1000000).round();
    }
  }

  void resetMultiSliderWidget({required int value}) {
    hiringType.value = value;
    ghimat[0] = 0.0;
    ghimat[1] = 1.0;
    if (value == 0) {
      minPrice.value = 0;
      maxPrice.value = 1000000;
    }
    if (value == 1) {
      minPrice.value = 0;
      maxPrice.value = 30000000;
    }
  }
}
