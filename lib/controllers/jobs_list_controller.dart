import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sarkargar/services/uiDesign.dart';

import '../services/select_city.dart';

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

  void initialChip() {
    chips.addAll({
      'city': InkWell(
        onTap: () => Get.to(() => const SelectCity())!.then((value) {
          box.write('city', value);
          return city.value = value;
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
              backgroundColor: uiDesign.mainColor()),
        ),
      )
    });
  }

  void addSearchFilterChip(
      {required String chipText, VoidCallback? onDeleted}) {
    searchText.value = chipText;
    if (chipText.isEmpty) {
      chips.removeWhere((key, value) => key == 'search');
      return;
    }
    if (chips.containsKey('search')) {
      chips.removeWhere((key, value) => key == 'search');
      chips.addAll({
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
            backgroundColor: uiDesign.mainColor(),
            deleteIcon: const Icon(Icons.close_rounded, color: Colors.white),
            onDeleted: onDeleted,
          ),
        )
      });
      return;
    } else {
      chips.addAll({
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
            backgroundColor: uiDesign.mainColor(),
            deleteIcon: const Icon(Icons.close_rounded, color: Colors.white),
            onDeleted: onDeleted,
          ),
        )
      });
    }
  }

  void initialData() async {
    // final box = GetStorage();
    cityNamesEnabled.value = box.read('cityNamesEnabled') ?? false;
    city.value = box.read('city') ?? '';
    provience.value = box.read('provience') ?? '';
  }

  @override
  void onInit() {
    initialChip();
    initialData();
    super.onInit();
  }
}
