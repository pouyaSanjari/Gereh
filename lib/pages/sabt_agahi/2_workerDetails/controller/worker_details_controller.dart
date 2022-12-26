import 'package:flutter/material.dart';
import 'package:gereh/pages/sabt_agahi/mainPage/controller/request_controller.dart';
import 'package:get/get.dart';

class WorkerDetailsController extends GetxController {
  final requestController = Get.put(RequestController());

  Rx<TextEditingController> genderTEC = TextEditingController().obs;
  Rx<TextEditingController> cooperationTypeTEC = TextEditingController().obs;
  Rx<TextEditingController> workTimeTEC = TextEditingController().obs;
  Rx<TextEditingController> payMethodTEC = TextEditingController().obs;
  Rx<TextEditingController> skillTEC = TextEditingController().obs;
  Rx<TextEditingController> priceTEC = TextEditingController().obs;

  RxBool ghimatTavafoghiBL = false.obs;
  RxString price = ''.obs;
  RxBool priceEnabled = true.obs;

  // errors
  RxString genderError = ''.obs;
  RxString cooperationTypeError = ''.obs;
  RxString workTimeError = ''.obs;
  RxString payMethodError = ''.obs;
  RxString skillError = ''.obs;
  RxString priceError = ''.obs;

  void validateWorkerDeatails() {
    if (genderTEC.value.text.isEmpty) {
      genderError.value = 'لطفا یک مورد را انتخاب کنید.';
    }
    if (cooperationTypeTEC.value.text.isEmpty) {
      cooperationTypeError.value = 'لطفا یک مورد را انتخاب کنید.';
    }
    if (workTimeTEC.value.text.isEmpty) {
      workTimeError.value = 'لطفا یک مورد را انتخاب کنید.';
    }
    if (payMethodTEC.value.text.isEmpty) {
      payMethodError.value = 'لطفا یک مورد را انتخاب کنید.';
    }
    if (skillTEC.value.text.isEmpty) {
      skillError.value = 'لطفا عنوان تخصص مورد نیاز خود را وارد کنید.';
    }
    if (priceTEC.value.text.isEmpty) {
      priceError.value =
          'لطفا مبلغ پیشنهادی خود را وارد کنید و یا گذینه قیمت توافقی را انتخاب کنید.';
    }
    if (genderError.isEmpty &&
        cooperationTypeError.isEmpty &&
        workTimeError.isEmpty &&
        payMethodError.isEmpty &&
        skillError.isEmpty &&
        priceError.isEmpty) {
      requestController.activeStep.value++;
    }
  }
}
