import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gereh/pages/jobsList/view/job_details.dart';
import 'package:gereh/pages/profile_page/controller/profile_page_controller.dart';
import 'package:gereh/pages/profile_page/controller/saved_ads_page_controller.dart';
import 'package:gereh/pages/profile_page/view/my_ads.dart';
import 'package:gereh/pages/profile_page/view/saved_ads_page.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:gereh/components/buttons/my_rounded_button.dart';
import 'package:gereh/services/ui_design.dart';
import 'settings.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({Key? key}) : super(key: key);

  final controller = Get.put(ProfilePageController());
  final uiDesign = UiDesign();

  final bool isConnected = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: UiDesign.cTheme(),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: _buildAppBar(
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
                Obx(
                  () => Center(
                    child: Text(
                      controller.nameAndFamily.value,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                //شماره تلفن
                Obx(
                  () => Center(
                    child: Text(
                      controller.number.value,
                      style: const TextStyle(fontSize: 12),
                    ),
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
                        onClick: () {}),
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
                _CostumeListTile(
                  icon: Iconsax.save_2,
                  title: 'موارد ذخیره شده',
                  sub: 'نشانها و یادداشت ها',
                  onTap: () {
                    final svdpc = Get.put(SavedAdsPageController());
                    svdpc.readData();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SavedAdsPage(),
                        ));
                  },
                ),
                _CostumeListTile(
                  title: 'آگهی های من',
                  sub: 'آگهی های شما در اپلیکیشن گره',
                  icon: Iconsax.briefcase,
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyAds(),
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar({required BuildContext context, required String title}) {
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
}

class _CostumeListTile extends StatelessWidget {
  const _CostumeListTile({
    Key? key,
    required this.title,
    required this.sub,
    required this.icon,
    required this.onTap,
  }) : super(key: key);
  final String title;
  final String sub;
  final void Function() onTap;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16),
      ),
      subtitle: Text(sub, style: const TextStyle(fontSize: 11)),
      trailing: const Icon(Iconsax.arrow_left_1),
    );
  }
}
