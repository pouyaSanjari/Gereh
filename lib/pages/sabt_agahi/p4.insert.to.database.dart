import 'package:digit_to_persian_word/digit_to_persian_word.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:sarkargar/controllers/request_controller.dart';
import 'package:sarkargar/services/uiDesign.dart';

class InsertToDataBase extends StatefulWidget {
  const InsertToDataBase({Key? key}) : super(key: key);

  @override
  State<InsertToDataBase> createState() => _InsertToDataBaseState();
}

class _InsertToDataBaseState extends State<InsertToDataBase> {
  final controller = Get.put(RequestController());

  @override
  Widget build(BuildContext context) {
    var title = controller.title.value;
    var category = controller.category.value;
    var city = controller.city.value;
    var address = controller.address.value;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Lottie.asset('assets/lottie/taskcompleted.json',
              width: 150, height: 150),
        ),
        const Center(
            child: Text(
          'جزئیات آگهی شما',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        )),
        const Divider(
            height: 30, color: Colors.black, indent: 50, endIndent: 50),
        Text('راه های ارتباطی', style: UiDesign().titleTextStyle()),
        Text(
          'سبز نشانگر فعال و قرمز نشانگر غیر فعال بودن است.',
          style: UiDesign().descriptionsTextStyle(),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Icon(
                  Iconsax.call,
                  color: controller.phoneBool.value ? Colors.green : Colors.red,
                ),
                const Text('تماس')
              ],
            ),
            Column(
              children: [
                Icon(
                  Iconsax.sms,
                  color: controller.chatBool.value ? Colors.green : Colors.red,
                ),
                const Text('چت')
              ],
            ),
            Column(
              children: [
                Icon(
                  Iconsax.location,
                  color: controller.locationSelectionBool.value
                      ? Colors.green
                      : Colors.red,
                ),
                const Text('نقشه')
              ],
            ),
            Column(
              children: [
                Icon(
                  Iconsax.instagram,
                  color: controller.instagramIdSelectionBool.value
                      ? Colors.green
                      : Colors.red,
                ),
                const Text('اینستاگرام')
              ],
            )
          ],
        ),
        div(),
        redif(
          title: 'عنوان:',
          value: title,
        ),
        div(),
        redif(
          title: 'دسته بندی:',
          value: category,
        ),
        div(),
        redif(title: 'شهر:', value: city),
        div(visible: controller.locationSelectionBool.value),
        redif(
            title: 'آدرس:',
            value: address,
            visible: controller.locationSelectionBool.value),
        div(),
        const Center(
          child: Text(
            'توضیحات',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
        ),
        const SizedBox(height: 10),
        Text(controller.desc.value)
      ],
    );
  }

  Visibility div({bool? visible}) {
    return Visibility(
        visible: visible ?? true, child: const Divider(height: 30));
  }

  Visibility redif({String? title, String? value, bool? visible}) {
    return Visibility(
      visible: visible ?? true,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title ?? ''),
          Text(value ?? ''),
        ],
      ),
    );
  }

  //اعداد دریافتی را به تومان تبدیل میکند
  String digi(String number) {
    String digit = DigitToWord.toWord(number, StrType.NumWord, isMoney: true);
    return digit;
  }

  @override
  // ignore: must_call_super
  void initState() {}
}
