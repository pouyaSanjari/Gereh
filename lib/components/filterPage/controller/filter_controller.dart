import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

final box = GetStorage();

class FilterController extends GetxController {
  Rx<TextEditingController> categoryTEC = TextEditingController().obs;
  Rx<TextEditingController> titleTEC = TextEditingController().obs;

  RxMap<String, String> searchMap = <String, String>{}.obs;
  RxMap<String, String> searchChips = <String, String>{}.obs;
  RxInt minPrice = 0.obs;
  RxInt maxPrice = 0.obs;
  RxList<double> sliderValues = [0.0, 1.0].obs;
  RxInt sliderValuesMultiplyer = 50000000.obs;

  RxBool allAdvTypes = true.obs;
  RxBool hireAdvType = false.obs;
  RxBool businessPromotionAdvType = false.obs;

  void selectAllAdvTypes() {
    allAdvTypes.value = true;
    hireAdvType.value = false;
    businessPromotionAdvType.value = false;
  }

  void selectHireAdvType() {
    hireAdvType.value = true;
    allAdvTypes.value = false;
    businessPromotionAdvType.value = false;
  }

  void selectBusinessPromotionAdvtype() {
    businessPromotionAdvType.value = true;
    hireAdvType.value = false;
    allAdvTypes.value = false;
    sliderValues.value = [0.0, 1.0];
    selectAllCooperationTypes();
    selectAllPayMethods();
  }

  // cooperation chips boolean
  RxBool allCooperationTypes = true.obs;
  // دورکاری
  RxBool teleCooperationType = false.obs;
  // حضوری
  RxBool inPlaceCooperationtype = false.obs;

  void selectAllCooperationTypes() {
    allCooperationTypes.value = true;
    inPlaceCooperationtype.value = false;
    teleCooperationType.value = false;
  }

  void selectInPlaceCooperationType() {
    inPlaceCooperationtype.value = true;
    teleCooperationType.value = false;
    allCooperationTypes.value = false;
  }

  void selectTeleCooperationType() {
    teleCooperationType.value = true;
    allCooperationTypes.value = false;
    inPlaceCooperationtype.value = false;
  }

  // pay method chips booleans
  RxBool allMethods = true.obs;
  RxBool daily = false.obs;
  RxBool monthly = false.obs;
  void selectAllPayMethods() {
    sliderValuesMultiplyer.value = 50000000;
    allMethods.value = true;
    daily.value = false;
    monthly.value = false;
  }

  void selectDailyPayMethod() {
    sliderValuesMultiplyer.value = 1000000;

    daily.value = true;
    monthly.value = false;
    allMethods.value = false;
  }

  void selectMonthlyPayMethod() {
    sliderValuesMultiplyer.value = 50000000;
    monthly.value = true;
    daily.value = false;
    allMethods.value = false;
  }

  RxString searchQuery = ''.obs;
  String defaultSearchQuery =
      "SELECT * FROM `requests` WHERE `city` = '${box.read('city')}'";

  void addFilter(
      {required bool check, required String key, required String value}) {
    if (check) {
      if (searchMap.containsKey(key)) {
        searchMap.update(key, (value) => value);
      } else {
        searchMap.addAll({key: value});
      }
    }
  }

