import 'package:get/get.dart';
import 'package:gereh/controllers/filter_controller.dart';

class StoreBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FilterController());
  }
}
