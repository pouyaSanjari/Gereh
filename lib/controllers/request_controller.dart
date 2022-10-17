import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sarkargar/services/database.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class RequestController extends GetxController {
  final box = GetStorage();
  final database = AppDataBase();

  @override
  void onReady() {
    AppDataBase().uploadedImages();
    cityTEC.value.text = box.read('city');
    super.onReady();
  }

  //main request page
  RxInt activeStep = 0.obs;

  //title page
//###################################################
  // text inputs
  Rx<TextEditingController> titleTEC = TextEditingController().obs;
  Rx<TextEditingController> descriptionsTEC = TextEditingController().obs;
  Rx<TextEditingController> categoryTEC = TextEditingController().obs;
  Rx<TextEditingController> cityTEC = TextEditingController().obs;

  RxString titleimage = ''.obs;
  RxInt adType = 2.obs;

  // used in select city page
  RxString city = ''.obs;
  RxList cities = [].obs;

  // used in select category
  RxList jobGroups = [].obs;
  RxList jobs = [].obs;
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

  //errors
  RxString titleError = ''.obs;
  RxString categoryError = ''.obs;
  RxString cityError = ''.obs;
  RxString descriptionsError = ''.obs;

  // validates all inputs when going to next page
  void validateTitlePage() {
    if (adType.value == 2) {
      Fluttertoast.showToast(msg: 'لطفا نوع آگهی را انتخاب کنید.');
    }
    if (titleTEC.value.text.trim().isEmpty) {
      titleError.value = 'وارد کردن عنوان برای آگهی الزامی است.';
    }
    if (descriptionsTEC.value.text.trim().isEmpty) {
      descriptionsError.value = 'لطفا توضیحات آگهی را وارد کنید.';
    }
    if (categoryTEC.value.text.trim().isEmpty) {
      categoryError.value = 'لطفا یک دسته بندی برای آگهی خود انتخاب کنید.';
    }
    if (cityTEC.value.text.trim().isEmpty) {
      cityError.value = 'لطفا شهر محل آگهی خود را انتخاب کنید.';
    }
    if (cityError.isEmpty &&
        categoryError.isEmpty &&
        descriptionsError.isEmpty &&
        titleError.isEmpty &&
        adType.value != 2) {
      if (adType.value == 0) {
        activeStep.value++;
      } else {
        activeStep.value = 2;
      }
    }
  }

//workers count page
//###################################################
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
      activeStep.value++;
    }
  }

//contact info page
//###################################################

  RxList images = [].obs;

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
  RxBool locationBool = false.obs;
  RxBool resumeBool = false.obs;

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

    activeStep.value++;
  }

  // other futures page
  String apiKey =
      'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6ImYwYjNkZmEzYmU0MTEyOGEzZGNlNDVkOWQ1OTU0MmU5NmVmYjZhMjMwZWM5MjUzNzRiZGZiNGY1MWIzNmM4ZTI2NTBkZWQ5ZWUxMmU3MjM0In0.eyJhdWQiOiIxODc5NSIsImp0aSI6ImYwYjNkZmEzYmU0MTEyOGEzZGNlNDVkOWQ1OTU0MmU5NmVmYjZhMjMwZWM5MjUzNzRiZGZiNGY1MWIzNmM4ZTI2NTBkZWQ5ZWUxMmU3MjM0IiwiaWF0IjoxNjU4MjU4NTQ5LCJuYmYiOjE2NTgyNTg1NDksImV4cCI6MTY2MDg1MDU0OSwic3ViIjoiIiwic2NvcGVzIjpbImJhc2ljIl19.Kd5dqFBrzvJmtkVL-LqRsDE3tHw4SSFGxc_dFs9v_4DRRkfaiKxcgSj6iRGjWtQcJTF7kikj6RS9NNI4MV5xBbqSjSiblKWfRXTqtAtoE9a_FJO7yt_DmcSpuUf99bbwSs99UPmOX945iMEFVbJSS-KyHfcQ8Q_G3XwymmD4hjxGvEsV32KzyeXUuUswzL9RwUFjtAn-ix-9-9DSRuSAEFk9MN2FP8_o3YvJ2m-7xJwFYy6nfn-K5_EncWpyJfbFWzkge5VS7XP1Mrnn8Jui9EgcSJsEzQjDt4jHN5_ZIVW63_Mq2kD3VlVrgqM97BrJlTaDQcICxaqt55O5eu9X9A';
  RxString address = 'یک نقطه روی نقشه انتخاب کنید.'.obs;

  RxDouble initialLat = 35.7324556.obs;
  RxDouble initialLon = 51.4229012.obs;
  RxDouble selectedLat = 0.0.obs;
  RxDouble selectedLon = 0.0.obs;

  void validateOtherFuturesPage() {
    if (selectedLat.value == 0 && locationBool.value) {
      Fluttertoast.showToast(msg: 'یک نقطه روی نقشه انتخاب کنید.');
      return;
    }
    activeStep.value++;
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
