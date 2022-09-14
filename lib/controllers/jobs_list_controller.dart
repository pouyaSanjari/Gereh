import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sarkargar/constants/colors.dart';
import 'package:sarkargar/services/uiDesign.dart';

import '../pages/jobsList/filter_screen.dart';
import '../components/select.city.dart';

class JobsListController extends GetxController {
  final box = GetStorage();
  RxList jobsList = [].obs;
  RxList searchedList = [].obs;

  RxList searches = [].obs;
  RxList jobsImages = [].obs;
  RxList<String> citiesList = <String>[].obs;
  RxList<String> provienceList = <String>[].obs;
  RxBool cityNamesEnabled = false.obs;
  RxString city = ''.obs;
  RxString provience = ''.obs;
  RxString searchText = ''.obs;

  RxMap<String, Widget> chips = <String, Widget>{}.obs;

  final uiDesign = UiDesign();
// یک چیپ به نام شهر انتخاب شده کاربر می سازه هنگام لود صفحه
  void initialChip() {
    chips.addAll({
      'city': InkWell(
        onTap: () => Get.to(
          () => const SelectCity(
            isFirstTime: false,
          ),
        )?.then((value) {
          if (value != null) {
            box.write('city', value);
            city.value = value;
          }
        }),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Chip(
              label: Obx(
                () => Text(
                  city.value,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              avatar: const Icon(
                Iconsax.location5,
                size: 20,
                color: Colors.white,
              ),
              backgroundColor: MyColors.red),
        ),
      )
    });
  }

// موقع سرچ کردن یک چیپ میسازه و در صورتی که یک سرچ از قبل وجود داشته باشه اونو پاک میکنه
// و یکی دیگه میسازه
  void addSearchFilterChip(
      {required String chipText, VoidCallback? onDeleted}) {
    searchText.value = chipText;
    if (searchedList.isEmpty) {
      Fluttertoast.showToast(msg: 'موردی یافت نشد.');
      chips.removeWhere((key, value) => key == 'search');
      return;
    }
    if (chipText.isEmpty) {
      chips.removeWhere((key, value) => key == 'search');
      return;
    }
    if (chips.containsKey('search')) {
      chips.removeWhere((key, value) => key == 'search');
      chips.addAll(
        {
          'search': Obx(
            () => Chip(
              label: Text(
                searchText.value,
                style: const TextStyle(color: Colors.white),
              ),
              avatar: const Icon(
                Iconsax.search_normal,
                size: 20,
                color: Colors.white,
              ),
              backgroundColor: MyColors.red,
              deleteIcon: const Icon(Icons.close_rounded, color: Colors.white),
              onDeleted: onDeleted,
            ),
          )
        },
      );
      return;
    } else {
      chips.addAll(
        {
          'search': Obx(
            () => Chip(
              label: Text(
                searchText.value,
                style: const TextStyle(color: Colors.white),
              ),
              avatar: const Icon(
                Iconsax.search_normal,
                size: 20,
                color: Colors.white,
              ),
              backgroundColor: MyColors.red,
              deleteIcon: const Icon(Icons.close_rounded, color: Colors.white),
              onDeleted: onDeleted,
            ),
          )
        },
      );
    }
  }

// به ازای هرکدام از مقادیر لیست جستجو یک جستجو در لیست مشاغل انجام میده
  void searchMethod() async {
    if (searches.isNotEmpty) {
      for (var element in searches) {
        searchedList.value = jobsList.where((p0) {
          var elementAsString = p0.toString();
          return elementAsString.contains(element);
        }).toList();
      }
    } else {
      searchedList.clear();
    }
  }

// به صفحه فیلتر ها میره و پس از بازگشت مقدار دریافتی رو به لیست جستجو اضافه میکنه
// همچنین یک چیپ به لیست چسپ ها اضافه میکنه
  void getFilters() async {
    await Get.to(() => const FilterScreen())?.then((value) {
      if (value != null && value.toString().trim() != '') {
        searches.add(value);
        searchMethod();
        if (searchedList.isEmpty) {
          Fluttertoast.showToast(msg: 'موردی یافت نشد.');
          chips.removeWhere((key, value) => key == 'filter');
          return;
        }
        chips.addAll({
          'filter': Chip(
            label: Text(
              value,
              style: const TextStyle(color: Colors.white),
            ),
            avatar: const Icon(
              Iconsax.filter5,
              size: 20,
              color: Colors.white,
            ),
            backgroundColor: MyColors.red,
            deleteIcon: const Icon(Icons.close_rounded, color: Colors.white),
            onDeleted: () {
              chips.removeWhere((key, value) => key == 'filter');
              searches.removeWhere((element) => element == value);
              searchMethod();
            },
          ),
        });
      }
    });
  }

//
  void initialData() async {
    cityNamesEnabled.value = box.read('cityNamesEnabled') ?? false;
    city.value = box.read('city') ?? '';
    provience.value = box.read('provience') ?? '';
  }

  @override
  void onInit() {
    city.value = box.read('city');
    initialChip();
    initialData();
    super.onInit();
  }
}
