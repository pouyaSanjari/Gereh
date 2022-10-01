import 'package:get/get.dart';

class MapTestController extends GetxController {
  RxMap<String, String> listitem = <String, String>{}.obs;
  RxBool showContainer = false.obs;
  RxDouble opacity = 1.0.obs;
  RxDouble initialZoom = 5.1.obs;
}
