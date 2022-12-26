import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdFeauturesController extends GetxController {
  final RxList<TextEditingController> sharayetTEC =
      [TextEditingController()].obs;
  final RxList<TextEditingController> mazayaTEC = [TextEditingController()].obs;
  final RxList<FocusNode> sharayetFocus = [FocusNode()].obs;
  final RxList<FocusNode> mazayaFocus = [FocusNode()].obs;

  Rx<TextEditingController> descriptionsTEC = TextEditingController().obs;
  RxString descriptionsError = ''.obs;

  void addSharayetTextField() {
    // اگر یکی از فیلد ها را پر نکرده بود
    if (sharayetTEC.any((element) => element.text.isEmpty)) {
      // بیا چک کن ببین کدوم فیلده
      for (var i = 0; i < sharayetTEC.length; i++) {
        if (sharayetTEC[i].text.isEmpty) {
          // روی همون فیلد فوکس کن
          sharayetFocus[i].requestFocus();
        }
      }
      // در صورتی که هیچ فیلدی خالی نبود و تعداد کمتر از 8 بود یه فیلد جدید اضافه کن
    } else if (sharayetTEC.length < 8) {
      sharayetTEC.add(TextEditingController());
      sharayetFocus.add(FocusNode());
      sharayetFocus.last.requestFocus();
    }
  }

  void addMazayaTextField() {
    // اگر یکی از فیلد ها را پر نکرده بود
    if (mazayaTEC.any((element) => element.text.isEmpty)) {
      // بیا چک کن ببین کدوم فیلده
      for (var i = 0; i < mazayaTEC.length; i++) {
        if (mazayaTEC[i].text.isEmpty) {
          // روی همون فیلد فوکس کن
          mazayaFocus[i].requestFocus();
        }
      }
      // در صورتی که هیچ فیلدی خالی نبود یه فیلد جدید اضافه کن
    } else if (mazayaTEC.length < 8) {
      mazayaTEC.add(TextEditingController());
      mazayaFocus.add(FocusNode());
      mazayaFocus.last.requestFocus();
    }
  }
}
