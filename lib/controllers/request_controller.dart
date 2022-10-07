import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:sarkargar/services/database.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class RequestController extends GetxController {
  @override
  // TODO: implement initialized
  bool get initialized {
    AppDataBase().uploadedImages();
    return super.initialized;
  }

  //main request page
  RxInt activeStep = 0.obs;

  //title page
//###################################################

  RxString titleimage = ''.obs;

  RxInt adType = 2.obs;
  RxString title = ''.obs;
  RxString category = ''.obs;
  RxString city = ''.obs;
  RxString desc = ''.obs;

  RxList cities = [].obs;
  RxList jobGroups = [].obs;
  RxList jobs = [].obs;

  //errors
  RxString titleError = ''.obs;
  RxString categoryError = ''.obs;
  RxString cityError = ''.obs;
  RxString descriptionsError = ''.obs;

//workers count page
//###################################################
  Rx<TextEditingController> selectGenderTEC = TextEditingController().obs;
  Rx<TextEditingController> selectWorkTimeTEC = TextEditingController().obs;
  Rx<TextEditingController> selectPayMethodTEC = TextEditingController().obs;
  Rx<TextEditingController> skillTEC = TextEditingController().obs;
  Rx<TextEditingController> priceTEC = TextEditingController().obs;
  Rx<TextEditingController> selectCollaborationTypeTEC =
      TextEditingController().obs;
  RxBool ghimatTavafoghiBL = false.obs;
  RxString ghimatPishnahadi = ''.obs;
  RxString ghimatPishnahadiError = ''.obs;

//paid features page
//###################################################

  String apiKey =
      'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6ImYwYjNkZmEzYmU0MTEyOGEzZGNlNDVkOWQ1OTU0MmU5NmVmYjZhMjMwZWM5MjUzNzRiZGZiNGY1MWIzNmM4ZTI2NTBkZWQ5ZWUxMmU3MjM0In0.eyJhdWQiOiIxODc5NSIsImp0aSI6ImYwYjNkZmEzYmU0MTEyOGEzZGNlNDVkOWQ1OTU0MmU5NmVmYjZhMjMwZWM5MjUzNzRiZGZiNGY1MWIzNmM4ZTI2NTBkZWQ5ZWUxMmU3MjM0IiwiaWF0IjoxNjU4MjU4NTQ5LCJuYmYiOjE2NTgyNTg1NDksImV4cCI6MTY2MDg1MDU0OSwic3ViIjoiIiwic2NvcGVzIjpbImJhc2ljIl19.Kd5dqFBrzvJmtkVL-LqRsDE3tHw4SSFGxc_dFs9v_4DRRkfaiKxcgSj6iRGjWtQcJTF7kikj6RS9NNI4MV5xBbqSjSiblKWfRXTqtAtoE9a_FJO7yt_DmcSpuUf99bbwSs99UPmOX945iMEFVbJSS-KyHfcQ8Q_G3XwymmD4hjxGvEsV32KzyeXUuUswzL9RwUFjtAn-ix-9-9DSRuSAEFk9MN2FP8_o3YvJ2m-7xJwFYy6nfn-K5_EncWpyJfbFWzkge5VS7XP1Mrnn8Jui9EgcSJsEzQjDt4jHN5_ZIVW63_Mq2kD3VlVrgqM97BrJlTaDQcICxaqt55O5eu9X9A';
  RxString address = 'یک نقطه روی نقشه انتخاب کنید.'.obs;

  RxDouble initialLat = 35.7324556.obs;
  RxDouble initialLon = 51.4229012.obs;
  RxDouble selectedLon = 0.0.obs;
  RxDouble selectedLat = 0.0.obs;

  RxString selectedInstagramIdError = ''.obs;

  RxBool locationSelectionBool = false.obs;
  RxBool imageSelectionBool = false.obs;
  RxBool instagramIdSelectionBool = false.obs;
  RxList images = [].obs;

  Rx<TextEditingController> phoneNumberTEC = TextEditingController().obs;
  Rx<TextEditingController> smsNumberTEC = TextEditingController().obs;
  Rx<TextEditingController> emailAddressTEC = TextEditingController().obs;
  Rx<TextEditingController> websiteTEC = TextEditingController().obs;
  Rx<TextEditingController> whatsappNumberTEC = TextEditingController().obs;
  Rx<TextEditingController> telegramIdTEC = TextEditingController().obs;
  Rx<TextEditingController> instagramIdTEC = TextEditingController().obs;
  RxBool phoneBool = false.obs;
  RxBool smsBool = false.obs;
  RxBool emailBool = false.obs;
  RxBool websiteBool = false.obs;
  RxBool whatsappBool = false.obs;
  RxBool telegramBool = false.obs;
  RxBool chatBool = true.obs;

  AppDataBase database = AppDataBase();

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

  getAddressUsingLatLon(double lat, double lon) async {
    var url = Uri.parse('https://map.ir/fast-reverse?lat=$lat&lon=$lon');
    var response = await http.get(url, headers: {'x-api-key': apiKey});
    var decodedResponse =
        convert.jsonDecode(convert.utf8.decode(response.bodyBytes));

    if (decodedResponse['address_compact'].toString().length < 8) {
      // هفت کاراکتر اول که کلمه ایران و ویرگول هست رو حذف کردم
      address.value = decodedResponse['address'].toString().substring(7);
    } else {
      address.value = decodedResponse['address_compact'].toString();
    }
  }
}
