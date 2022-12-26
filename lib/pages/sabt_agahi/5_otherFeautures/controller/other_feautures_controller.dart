import 'package:fluttertoast/fluttertoast.dart';
import 'package:gereh/constants/my_strings.dart';
import 'package:gereh/pages/sabt_agahi/mainPage/controller/request_controller.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class OtherFeauturesController extends GetxController {
  final mainController = Get.put(RequestController());

  String apiKey =
      'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6ImYwYjNkZmEzYmU0MTEyOGEzZGNlNDVkOWQ1OTU0MmU5NmVmYjZhMjMwZWM5MjUzNzRiZGZiNGY1MWIzNmM4ZTI2NTBkZWQ5ZWUxMmU3MjM0In0.eyJhdWQiOiIxODc5NSIsImp0aSI6ImYwYjNkZmEzYmU0MTEyOGEzZGNlNDVkOWQ1OTU0MmU5NmVmYjZhMjMwZWM5MjUzNzRiZGZiNGY1MWIzNmM4ZTI2NTBkZWQ5ZWUxMmU3MjM0IiwiaWF0IjoxNjU4MjU4NTQ5LCJuYmYiOjE2NTgyNTg1NDksImV4cCI6MTY2MDg1MDU0OSwic3ViIjoiIiwic2NvcGVzIjpbImJhc2ljIl19.Kd5dqFBrzvJmtkVL-LqRsDE3tHw4SSFGxc_dFs9v_4DRRkfaiKxcgSj6iRGjWtQcJTF7kikj6RS9NNI4MV5xBbqSjSiblKWfRXTqtAtoE9a_FJO7yt_DmcSpuUf99bbwSs99UPmOX945iMEFVbJSS-KyHfcQ8Q_G3XwymmD4hjxGvEsV32KzyeXUuUswzL9RwUFjtAn-ix-9-9DSRuSAEFk9MN2FP8_o3YvJ2m-7xJwFYy6nfn-K5_EncWpyJfbFWzkge5VS7XP1Mrnn8Jui9EgcSJsEzQjDt4jHN5_ZIVW63_Mq2kD3VlVrgqM97BrJlTaDQcICxaqt55O5eu9X9A';
  RxString address = 'یک نقطه روی نقشه انتخاب کنید.'.obs;

  RxDouble initialLat = 35.7324556.obs;
  RxDouble initialLon = 51.4229012.obs;
  RxDouble selectedLat = 0.0.obs;
  RxDouble selectedLon = 0.0.obs;

  RxBool locationBool = false.obs;
  RxBool resumeBool = false.obs;

  void validateOtherFuturesPage() {
    if (selectedLat.value == 0 && locationBool.value) {
      Fluttertoast.showToast(msg: 'یک نقطه روی نقشه انتخاب کنید.');
      return;
    }
    mainController.activeStep.value++;
  }

  getAddressUsingLatLon(double lat, double lon) async {
    var url = Uri.parse('https://map.ir/fast-reverse?lat=$lat&lon=$lon');
    var response =
        await http.get(url, headers: {'x-api-key': MyStrings.apiKey});
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
