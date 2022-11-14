import 'dart:async';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:gereh/services/database.dart';

enum ButtonStatus { getCode, waiting, done }

class LoginController extends GetxController {
  final database = AppDataBase();
  Timer? timer;
  var status = ButtonStatus.getCode;
  int code = 0;
  int userId = 0;
  int phoneNumber = 0;
  final textEditingController = TextEditingController();

  RxInt countDown = 120.obs;
  RxDouble buttonWidth = 100.0.obs;
  RxString textFieldLable = '6789 345 0912'.obs;
  RxString buttonText = 'دریافت کد'.obs;
  RxBool isButtonEnabled = true.obs;

  Future<void> buttonFunction() async {
    switch (status) {
      case ButtonStatus.getCode:
        // status = ButtonStatus.waiting;
        await getUserId();
        break;
      case ButtonStatus.waiting:

        // print(status.toString());
        // status = ButtonStatus.done;
        break;
      case ButtonStatus.done:

        // print(status.toString());
        // status = ButtonStatus.getCode;
        break;
      default:
    }
  }

  /// متد گرفتن ای دی شخص لاگین شده.
  getUserId() async {
    if (textEditingController.text.length < 11) {
      Fluttertoast.showToast(msg: 'لطفا شماره تلفن معتبر وارد کنید');
      return;
    }
    bool isConnected = await database.checkUserConnection();
    if (isConnected == false) {
      return Fluttertoast.showToast(msg: 'لطفا اتصال اینترنت خود را چک کنید.');
    }
    status = ButtonStatus.waiting;
    textEditingController.text = '';
    textFieldLable.value = 'کد ارسال شده را وارد کنید';
    buttonWidth.value = 170;
    startTimer();

    var response =
        await database.getUserIdByNumber(number: textEditingController.text);
    userId = int.parse(response[0]['id']);
    // box.write('id', userId);
    code = Random().nextInt(9000) + 1000;
    sendCode(textEditingController.text, code);
  }

  void sendCode(number, code) async {
    var dio = Dio();
    await dio.post(
        'https://console.melipayamak.com/api/send/shared/b183b97e15e44d21a384a0d7baba1f14',
        data: {
          "bodyId": 90935,
          "to": number,
          "args": ['$code']
        });
  }

  startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      countDown.value--;
      buttonText.value = '  ${countDown.value}  لطفا منتظر بمانید...   ';
      if (countDown.value == 0) {
        timer.cancel();
        buttonText.value = 'ارسال مجدد';
      }
    });
  }
}
