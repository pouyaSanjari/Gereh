import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax/iconsax.dart';
import 'package:gereh/components/buttons/rounded.button.dart';
import 'package:gereh/services/ui_design.dart';
import 'package:gereh/services/database.dart';
import 'settings.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final box = GetStorage();

  String name = '';
  String family = '';
  String number = '';
  int userId = 0;

  AppDataBase dataBase = AppDataBase();
  int signInType = 1;
  UiDesign uiDesign = UiDesign();

  bool isConnected = true;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: UiDesign.cTheme(),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: buildAppBar(
          context: context,
          title: 'وارد شده به عنوان: کارجو',
        ),
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                //نام و نام خانوادگی
                Center(
                  child: Text(
                    '$name $family',
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                //شماره تلفن
                Center(
                  child: Text(
                    '$number ',
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                const Divider(),
                //دکمه های گرد
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MyRoundedButton(
                        icon: const FaIcon(
                          Iconsax.edit,
                          color: Colors.white,
                        ),
                        backColor: Colors.redAccent,
                        text: 'ویرایش مشخصات',
                        onClick: () {
                          // TODO: رفتن به صفحه ویرایش مشخصات
                        }),
                    MyRoundedButton(
                        icon: const Icon(
                          Iconsax.headphone5,
                          color: Colors.white,
                        ),
                        backColor: Colors.blue,
                        text: 'تماس با ما',
                        onClick: () {})
                  ],
                ),
                ListTile(
                  onTap: () {},
                  leading: const Icon(Iconsax.save_2),
                  title: const Text(
                    'موارد ذخیره شده',
                    style: TextStyle(fontSize: 16),
                  ),
                  subtitle: const Text('نشان ها و یادداشت ها',
                      style: TextStyle(fontSize: 11)),
                  trailing: const Icon(Iconsax.arrow_left_1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar({required BuildContext context, required String title}) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(fontSize: 18),
      ),
      leading: IconButton(
          onPressed: () {},
          icon: const FaIcon(
            Iconsax.alarm,
            color: Colors.black,
            size: 21,
          )),
      actions: [
        IconButton(
            onPressed: () {
              Get.to(() => const Settings());
            },
            icon: const Icon(
              Iconsax.setting,
              color: Colors.black,
            ))
      ],
      elevation: 0,
    );
  }

  getUserDetails() async {
    await checkConnection();
    isConnected == false
        ? Fluttertoast.showToast(msg: 'اتصال اینترنت را بررسی نمایید')
        : null;
    userId = box.read('id') ?? 0;
    var response = await dataBase.getUserDetailsById(userId: userId);
    setState(() {
      name = response[0]['name'];
      family = response[0]['family'];
      number = response[0]['number'];
    });
  }

  checkConnection() async {
    isConnected = await dataBase.checkUserConnection();
  }

  @override
  void initState() {
    getUserDetails();
    super.initState();
  }
}
