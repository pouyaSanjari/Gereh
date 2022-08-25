import 'package:get/get.dart';

class JobDetailsController extends GetxController {
  String apiKey =
      'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6ImYwYjNkZmEzYmU0MTEyOGEzZGNlNDVkOWQ1OTU0MmU5NmVmYjZhMjMwZWM5MjUzNzRiZGZiNGY1MWIzNmM4ZTI2NTBkZWQ5ZWUxMmU3MjM0In0.eyJhdWQiOiIxODc5NSIsImp0aSI6ImYwYjNkZmEzYmU0MTEyOGEzZGNlNDVkOWQ1OTU0MmU5NmVmYjZhMjMwZWM5MjUzNzRiZGZiNGY1MWIzNmM4ZTI2NTBkZWQ5ZWUxMmU3MjM0IiwiaWF0IjoxNjU4MjU4NTQ5LCJuYmYiOjE2NTgyNTg1NDksImV4cCI6MTY2MDg1MDU0OSwic3ViIjoiIiwic2NvcGVzIjpbImJhc2ljIl19.Kd5dqFBrzvJmtkVL-LqRsDE3tHw4SSFGxc_dFs9v_4DRRkfaiKxcgSj6iRGjWtQcJTF7kikj6RS9NNI4MV5xBbqSjSiblKWfRXTqtAtoE9a_FJO7yt_DmcSpuUf99bbwSs99UPmOX945iMEFVbJSS-KyHfcQ8Q_G3XwymmD4hjxGvEsV32KzyeXUuUswzL9RwUFjtAn-ix-9-9DSRuSAEFk9MN2FP8_o3YvJ2m-7xJwFYy6nfn-K5_EncWpyJfbFWzkge5VS7XP1Mrnn8Jui9EgcSJsEzQjDt4jHN5_ZIVW63_Mq2kD3VlVrgqM97BrJlTaDQcICxaqt55O5eu9X9A';
  RxString advertizer = ''.obs;
  RxString adType = ''.obs;
  RxString hiringtype = ''.obs;
  RxString title = ''.obs;
  RxString category = ''.obs;
  RxString city = ''.obs;
  RxString address = ''.obs;
  RxString locationlat = ''.obs;
  RxString locationlon = ''.obs;
  RxString men = ''.obs;
  RxString women = ''.obs;
  RxString mprice = ''.obs;
  RxString wprice = ''.obs;
  RxString descs = ''.obs;
  RxString time = ''.obs;

  RxBool phonebool = false.obs;
  RxBool chatbool = false.obs;
  RxBool photobool = false.obs;
  RxBool locationbool = false.obs;
  RxBool instagrambool = false.obs;
}