  void checkAllFilters() {
    searchMap.clear();
    // اگر جستجو عناوین خالی نباشد
    if (titleTEC.value.text.isNotEmpty) {
      searchMap.addAll({'title': titleTEC.value.text});
      searchChips.addAll({'title': 'عنوان: ${titleTEC.value.text}'});
    } else {
      deleteTitleFilter();
    }
    // اگر دسته بندی خالی نباشد
    if (categoryTEC.value.text.isNotEmpty) {
      searchMap.addAll({'category': categoryTEC.value.text});
      searchChips.addAll({'category': categoryTEC.value.text});
    } else {
      deleteCategoryFilter();
    }
    // اگر گذینه همه انواع آگهی فعال باشد
    if (allAdvTypes.value) {
      deleteAdTypefilter();
    }
    // اگر گذینه استخدام نیرو فعال باشد
    addFilter(check: hireAdvType.value, key: 'adtype', value: '0');
    if (hireAdvType.value) {
      searchChips.addAll({'adtype': 'استخدام'});
    }

    // اگر گذینه تبلیغ کسب و کار فعال باشد
    addFilter(check: businessPromotionAdvType.value, key: 'adtype', value: '1');
    if (businessPromotionAdvType.value) {
      searchChips.addAll({'adtype': 'تبلیغات'});
    }

    // اگر گذینه همه انواع همکاری فعال باشد
    if (allCooperationTypes.value) {
      deleteCooperationType();
    }
    // اگر گذینه دورکاری فعال باشد
    addFilter(
        check: teleCooperationType.value, key: 'workType', value: 'دورکاری');
    if (teleCooperationType.value) {
      searchChips.addAll({'workType': 'دورکاری'});
    }

    // اگر گذینه نوع همکاری حضوری فعال باشد
    addFilter(
        check: inPlaceCooperationtype.value, key: 'workType', value: 'حضوری');
    if (inPlaceCooperationtype.value) {
      searchChips.addAll({'workType': 'حضوری'});
    }

    // اگر گذینه همه متد های پرداخت فعال باشد
    if (allMethods.value) {
      deletePayMethod();
    }

    // اگر گذینه پرداخت روزانه فعال باشد
    addFilter(check: daily.value, key: 'payMethod', value: 'روزانه');
    if (daily.value) {
      searchChips.addAll({'payMethod': 'روزمزد'});
    }

    addFilter(check: monthly.value, key: 'payMethod', value: 'ماهیانه');
    if (monthly.value) {
      searchChips.addAll({'payMethod': 'ماهیانه'});
    }
  }

  void searchMethod() {
    searchQuery.value = defaultSearchQuery;
    searchMap.forEach((key, value) {
      searchQuery.value = "${searchQuery.value} AND `$key` LIKE '%$value%'";
    });
    // اگر قیمت تعیین کرده باشه باید نوع آگهی استخدام باشه
    if (!listEquals(sliderValues, [0.0, 1.0])) {
      selectHireAdvType();
      checkAllFilters();
      var formatter = NumberFormat();
      searchQuery.value =
          "${searchQuery.value} AND `price` BETWEEN ${(sliderValues[0] * sliderValuesMultiplyer.value).round()} AND"
          " ${(sliderValues[1] * sliderValuesMultiplyer.value).round()}";
      searchChips.addAll({
        'price':
            'از ${(formatter.format(sliderValues[0] * sliderValuesMultiplyer.value))} تومان تا ${formatter.format(sliderValues[1] * sliderValuesMultiplyer.value)} تومان'
      });
    }
    // print(searchQuery);
  }

  void deleteTitleFilter() {
    searchMap.removeWhere((key, value) => key == 'title');
    searchChips.removeWhere((key, value) => key == 'title');

    titleTEC.value.text = '';
  }

  void deleteCategoryFilter() {
    searchMap.removeWhere((key, value) => key == 'category');
    searchChips.removeWhere((key, value) => key == 'category');
    categoryTEC.value.text = '';
  }

  void deleteAdTypefilter() {
    searchMap.removeWhere((key, value) => key == 'adtype');
    searchChips.removeWhere((key, value) => key == 'adtype');
    selectAllAdvTypes();
  }

  void deleteCooperationType() {
    searchMap.removeWhere((key, value) => key == 'workType');
    searchChips.removeWhere((key, value) => key == 'workType');
    selectAllCooperationTypes();
  }

  void deletePayMethod() {
    searchMap.removeWhere((key, value) => key == 'payMethod');
    searchChips.removeWhere((key, value) => key == 'payMethod');
    selectAllPayMethods();
  }

  void deletePriceFilter() {
    searchMap.removeWhere((key, value) => key == 'price');
    searchChips.removeWhere((key, value) => key == 'price');
    sliderValues.value = [0.0, 1.0];
  }

  void deleteAllFilters() {
    deleteTitleFilter();
    deleteCategoryFilter();
    deleteAdTypefilter();
    deleteCooperationType();
    deletePayMethod();
    deletePriceFilter();
  }
}
