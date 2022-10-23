import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:sarkargar/models/adv_model_test.dart';

class JobsListController extends GetxController {
  final box = GetStorage();
  RxString city = ''.obs;
  Rx<TextEditingController> searchTEC = TextEditingController().obs;

  void initialData() async {
    city.value = box.read('city') ?? '';
  }

  ///گرفتن تمام تبیلغلات
  getAds({required String query}) async {
    var url = Uri.parse('https://sarkargar.ir/phpfiles/jobreqsDB/ads.php');
    try {
      var response = await http.post(url, body: {'query': query});
      List jsonResponse = convert.jsonDecode(response.body);
      Uri imagesUrl = Uri.parse(
          'https://sarkargar.ir/phpfiles/userimages/getallimages.php');
      var imagesResponse = await http.get(imagesUrl);

      List imageToJson = convert.jsonDecode(imagesResponse.body);

      List<AdvModelTest> jobTestModel = [];

      for (var element in jsonResponse) {
        jobTestModel.add(AdvModelTest.fromJson(
            element,
            imageToJson
                .where((image) => image['adId'] == element['id'])
                .toList()));
      }
      return jobTestModel;
    } catch (e) {
      e.printError;
    }
  }

  @override
  void onInit() {
    initialData();
    super.onInit();
  }
}
