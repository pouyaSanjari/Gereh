import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sarkargar/services/ui_design.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  List<String> list = [
    'حریم خصوصی',
    'پرسش های متداول',
    'شرایط استفاده',
    'تماس با ما',
    'گزارش خطا',
    'امتیاز به اپلیکیشن سرکارگر'
  ];
  List<IconData> icon = [
    Icons.privacy_tip_outlined,
    Icons.question_answer_outlined,
    Icons.verified_user_outlined,
    Icons.call,
    Icons.bug_report_outlined,
    Icons.star_border
  ];
  int signInType = 0;
  UiDesign uiDesign = UiDesign();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: uiDesign.cTheme(),
      debugShowCheckedModeBanner: false,
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            leading: InkWell(
              onTap: () => Get.back(),
              child: const Icon(
                Iconsax.arrow_right_3,
                color: Colors.black87,
              ),
            ),
            elevation: 0,
            automaticallyImplyLeading: true,
            title: const Text('تنظیمات'),
          ),
          body: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        style: ListTileStyle.drawer,
                        title: Text(
                          list[index],
                          style: const TextStyle(fontSize: 18),
                        ),
                        leading: Icon(
                          icon[index],
                          color: Colors.black,
                        ),
                        trailing: const Icon(
                          Iconsax.arrow_left_1,
                        ),
                        onTap: () {},
                      );
                    },
                  ),
                ),
                const Text('تغیر نوع حساب'),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //صاحبان کسب و کار
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('کارفرما '),
                        Radio(
                            activeColor: Colors.blueGrey,
                            value: 1,
                            groupValue: signInType,
                            onChanged: (value) {
                              setState(() {
                                signInType = 1;
                              });
                            }),
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('کارجو'),
                        Radio(
                            activeColor: Colors.blueGrey,
                            value: 2,
                            groupValue: signInType,
                            onChanged: (value) {
                              setState(() {
                                signInType = 2;
                              });
                            }),
                      ],
                    ),
                  ],
                ),
                RawMaterialButton(
                  elevation: 0,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  fillColor: Colors.redAccent,
                  child: const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      'خروج از حساب کاربری',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  onPressed: () {},
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
