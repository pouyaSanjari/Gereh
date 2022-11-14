import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax/iconsax.dart';
import 'package:gereh/components/other/animated_widget.dart';
import 'package:gereh/components/switchs/switch.dart';
import 'package:gereh/components/textFields/text.field.dart';
import 'package:gereh/controllers/p3.paid.futures.controller.dart';
import 'package:gereh/services/database.dart';
import 'package:gereh/services/ui_design.dart';
import '../../constants/colors.dart';
import '../../controllers/request_controller.dart';

class ContactInfo extends GetView<RequestController> {
  ContactInfo({Key? key}) : super(key: key);

  final box = GetStorage();

  final database = AppDataBase();

  @override
  Widget build(BuildContext context) {
    final pageController = PaidFuturesController();
    return SingleChildScrollView(
      child: Column(
        children: [
          const Align(
            alignment: Alignment.center,
            child: Text(
              'راه های ارتباطی',
              style: TextStyle(
                fontFamily: 'titr',
                fontSize: 30,
              ),
            ),
          ),
          const Divider(
              height: 30, color: Colors.black, indent: 50, endIndent: 50),
          // call
          Obx(
            () => listTiles(
              onTap: () => pageController.callState(),
              leading: Iconsax.call,
              iconColor:
                  controller.phoneBool.value ? Colors.green : Colors.black,
              title: 'تماس',
              swich: MySwitch(
                val: controller.phoneBool.value,
                onChange: (value) {
                  pageController.callState();
                },
              ),
              sub: 'کاربران می توانند مستقیما با شما تماس بگیرند.',
            ),
          ),
          Obx(
            () => MyAnimatedWidget(
              state: controller.phoneBool.value,
              child: MyTextField(
                error: controller.phoneError.value.isEmpty
                    ? null
                    : controller.phoneError.value,
                onChange: (value) {
                  if (value.length != 11) {
                    controller.phoneError.value =
                        'لطفا شماره تلفن صحیح وارد نمایید';
                  } else {
                    controller.phoneError.value = '';
                  }
                },
                textAlign: TextAlign.center,
                hint: '...0921',
                textInputType: TextInputType.phone,
                labeltext: 'شماره تلفن همراه یا ثابت',
                control: controller.phoneTEC.value,
              ),
            ),
          ),
          // sms
          Obx(
            () => listTiles(
              onTap: () => pageController.smsState(),
              leading: Iconsax.sms,
              iconColor:
                  controller.smsBool.value ? Colors.pink : MyColors.black,
              title: 'پیامک',
              sub: 'کاربران می توانند به خط شما پیامک ارسال کنند.',
              swich: MySwitch(
                val: controller.smsBool.value,
                onChange: (value) {
                  pageController.smsState();
                },
              ),
            ),
          ),
          Obx(
            () => MyAnimatedWidget(
                state: controller.smsBool.value,
                child: MyTextField(
                  textAlign: TextAlign.center,
                  hint: '...0921',
                  textInputType: TextInputType.phone,
                  error: controller.smsError.isEmpty
                      ? null
                      : controller.smsError.value,
                  onChange: (value) {
                    if (value.length != 11) {
                      controller.smsError.value =
                          'لطفا شماره تلفن صحیح وارد نمایید';
                    } else {
                      controller.smsError.value = '';
                    }
                  },
                  labeltext: 'شماره تلفن همراه یا ثابت',
                  control: controller.smsTEC.value,
                )),
          ),
          // chat
          Obx(
            () => listTiles(
              onTap: () => pageController.chatState(),
              leading: Iconsax.sms_tracking,
              iconColor: controller.chatBool.value ? Colors.blue : Colors.black,
              title: 'چت',
              sub:
                  'کاربران می توانند از طریق چت درون برنامه ای با شما ارتباط برقرار کنند.',
              swich: MySwitch(
                val: controller.chatBool.value,
                onChange: (value) {
                  pageController.chatState();
                },
              ),
            ),
          ),
          // email
          Obx(
            () => listTiles(
                onTap: () =>
                    controller.emailBool.value = !controller.emailBool.value,
                leading: Icons.email,
                iconColor:
                    controller.emailBool.value ? MyColors.red : MyColors.black,
                title: 'ایمیل',
                swich: MySwitch(
                  val: controller.emailBool.value,
                  onChange: (value) {
                    controller.emailBool.value = value;
                  },
                ),
                sub: 'ایمیل شما برای کاربران نمایش داده خواهد شد.'),
          ),
          Obx(
            () => MyAnimatedWidget(
                state: controller.emailBool.value,
                child: MyTextField(
                  error: controller.emailError.isEmpty
                      ? null
                      : controller.emailError.value,
                  onChange: (value) {
                    if (!value.isEmail) {
                      controller.emailError.value =
                          'لطفا یک ایمیل معتبر وارد کنید.';
                    } else {
                      controller.emailError.value = '';
                    }
                  },
                  textAlign: TextAlign.left,
                  hint: 'example@gmail.com',
                  textInputType: TextInputType.emailAddress,
                  labeltext: 'آدرس ایمیل',
                  control: controller.emailTEC.value,
                )),
          ),
          // website
          Obx(
            () => listTiles(
              onTap: () =>
                  controller.websiteBool.value = !controller.websiteBool.value,
              leading: Iconsax.global,
              iconColor: controller.websiteBool.value
                  ? MyColors.orange
                  : MyColors.black,
              title: 'وبسایت',
              swich: MySwitch(
                val: controller.websiteBool.value,
                onChange: (value) {
                  controller.websiteBool.value = value;
                },
              ),
              sub: 'هدایت کاربران به صفحه سایت مورد نظر شما',
            ),
          ),
          Obx(
            () => MyAnimatedWidget(
                state: controller.websiteBool.value,
                child: MyTextField(
                  error: controller.websiteError.isEmpty
                      ? null
                      : controller.websiteError.value,
                  onChange: (value) {
                    if (!value.isURL) {
                      controller.websiteError.value = 'آدرس معتبر وارد کنید';
                    } else {
                      controller.websiteError.value = '';
                    }
                  },
                  textAlign: TextAlign.left,
                  hint: 'example.com',
                  textInputType: TextInputType.emailAddress,
                  labeltext: 'آدرس صفحه وب مورد نظر',
                  control: controller.websiteTEC.value,
                )),
          ),
          // whatsApp
          Obx(
            () => listTiles(
                onTap: () => controller.whatsappBool.value =
                    !controller.whatsappBool.value,
                leading: FontAwesomeIcons.whatsapp,
                iconColor: controller.whatsappBool.value
                    ? Colors.green
                    : MyColors.black,
                title: 'واتس اپ',
                swich: MySwitch(
                  val: controller.whatsappBool.value,
                  onChange: (value) {
                    controller.whatsappBool.value = value;
                  },
                ),
                sub: 'هدایت کاربران به صفحه گفتگو در واتس اپ'),
          ),
          Obx(
            () => MyAnimatedWidget(
              state: controller.whatsappBool.value,
              child: MyTextField(
                error: controller.whatsappError.isEmpty
                    ? null
                    : controller.whatsappError.value,
                onChange: (value) {
                  if (value.length != 11) {
                    controller.whatsappError.value =
                        'لطفا شماره تلفن صحیح وارد نمایید';
                  } else {
                    controller.whatsappError.value = '';
                  }
                },
                textAlign: TextAlign.left,
                hint: '09210000000',
                textInputType: TextInputType.phone,
                labeltext: 'شماره تلفن اکانت واتس اپ',
                control: controller.whatsappTEC.value,
              ),
            ),
          ),
          // telegram
          Obx(
            () => listTiles(
                onTap: () => controller.telegramBool.value =
                    !controller.telegramBool.value,
                leading: FontAwesomeIcons.telegram,
                iconColor: controller.telegramBool.value
                    ? MyColors.blue
                    : MyColors.black,
                title: 'تلگرام',
                swich: MySwitch(
                  val: controller.telegramBool.value,
                  onChange: (value) {
                    controller.telegramBool.value = value;
                  },
                ),
                sub: 'هدایت کاربران به صفحه گفتگو در تلگرام'),
          ),
          Obx(
            () => MyAnimatedWidget(
              state: controller.telegramBool.value,
              child: MyTextField(
                error: controller.telegramError.value.isEmpty
                    ? null
                    : controller.telegramError.value,
                textAlign: TextAlign.left,
                onChange: (value) {
                  controller.telegramError.value = '';
                },
                hint: 'مثال: gereh',
                textInputType: TextInputType.emailAddress,
                labeltext: 'آی دی اکانت تلگرام بدون @',
                control: controller.telegramIdTEC.value,
              ),
            ),
          ),
          // instagram
          Obx(
            () => listTiles(
                onTap: () => controller.instagramBool.value =
                    !controller.instagramBool.value,
                leading: Iconsax.instagram,
                iconColor: controller.instagramBool.value
                    ? MyColors.red
                    : Colors.black,
                title: 'اینستاگرام',
                swich: MySwitch(
                  val: controller.instagramBool.value,
                  onChange: (value) {
                    controller.instagramBool.value = value;
                  },
                ),
                sub:
                    'کابران به راحتی می توانند صفحه اینستاگرام شما را مشاهده کنند.'),
          ),
          Obx(
            () => MyAnimatedWidget(
                state: controller.instagramBool.value,
                child: MyTextField(
                  textAlign: TextAlign.end,
                  length: 30,
                  hint: 'بدون @',
                  error: controller.instagramError.value == ''
                      ? null
                      : controller.instagramError.value,
                  labeltext: 'آیدی اینستاگرام خود را وارد کنید.',
                  control: controller.instagramIdTEC.value,
                  onChange: (value) {
                    if (controller.instagramIdTEC.value.text
                        .contains(RegExp(r'[@#$&-+()?!;:*+%-]'))) {
                      controller.instagramError.value = 'کاراکتر غیر مجاز!';
                    } else {
                      controller.instagramError.value = '';
                    }
                  },
                )),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  ListTile listTiles(
      {required void Function()? onTap,
      required IconData leading,
      required Color iconColor,
      required String title,
      required Widget swich,
      required String sub}) {
    return ListTile(
      onTap: onTap,
      minLeadingWidth: 5,
      leading: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Icon(leading, color: iconColor),
      ),
      title: Row(
        children: [
          Expanded(child: Text(title, style: UiDesign.titleTextStyle())),
          swich,
          const SizedBox(width: 10),
        ],
      ),
      subtitle: Text(sub, style: UiDesign.descriptionsTextStyle()),
      contentPadding: EdgeInsets.zero,
    );
  }
}
