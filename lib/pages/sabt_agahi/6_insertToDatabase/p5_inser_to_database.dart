import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gereh/pages/sabt_agahi/3_adFeautures/controller/ad_feautures_controller.dart';
import 'package:gereh/pages/sabt_agahi/4_contactInfo/controller/contact_info_controller.dart';
import 'package:gereh/pages/sabt_agahi/1_title/controller/title_controller.dart';
import 'package:gereh/pages/sabt_agahi/2_workerDetails/controller/worker_details_controller.dart';
import 'package:gereh/pages/sabt_agahi/5_otherFeautures/controller/other_feautures_controller.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:gereh/components/other/my_row2.dart';
import 'package:gereh/constants/my_colors.dart';
import 'package:gereh/constants/my_strings.dart';
import 'package:gereh/pages/sabt_agahi/mainPage/controller/request_controller.dart';

class InsertToDataBase extends GetView<RequestController> {
  const InsertToDataBase({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final titleController = Get.put(TitleController());
    final adFeauturesController = Get.put(AdFeauturesController());
    final workerDetailsController = Get.put(WorkerDetailsController());
    final contactInfoController = Get.put(ContactInfoController());
    final otherFeauturesController = Get.put(OtherFeauturesController());

    bool isHirng = titleController.adType.value == 0 ? true : false;

    var title = titleController.titleTEC.value.text;
    var category = titleController.categoryTEC.value.text;
    var city = titleController.cityTEC.value.text;
    var desc = adFeauturesController.descriptionsTEC.value.text;
    var gender = workerDetailsController.genderTEC.value.text;
    var cooperation = workerDetailsController.cooperationTypeTEC.value.text;
    var workTime = workerDetailsController.workTimeTEC.value.text;
    var payMthod = workerDetailsController.payMethodTEC.value.text;
    var skill = workerDetailsController.skillTEC.value.text;
    var price = workerDetailsController.priceTEC.value.text;
    bool phone = contactInfoController.phoneBool.value;
    var sms = contactInfoController.smsBool.value;
    var chat = contactInfoController.chatBool.value;
    var email = contactInfoController.emailBool.value;
    var website = contactInfoController.websiteBool.value;
    var whatsapp = contactInfoController.whatsappBool.value;
    var telegram = contactInfoController.telegramBool.value;
    var instagram = contactInfoController.instagramBool.value;
    var location = otherFeauturesController.locationBool.value;
    var resume = otherFeauturesController.resumeBool.value;
    var address = otherFeauturesController.address.value;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Text(
              '?????????? ??????????',
              style: TextStyle(fontSize: 30, fontFamily: 'titr'),
            ),
          ),
          const Divider(
              height: 30, color: Colors.black, indent: 50, endIndent: 50),
          Row(
            children: const [
              Icon(Iconsax.wifi),
              SizedBox(width: 5),
              Text('?????? ?????? ??????????????',
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
                  text: '????????',
                ),
                iconWithText(
                  visibility: sms,
                  color: MyColors.blueGrey,
                  icon: Iconsax.sms,
                  text: '??????????',
                ),
                iconWithText(
                  visibility: chat,
                  color: MyColors.orange,
                  icon: Iconsax.sms_tracking,
                  text: '????',
                ),
                iconWithText(
                  visibility: email,
                  icon: Icons.email,
                  color: MyColors.red,
                  text: '??????????',
                ),
                iconWithText(
                  visibility: website,
                  icon: Iconsax.global,
                  color: Colors.teal,
                  text: '????????????',
                ),
                iconWithText(
                  color: Colors.green,
                  visibility: whatsapp,
                  icon: FontAwesomeIcons.whatsapp,
                  text: '???????? ????',
                ),
                iconWithText(
                  color: Colors.blue,
                  visibility: telegram,
                  icon: FontAwesomeIcons.telegram,
                  text: '????????????',
                ),
                iconWithText(
                  color: MyColors.red,
                  visibility: instagram,
                  icon: Iconsax.instagram,
                  text: '????????????????????',
                ),
              ],
            ),
          ),
          div(),
          MyRow2(
            icon: Iconsax.subtitle,
            title: '??????????:',
            value: title,
          ),
          div(visible: isHirng),
          MyRow2(
              visible: isHirng,
              icon: gender == '??????' ? Iconsax.man : Iconsax.woman,
              title: '??????????:',
              value: gender),
          div(visible: isHirng),
          MyRow2(
            visible: isHirng,
            icon: Iconsax.home_wifi,
            title: '?????? ????????????:',
            value: cooperation,
          ),
          div(visible: isHirng),
          MyRow2(
            visible: isHirng,
            icon: Iconsax.wallet_1,
            title: '???????? ????????????:',
            value: payMthod,
          ),
          div(visible: isHirng),
          MyRow2(
            visible: isHirng,
            icon: Iconsax.dollar_circle,
            title: '???????? ??????????????:',
            value: price == '????????????' ? '????????????' : MyStrings.digi(price),
          ),
          div(visible: isHirng),
          MyRow2(
            visible: isHirng,
            icon: Iconsax.clock,
            title: '?????????? ????????:',
            value: workTime,
          ),
          div(visible: isHirng),
          MyRow2(
            visible: isHirng,
            icon: Iconsax.briefcase,
            title: '????????:',
            value: skill,
          ),
          div(),
          MyRow2(
              icon: Iconsax.location,
              title: '???????????? ?????????? ?????? ????????:',
              value: location ? '????????' : '??????????'),
          div(visible: isHirng),
          MyRow2(
            visible: isHirng,
            icon: Iconsax.paperclip,
            title: '???????????? ???????????? ??????????:',
            value: resume ? '????????' : '??????????',
          ),
          div(),
          MyRow2(
            icon: Iconsax.category_2,
            title: '???????? ????????:',
            value: category,
          ),
          div(),
          MyRow2(
            icon: Iconsax.building_3,
            title: '??????:',
            value: city,
          ),
          div(visible: otherFeauturesController.locationBool.value),
          MyRow2(
              icon: Iconsax.map,
              title: '????????:',
              value: address,
              visible: otherFeauturesController.locationBool.value),
          div(),
          const Center(
            child: Text(
              '??????????????',
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
