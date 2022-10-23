import 'package:get/get.dart';

import 'request_controller.dart';

class PaidFuturesController {
  final controller = Get.put(RequestController());

  void callState() {
    controller.phoneBool.value = !controller.phoneBool.value;
    if (controller.phoneBool.value == false &&
        controller.smsBool.value == false &&
        controller.chatBool.value == false) {
      controller.smsBool.value = true;
    }
  }

  void smsState() {
    controller.smsBool.value = !controller.smsBool.value;
    if (controller.phoneBool.value == false &&
        controller.phoneBool.value == false &&
        controller.chatBool.value == false) {
      controller.phoneBool.value = true;
    }
  }

  void chatState() {
    controller.chatBool.value = !controller.chatBool.value;

    if (controller.chatBool.value == false &&
        controller.phoneBool.value == false &&
        controller.smsBool.value == false) {
      controller.phoneBool.value = true;
    }
  }
}
