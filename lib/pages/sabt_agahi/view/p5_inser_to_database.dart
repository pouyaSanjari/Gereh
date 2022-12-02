import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:gereh/components/other/my_row2.dart';
import 'package:gereh/constants/my_colors.dart';
import 'package:gereh/constants/my_strings.dart';
import 'package:gereh/pages/sabt_agahi/controller/request_controller.dart';

class InsertToDataBase extends GetView<RequestController> {
  const InsertToDataBase({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isHirng = controller.adType.value == 0 ? true : false;

    var title = controller.titleTEC.value.text;
    var desc = controller.descriptionsTEC.value.text;
    var category = controller.categoryTEC.value.text;
    var city = controller.cityTEC.value.text;
    var gender = controller.genderTEC.value.text;
    var cooperation = controller.cooperationTypeTEC.value.text;
    var workTime = controller.workTimeTEC.value.text;
    var payMthod = controller.payMethodTEC.value.text;
    var skill = controller.skillTEC.value.text;
    var price = controller.priceTEC.value.text;
    bool phone = controller.phoneBool.value;
    var sms = controller.smsBool.value;
    var chat = controller.chatBool.value;
    var email = controller.emailBool.value;
    var website = controller.websiteBool.value;
    var whatsapp = controller.whatsappBool.value;
    var telegram = controller.telegramBool.value;
    var instagram = controller.instagramBool.value;
    var location = controller.locationBool.value;
    var resume = controller.resumeBool.value;
    var address = controller.address.value;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Text(
              'تایید نهایی',
              style: TextStyle(fontSize: 30, fontFamily: 'titr'),
            ),
          ),
          const Divider(
              height: 30, color: Colors.black, indent: 50, endIndent: 50),
          Row(
            children: const [
              Icon(Iconsax.wifi),
              SizedBox(width: 5),
              Text('راه های ارتباطی',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ],
          ),
          Center(
            child: Wrap(
              alignment: WrapAlignment.center,
              children: [
                iconWithText(
                  icon: Iconsax.call,
                  color: MyColors.green,
                  visibility: phone,
                  text: 'تماس',
                ),
                iconWithText(
                  visibility: sms,
                  color: MyColors.blueGrey,
                  icon: Iconsax.sms,
                  text: 'پیامک',
                ),
                iconWithText(
                  visibility: chat,
                  color: MyColors.orange,
                  icon: Iconsax.sms_tracking,
                  text: 'چت',
                ),
                iconWithText(
                  visibility: email,
                  icon: Icons.email,
                  color: MyColors.red,
                  text: 'ایمیل',
                ),
                iconWithText(
                  visibility: website,
                  icon: Iconsax.global,
                  color: Colors.teal,
                  text: 'وبسایت',
                ),
                iconWithText(
                  color: Colors.green,
                  visibility: whatsapp,
                  icon: FontAwesomeIcons.whatsapp,
                  text: 'واتس اپ',
                ),
                iconWithText(
                  color: Colors.blue,
                  visibility: telegram,
                  icon: FontAwesomeIcons.telegram,
                  text: 'تلگرام',
                ),
                iconWithText(
                  color: MyColors.red,
                  visibility: instagram,
                  icon: Iconsax.instagram,
                  text: 'اینستاگرام',
                ),
              ],
            ),
          ),
          div(),
          MyRow2(
            icon: Iconsax.subtitle,
            title: 'عنوان:',
            value: title,
          ),
          div(visible: isHirng),
          MyRow2(
              visible: isHirng,
              icon: gender == 'آقا' ? Iconsax.man : Iconsax.woman,
              title: 'جنسیت:',
              value: gender),
          div(visible: isHirng),
          MyRow2(
            visible: isHirng,
            icon: Iconsax.home_wifi,
            title: 'نوع همکاری:',
            value: cooperation,
          ),
          div(visible: isHirng),
          MyRow2(
            visible: isHirng,
            icon: Iconsax.wallet_1,
            title: 'شیوه پرداخت:',
            value: payMthod,
          ),
          div(visible: isHirng),
          MyRow2(
            visible: isHirng,
            icon: Iconsax.dollar_circle,
            title: 'مبلغ پرداختی:',
            value: price == 'توافقی' ? 'توافقی' : MyStrings.digi(price),
          ),
          div(visible: isHirng),
          MyRow2(
            visible: isHirng,
            icon: Iconsax.clock,
            title: 'ساعات کاری:',
            value: workTime,
          ),
          div(visible: isHirng),
          MyRow2(
            visible: isHirng,
            icon: Iconsax.briefcase,
            title: 'تخصص:',
            value: skill,
          ),
          div(),
          MyRow2(
              icon: Iconsax.location,
              title: 'قابلیت نمایش روی نقشه:',
              value: location ? 'دارد' : 'ندارد'),
          div(visible: isHirng),
          MyRow2(
            visible: isHirng,
            icon: Iconsax.paperclip,
            title: 'قابلیت دریافت رزومه:',
            value: resume ? 'دارد' : 'ندارد',
          ),
          div(),
          MyRow2(
            icon: Iconsax.category_2,
            title: 'دسته بندی:',
            value: category,
          ),
          div(),
          MyRow2(
            icon: Iconsax.building_3,
            title: 'شهر:',
            value: city,
          ),
          div(visible: controller.locationBool.value),
          MyRow2(
              icon: Iconsax.map,
              title: 'آدرس:',
              value: address,
              visible: controller.locationBool.value),
          div(),
          const Center(
            child: Text(
              'توضیحات',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            ),
          ),
          const SizedBox(height: 10),
          Text(desc)
        ],
      ),
    );
  }

  Visibility iconWithText(
      {required bool visibility,
      required IconData icon,
      Color? color,
      required String text}) {
    return Visibility(
      visible: visibility,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Icon(
              icon,
              size: 30,
              color: color,
            ),
            const SizedBox(height: 10),
            Text(text)
          ],
        ),
      ),
    );
  }

  div({bool? visible}) {
    return Visibility(
        visible: visible ?? true, child: const Divider(height: 30));
  }
}
