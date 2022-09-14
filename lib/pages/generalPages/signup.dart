import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:sarkargar/components/button.dart';
import 'package:sarkargar/components/text.field.dart';
import 'package:sarkargar/pages/generalPages/main_page.dart';
import 'package:sarkargar/services/database.dart';
import 'package:sarkargar/components/select.city.dart';
import '../../services/uiDesign.dart';

class SignUp extends StatefulWidget {
  final String number;

  const SignUp({Key? key, required this.number}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

var messageController = TextEditingController();

class _SignUpState extends State<SignUp> {
  final box = GetStorage();
  TextEditingController nameController = TextEditingController();
  TextEditingController familyController = TextEditingController();
  late String name;
  late String family;
  String res = '';
  bool activeConnection = false;
  int userId = 0;
  UiDesign uiDesign = UiDesign();
  AppDataBase dataBase = AppDataBase();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: MaterialApp(
        theme: uiDesign.cTheme(),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: const Text('ثبت نام'),
            elevation: 0,
          ),
          body: SafeArea(
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Lottie.asset(
                        'assets/lottie/signUp.json',
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: MyTextField(
                            maxLine: 1,
                            control: nameController,
                            labeltext: 'نام',
                            icon: const Icon(Icons.account_circle),
                            hint: 'نام',
                            textInputType: TextInputType.name,
                            onChange: (value) {
                              name = value;
                            }),
                      ),
                      const SizedBox(height: 15),
                      MyTextField(
                          maxLine: 1,
                          control: familyController,
                          labeltext: 'نام خانوادگی',
                          icon: const Icon(CupertinoIcons.person_2_fill),
                          hint: 'نام خانوادگی ',
                          textInputType: TextInputType.name,
                          onChange: (value) {
                            family = value;
                          }),
                      //دکمه ثبت نام
                      MyButton(
                        text: 'ثبت نام',
                        onClick: () {
                          //اگه اسم رو وارد نکرده باشه
                          if (nameController.text.isEmpty) {
                            Fluttertoast.showToast(
                                msg: 'لطفا نام خود را وارد کنید.');
                          }
                          //اگه فامیلی رو وارد  نکرده باشه
                          if (familyController.text.isEmpty) {
                            Fluttertoast.showToast(
                                msg: 'لطفا نام خانوادگی خود را وارد کنید.');
                          } else {
                            //وقتی که اطلاعاتش رو کامل کرد
                            sendIntoDB(name, family, widget.number).then(
                              (value) async {
                                //اگه ارسال اطلاعات به دیتابیس موفقیت آمیز بود
                                if (res.contains('successfully')) {
                                  Fluttertoast.showToast(
                                      msg: 'ثبت نام با موفقیت انجام شد');
                                  //بعد از اینکه ثبت نام انجام شد ای دیش رو میگیره و داخل شیرید پرفریس ها ذخیره میکنه
                                  getUserId(number: widget.number);
                                  box.write('isLoggedIn', true);
                                  // حالا وقتی ثبتنام کرد چک میکنه ببینه شهر رو قبلا انتخاب کرده یا نه اگه نه میفرسته به صفحه انتخاب شهر
                                  if (box.read('selectedCityFilter') == null ||
                                      box.read('selectedCityFilter') == '') {
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const SelectCity(
                                                  isFirstTime: true),
                                        ),
                                        (route) => false);
                                  } else {
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const MainPage()),
                                        (route) => false);
                                  }
                                } else {
                                  //این برای وقتیه که موفق نشده اطلاعات رو برای دیتابیس بفرسته
                                  Fluttertoast.showToast(
                                      msg: 'خطایی رخ داده است');
                                }
                              },
                            );
                          }
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future sendIntoDB(String name, String family, String number) async {
    var url = Uri.parse('https://sarkargar.ir/phpfiles/userDB/signup.php');
    var response = await http
        .post(url, body: {'name': name, 'family': family, 'number': number});
    setState(() {
      res = response.body;
    });
    return response;
  }

  Future checkUserConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          activeConnection = true;
        });
      }
    } on SocketException catch (_) {
      setState(() {
        activeConnection = false;
      });
    }
  }

  getUserId({required String number}) async {
    checkUserConnection();
    if (activeConnection) {
      return Fluttertoast.showToast(msg: 'لطفا اتصال اینترنت خود را چک کنید.');
    } else {
      var response = await dataBase.getUserIdByNumber(number: number);
      box.write('id', int.parse(response[0]['id']));
      setState(() {});
      return response;
    }
  }
}
