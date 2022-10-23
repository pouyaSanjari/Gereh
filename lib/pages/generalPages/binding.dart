import 'package:get/get.dart';
import 'package:sarkargar/controllers/filter_controller.dart';

class StoreBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FilterController());
  }
}
