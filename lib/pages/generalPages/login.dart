import 'dart:async';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sarkargar/components/button.dart';
import 'package:sarkargar/components/select.city.dart';
import 'package:sarkargar/components/text.field.dart';
import 'package:sarkargar/controllers/login.controller.dart';
import 'package:sarkargar/services/uiDesign.dart';
import 'package:sarkargar/pages/generalPages/main_page.dart';
import 'package:sarkargar/pages/generalPages/signup.dart';
import 'package:sarkargar/services/database.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  AppDataBase dataBase = AppDataBase();
  final controller = Get.put(LoginController());
  UiDesign uiDesign = UiDesign();
  final box = GetStorage();

  late String number;
  late int phoneNumber;
  static const maxseconds = 120;
  var msgController = TextEditingController();
  bool activeConnection = false;
  int seconds = maxseconds;
  Timer? timer;
  bool _isButtonDisabled = false;
  int sentcode = Random().nextInt(9000) + 1000;
  bool isLoggedIn = false;
  int userId = 0;
  bool isConnected = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: uiDesign.cTheme(),
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: const Text('شماره تلفن خود را وارد کنید'),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Center(
                      //   child: Image.asset(
                      //       width: 300,
                      //       height: 300,
                      //       'images/sarkargar'
                      //       '_icon.png'),
                      // ),
                      const Text(
                        ' شماره تلفن همراه خود را وارد کنید.',
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      /// فیلد شماره تلفن
                      buildCTextField(),

                      /// شمارنده معکوس
                      // Center(child: countdown()),
                    ],
                  ),
                ),

                /// دکمه دریافت کد
                buildCRawMaterialButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// متد تغییر محتوای تکست فیلد بر حسب شرایط
  MyTextField buildCTextField() {
    if (seconds == 120) {
      return MyTextField(
          maxLine: 1,
          hint: 'با 09 شروع کنید',
          icon: const Icon(Icons.phone),
          control: msgController,
          labeltext: 'شماره تلفن',
          length: 11,
          textInputType: TextInputType.phone,
          onChange: (value) {
            phoneNumber = int.parse(value);
          });
    } else {
      return MyTextField(
          maxLine: 1,
          labeltext: 'کد پیامک شده را وارد کنید',
          icon: const Icon(Icons.sms),
          control: msgController,
          hint: 'کد چهار رقمی را وارد کنید',
          length: 4,
          textInputType: TextInputType.phone,
          onChange: (value) {
            phoneNumber = int.parse(value);
          });
    }
  }

  /// متد خالی کردن تکست ویو زمانی که تایمر غیرفعال است.
  Text countdown() {
    if (seconds == 120) {
      return const Text('');
    } else {
      return Text(
        ' اگر کد را دریافت نکردید$seconds ثانیه دیگر مجددا تلاش کنید.',
      );
    }
  }

  /// کلید دریافت و ثبت کد فعال سازی که تغییر وضعیت می دهد.
  Widget buildCRawMaterialButton() {
    if (_isButtonDisabled == false) {
      return MyButton(
        text: 'دریافت کد ',
        onClick: () async {
          getUserId(number: msgController.text);
          if (msgController.text.length != 11) {
            Fluttertoast.showToast(
              msg: 'لطفا شماره تلفن معتبر وارد کنید',
            );
          } else {
            await checkUserConnection();
            if (isConnected == false) {
              Fluttertoast.showToast(
                  msg: 'لطفا اتصال اینترنت خود را بررسی کنید.');
            } else {
              startTimer();
              number = msgController.text;
              getUserId(number: msgController.text);
              sendCode(msgController.text, sentcode);
              msgController.clear();
            }
          }
        },
      );
    } else if (msgController.text == '') {
      return MyButton(text: ' $seconds  لطفا منتظر بمانید . . .    ');
    } else {
      return MyButton(
        text: 'ورود',
        onClick: () {
          ///در صورت صحیح بودن یا نبودن کد وارد شده
          if (msgController.text == sentcode.toString()) {
            if (userId == 0) {
              Fluttertoast.showToast(msg: 'ابتدا باید ثبت نام کنید');
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignUp(number: number),
                  ),
                  (route) => false);
            } else {
              box.write('id', userId);
              Fluttertoast.showToast(msg: 'با موفقیت وارد شدید');
              if (box.read('city') == null || box.read('city') == '') {
                Get.off(SelectCity(isFirstTime: true));
              } else {
                Get.off(const MainPage());
              }
            }
          } else {
            Fluttertoast.showToast(msg: 'کد وارد شده صحیح نمی باشد');
          }
        },
      );
    }
  }

  /// تایمر معکوس استفاده شده در هنگام انتظار برای دریافت پیامک.
  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        seconds--;
        _isButtonDisabled = true;
        if (seconds == 0) {
          timer.cancel();
          _isButtonDisabled = false;
          seconds = maxseconds;
        }
      });
    });
  }

  /// متد ارسال کد فعال سازی اپلیکیشن.
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

  /// متد گرفتن ای دی شخص لاگین شده.
  getUserId({required String number}) async {
    await checkUserConnection();
    if (isConnected == false) {
      return Fluttertoast.showToast(msg: 'لطفا اتصال اینترنت خود را چک کنید.');
    } else {
      var response = await dataBase.getUserIdByNumber(number: number);
      userId = int.parse(response[0]['id']);
      setState(() {});
      return response;
    }
  }

  checkUserConnection() async {
    isConnected = await dataBase.checkUserConnection();
  }

  setUserId() async {
    setState(() {
      if (box.read('id') != null) {
        userId = box.read('id');
      }
    });
  }

  @override
  // ignore: must_call_super
  void initState() {
    setUserId();
    checkUserConnection();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}

// 6063 7310 5951 3003
