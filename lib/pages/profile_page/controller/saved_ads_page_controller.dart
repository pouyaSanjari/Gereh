import 'package:gereh/models/adv_model.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SavedAdsPageController extends GetxController {
  @override
  void onInit() {
    readData();
    super.onInit();
  }

  RxList<AdvModel> model = <AdvModel>[].obs;
  RxBool loading = true.obs;
  RxBool empty = true.obs;

  Future<void> readData() async {
    loading.value = true;
    Box hiveBox = await Hive.openBox('bookmarks');
    List<AdvModel> savedJobsList = [];
    for (var i = 0; i < hiveBox.length; i++) {
      savedJobsList.add(hiveBox.getAt(i));
    }
    model.value = savedJobsList.reversed.toList();
    loading.value = false;
    savedJobsList.isEmpty ? empty.value = true : empty.value = false;
  }
}
