import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class FilterController extends GetxController {
  RxList<double> ghimat = [0.0, 1.0].obs;
  RxInt adType = 3.obs;
  RxInt hiringType = 3.obs;
  RxInt gender = 3.obs;
  RxInt minPrice = 0.obs;
  RxInt maxPrice = 0.obs;
  final categoryController = TextEditingController().obs;
}
