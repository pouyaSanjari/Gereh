import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:sarkargar/models/adv_model_test.dart';

final box = GetStorage();

class JobsListController extends GetxController {
  RxList<AdvModelTest> jobTestModel = <AdvModelTest>[].obs;
  RxBool loading = false.obs;
  RxBool hasError = false.obs;
  RxString city = ''.obs;
  RxString query =
      "SELECT * FROM `requests` WHERE `city` = '${box.read('city')}'".obs;

  void initialData() async {
    city.value = box.read('city') ?? '';
  }

  ///گرفتن تمام تبیلغلات
  getAds({required String query}) async {
    hasError.value = false;
    loading.value = true;
    var url = Uri.parse('https://sarkargar.ir/phpfiles/jobreqsDB/ads.php');
    try {
      var response = await http.post(url, body: {'query': query});
      List jsonResponse = convert.jsonDecode(response.body);
      Uri imagesUrl = Uri.parse(
          'https://sarkargar.ir/phpfiles/userimages/getallimages.php');
      var imagesResponse = await http.get(imagesUrl);

      List imageToJson = convert.jsonDecode(imagesResponse.body);

      // List<AdvModelTest> jobTestModel = [];
      jobTestModel.value = [];

      for (var element in jsonResponse) {
        jobTestModel.add(AdvModelTest.fromJson(
            element,
            imageToJson
                .where((image) => image['adId'] == element['id'])
                .toList()));
      }
      jobTestModel.value = jobTestModel.reversed.toList();
      loading.value = false;
      // return jobTestModel;
    } catch (e) {
      loading.value = false;
      hasError.value = true;
      e.printError;
    }
  }

  @override
  void onInit() {
    initialData();
    getAds(query: query.value);
    super.onInit();
  }
}
