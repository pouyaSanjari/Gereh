import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class JobsListController extends GetxController {
  RxList jobsList = [].obs;
  RxList jobsImages = [].obs;
  RxList<String> citiesList = <String>[].obs;
  RxList<String> provienceList = <String>[].obs;
  RxBool cityNamesEnabled = false.obs;
  RxString city = ''.obs;
  RxString provience = ''.obs;

  void initialData() async {
    final box = GetStorage();
    cityNamesEnabled.value = box.read('cityNamesEnabled') ?? false;
    city.value = box.read('city') ?? '';
    provience.value = box.read('provience') ?? '';
  }

  @override
  void onInit() {
    initialData();
    super.onInit();
  }
}
