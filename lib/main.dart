import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sarkargar/components/pages/select.city.dart';
import 'package:sarkargar/pages/generalPages/binding.dart';
import 'package:sarkargar/services/ui_design.dart';
import 'package:sarkargar/pages/generalPages/login.dart';
import 'package:sarkargar/pages/generalPages/main_page.dart';

void main() async {
  await GetStorage.init();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final box = GetStorage();
  UiDesign uiDesign = UiDesign();
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: StoreBinding(),
      debugShowCheckedModeBanner: false,
      theme: UiDesign.cTheme(),
      home: buildPage(),
      // initialRoute: '/first',
    );
  }

  StatefulWidget buildPage() {
    if (box.read('id') == null || box.read('id') == '') {
      return const LoginPage();
    } else {
      if (box.read('city') == null || box.read('city') == '') {
        return const SelectCity(isFirstTime: true);
      } else {
        return const MainPage();
      }
    }
  }

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemNavigationBarColor: Color(0xfff2f5fc),
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark));
    super.initState();
  }
}
