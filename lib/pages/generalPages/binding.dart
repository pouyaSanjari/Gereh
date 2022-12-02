import 'package:get/get.dart';
import 'package:gereh/components/filterPage/controller/filter_controller.dart';

class StoreBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FilterController());
  }
}
