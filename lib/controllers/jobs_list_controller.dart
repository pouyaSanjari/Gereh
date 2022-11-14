import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:gereh/models/adv_model.dart';

final box = GetStorage();

class JobsListController extends GetxController {
  RxList<AdvModel> jobsList = <AdvModel>[].obs;
  RxBool loading = false.obs;
  RxBool hasError = false.obs;
  RxString city = ''.obs;
  RxString query =
      "SELECT * FROM `requests` WHERE `city` = '${box.read('city')}'".obs;

  void initialData() async {
    city.value = box.read('city') ?? '';
  }

  ///گرفتن تمام تبیلغلات
  getAds() async {
    hasError.value = false;
    loading.value = true;
    var url = Uri.parse('https://sarkargar.ir/phpfiles/jobreqsDB/ads.php');
    try {
      var response = await http.post(url, body: {'query': query.value});
      print(response.statusCode);
      List jsonResponse = convert.jsonDecode(response.body);
      Uri imagesUrl = Uri.parse(
          'https://sarkargar.ir/phpfiles/userimages/getallimages.php');
      var imagesResponse = await http.get(imagesUrl);

      List imageToJson = convert.jsonDecode(imagesResponse.body);

      // List<AdvModelTest> jobTestModel = [];
      jobsList.value = [];

      for (var element in jsonResponse) {
        jobsList.add(AdvModel.fromJson(
            element,
            imageToJson
                .where((image) => image['adId'] == element['id'])
                .toList()));
      }
      jobsList.value = jobsList.reversed.toList();
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
    getAds();
    super.onInit();
  }
}
