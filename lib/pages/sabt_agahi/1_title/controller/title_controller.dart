import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gereh/pages/sabt_agahi/mainPage/controller/request_controller.dart';
import 'package:gereh/services/database.dart';
import 'package:get/get.dart';

enum TitlePageState { nothing, estekhdam, tabligh }

class TitleController extends GetxController {
  @override
  void onReady() {
    AppDataBase().uploadedImages();
    cityTEC.value.text = box.read('city');
    super.onReady();
  }

  final database = AppDataBase();
  final mainController = RequestController();

  RxInt adType = 2.obs;
  RxList images = [].obs;
  RxString titleError = ''.obs;
  Rx<TextEditingController> titleTEC = TextEditingController().obs;
  Rx<TextEditingController> categoryTEC = TextEditingController().obs;
  Rx<TextEditingController> cityTEC = TextEditingController().obs;

  RxString titleimage = ''.obs;

  // used in select city page
  RxString city = ''.obs;
  RxList cities = [].obs;

  // used in select category
  RxList jobGroups = [].obs;
  RxList jobs = [].obs;
  //دریافت مشاغل از دیتابیس
  getAllJobs() async {
    List response = await database.getJobs();
    if (jobs.isEmpty) {
      for (var i = 0; i < response.length; i++) {
        jobs.add(response[i]);
      }
    }
    List response2 = await database.getJobGroups();
    if (jobGroups.isEmpty) {
      for (int i = 0; i < response2.length; i++) {
        jobGroups.add(response2[i]);
      }
    }
  }

  //errors
  RxString categoryError = ''.obs;
  RxString cityError = ''.obs;

  // validates all inputs when going to next page
  TitlePageState validateTitlePage() {
    if (adType.value == 2) {
      Fluttertoast.showToast(msg: 'لطفا نوع آگهی را انتخاب کنید.');
    }
    if (titleTEC.value.text.trim().isEmpty) {
      titleError.value = 'وارد کردن عنوان برای آگهی الزامی است.';
    }

    if (categoryTEC.value.text.trim().isEmpty) {
      categoryError.value = 'لطفا یک دسته بندی برای آگهی خود انتخاب کنید.';
    }
    if (cityTEC.value.text.trim().isEmpty) {
      cityError.value = 'لطفا شهر محل آگهی خود را انتخاب کنید.';
    }
    if (cityError.isEmpty &&
        categoryError.isEmpty &&
        titleError.isEmpty &&
        adType.value != 2) {
      if (adType.value == 0) {
        return TitlePageState.estekhdam;
      } else {
        return TitlePageState.tabligh;
      }
    }
    return TitlePageState.nothing;
  }
}
