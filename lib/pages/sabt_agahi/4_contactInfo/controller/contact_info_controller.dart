import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gereh/pages/sabt_agahi/mainPage/controller/request_controller.dart';
import 'package:get/get.dart';

class ContactInfoController extends GetxController {
  final mainController = Get.put(RequestController());

  Rx<TextEditingController> phoneTEC = TextEditingController().obs;
  Rx<TextEditingController> smsTEC = TextEditingController().obs;
  Rx<TextEditingController> emailTEC = TextEditingController().obs;
  Rx<TextEditingController> websiteTEC = TextEditingController().obs;
  Rx<TextEditingController> whatsappTEC = TextEditingController().obs;
  Rx<TextEditingController> telegramIdTEC = TextEditingController().obs;
  Rx<TextEditingController> instagramIdTEC = TextEditingController().obs;

  RxString phoneError = ''.obs;
  RxString smsError = ''.obs;
  RxString emailError = ''.obs;
  RxString websiteError = ''.obs;
  RxString whatsappError = ''.obs;
  RxString telegramError = ''.obs;
  RxString instagramError = ''.obs;

  RxBool phoneBool = false.obs;
  RxBool smsBool = false.obs;
  RxBool chatBool = true.obs;
  RxBool emailBool = false.obs;
  RxBool websiteBool = false.obs;
  RxBool whatsappBool = false.obs;
  RxBool telegramBool = false.obs;
  RxBool instagramBool = false.obs;
  RxBool imageBool = false.obs;

  void validateContactInfos() {
    if (phoneBool.value && phoneTEC.value.text.length != 11) {
      phoneError.value = 'لطفا یک شماره تلفن معتبر وارد کنید.';
    }
    if (smsBool.value && smsTEC.value.text.length != 11) {
      smsError.value = 'لطفا یک شماره تلفن معتبر وارد کنید.';
    }
    if (emailBool.value && !emailTEC.value.text.isEmail) {
      emailError.value = 'لطفا یک ایمیل معتبر وارد کنید.';
    }
    if (websiteBool.value && !websiteTEC.value.text.isURL) {
      websiteError.value = 'لطفا یک آدرس معتبر وارد کنید.';
    }
    if (whatsappBool.value && whatsappTEC.value.text.length != 11) {
      whatsappError.value = 'لطفا یک شماره تلفن معتبر وارد کنید.';
    }
    if (telegramBool.value && telegramIdTEC.value.text.isEmpty) {
      telegramError.value =
          'لطفا یک آی دی تلگرام وارد کنید یا این گذینه را غیرفعال کنید.';
    }
    if (instagramBool.value && instagramIdTEC.value.text.isEmpty) {
      instagramError.value =
          'لطفا یک آی دی اینستاگرام وارد کنید یا این گذینه را غیرفعال کنید.';
    }

    if (phoneBool.value && phoneError.isNotEmpty) {
      Fluttertoast.showToast(msg: 'لطفا ارور های موجود را برطرف نمایید.');
      return;
    }
    if (smsBool.value && smsError.isNotEmpty) {
      Fluttertoast.showToast(msg: 'لطفا ارور های موجود را برطرف نمایید.');
      return;
    }
    if (emailBool.value && emailError.isNotEmpty) {
      Fluttertoast.showToast(msg: 'لطفا ارور های موجود را برطرف نمایید.');
      return;
    }
    if (websiteBool.value && websiteError.isNotEmpty) {
      Fluttertoast.showToast(msg: 'لطفا ارور های موجود را برطرف نمایید.');
      return;
    }
    if (whatsappBool.value && whatsappError.isNotEmpty) {
      Fluttertoast.showToast(msg: 'لطفا ارور های موجود را برطرف نمایید.');
      return;
    }
    if (telegramBool.value && telegramError.isNotEmpty) {
      Fluttertoast.showToast(msg: 'لطفا ارور های موجود را برطرف نمایید.');
      return;
    }
    if (instagramBool.value && instagramError.isNotEmpty) {
      Fluttertoast.showToast(msg: 'لطفا ارور های موجود را برطرف نمایید.');
      return;
    }

    mainController.activeStep.value++;
  }

  void callState() {
    phoneBool.value = !phoneBool.value;
    if (phoneBool.value == false &&
        smsBool.value == false &&
        chatBool.value == false) {
      smsBool.value = true;
    }
  }

  void smsState() {
    smsBool.value = !smsBool.value;
    if (phoneBool.value == false &&
        phoneBool.value == false &&
        chatBool.value == false) {
      phoneBool.value = true;
    }
  }

  void chatState() {
    chatBool.value = !chatBool.value;

    if (chatBool.value == false &&
        phoneBool.value == false &&
        smsBool.value == false) {
      phoneBool.value = true;
    }
  }
}
