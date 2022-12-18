import 'package:digit_to_persian_word/digit_to_persian_word.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:gereh/components/buttons/my_button.dart';
import 'package:gereh/components/textFields/selectable_text_field.dart';
import 'package:gereh/components/textFields/my_text_field.dart';
import 'package:gereh/pages/sabt_agahi/controller/request_controller.dart';
import 'package:gereh/services/ui_design.dart';
import '../../../constants/my_colors.dart';

class WorkerDetails extends GetView<RequestController> {
  const WorkerDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double dividerSize = 20;

    return Obx(
      () => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Center(
              child: Text(
                'مشخصات نیرو مورد نیاز',
                style: TextStyle(
                    fontFamily: 'titr', fontSize: 30, color: Colors.black87),
              ),
            ),
            const Divider(
                height: 30, color: Colors.black, indent: 50, endIndent: 50),
            // const SizedBox(height: 20),
            Text('|جنسیت', style: UiDesign.titleTextStyle()),
            SelectableTextField(
              error: controller.genderError.isEmpty
                  ? null
                  : controller.genderError.value,
              labeltext: 'آقا، خانم، مهم نیست',
              control: controller.genderTEC.value,
              icon: const Icon(
                Iconsax.woman,
                color: MyColors.black,
              ),
              onClick: () async {
                String result = await showDialog(
                  context: context,
                  useSafeArea: true,
                  builder: (context) {
                    return WillPopScope(
                      onWillPop: () async => false,
                      child: selectGenderDialogue(),
                    );
                  },
                );
                controller.genderTEC.value.text = result;
                controller.genderError.value = '';
              },
            ),
            SizedBox(height: dividerSize),
            Text('|نوع همکاری', style: UiDesign.titleTextStyle()),
            SelectableTextField(
              error: controller.cooperationTypeError.value == ''
                  ? null
                  : controller.cooperationTypeError.value,
              labeltext: 'حضوری، دورکاری',
              control: controller.cooperationTypeTEC.value,
              icon: const Icon(
                Iconsax.home_wifi,
                color: MyColors.black,
              ),
              onClick: () async {
                String result = await showDialog(
                  context: context,
                  builder: (context) {
                    return WillPopScope(
                      onWillPop: () async => false,
                      child: AlertDialog(
                        title: const Center(child: Text('نوع همکاری')),
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            customIconButton(
                              result: 'حضوری',
                              icon: FontAwesomeIcons.personDigging,
                              iconColor: MyColors.red,
                            ),
                            const SizedBox(width: 5),
                            customIconButton(
                              result: 'دورکاری',
                              icon: FontAwesomeIcons.houseLaptop,
                              iconColor: MyColors.blue,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
                controller.cooperationTypeTEC.value.text = result;
                controller.cooperationTypeError.value = '';
              },
            ),
            SizedBox(height: dividerSize),
            Text('|ساعات کاری', style: UiDesign.titleTextStyle()),
            SelectableTextField(
              error: controller.workTimeError.value == ''
                  ? null
                  : controller.workTimeError.value,
              labeltext: 'تمام وقت، پاره وقت',
              control: controller.workTimeTEC.value,
              icon: const Icon(
                Iconsax.clock,
                color: MyColors.black,
              ),
              onClick: () async {
                String result = await showDialog(
                  context: context,
                  builder: (context) {
                    return WillPopScope(
                      onWillPop: () async => false,
                      child: AlertDialog(
                        title: const Center(child: Text('ساعات کاری:')),
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            customIconButton(
                              result: 'نیمه وقت',
                              icon: Iconsax.timer_pause,
                              iconColor: MyColors.red,
                            ),
                            const SizedBox(width: 5),
                            customIconButton(
                              result: 'تمام وقت',
                              icon: Iconsax.brifecase_timer,
                              iconColor: MyColors.blue,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
                controller.workTimeTEC.value.text = result;
                controller.workTimeError.value = '';
              },
            ),
            SizedBox(height: dividerSize),
            Text('|شیوه پرداخت', style: UiDesign.titleTextStyle()),
            SelectableTextField(
              error: controller.payMethodError.value == ''
                  ? null
                  : controller.payMethodError.value,
              labeltext: 'روزمزد، ماهیانه',
              control: controller.payMethodTEC.value,
              icon: const Icon(
                Iconsax.wallet_1,
                color: MyColors.black,
              ),
              onClick: () async {
                String result = await showDialog(
                  context: context,
                  builder: (context) {
                    return WillPopScope(
                      onWillPop: () async => false,
                      child: AlertDialog(
                        title: const Center(child: Text('شیوه پرداخت')),
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            customIconButton(
                              result: 'روزمزد',
                              icon: FontAwesomeIcons.handHoldingDollar,
                              iconColor: MyColors.red,
                            ),
                            const SizedBox(width: 5),
                            customIconButton(
                              result: 'ماهیانه',
                              icon: FontAwesomeIcons.sackDollar,
                              iconColor: MyColors.blue,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
                controller.payMethodTEC.value.text = result;
                controller.payMethodError.value = '';
              },
            ),
            SizedBox(height: dividerSize),
            Text('|تخصص', style: UiDesign.titleTextStyle()),
            MyTextField(
              error: controller.skillError.value.isEmpty
                  ? null
                  : controller.skillError.value,
              labeltext: 'عنوان تخصص مورد نظر',
              onChange: (value) {
                controller.skillError.value = '';
              },
              control: controller.skillTEC.value,
              icon: const Icon(
                Iconsax.briefcase,
                color: MyColors.black,
              ),
            ),
            SizedBox(height: dividerSize),
            Text('|مبلغ پیشنهادی شما', style: UiDesign.titleTextStyle()),
            const SizedBox(height: 5),
            Obx(
              () => MyTextField(
                labeltext: 'به تومان وارد کنید',
                icon: const Icon(
                  Iconsax.dollar_circle,
                  color: MyColors.black,
                ),
                error: controller.priceError.isEmpty
                    ? null
                    : controller.priceError.value,
                control: controller.priceTEC.value,
                hint: 'به تومان وارد کنید',
                length: 8,
                enabled: !controller.ghimatTavafoghiBL.value,
                textInputType: const TextInputType.numberWithOptions(),
                maxLine: 1,
                onChange: (value) {
                  controller.priceError.value = '';
                  controller.price.value = value;
                },
              ),
            ),
            Row(
              children: [
                const Text('   قیمت توافقی'),
                Transform.scale(
                  scale: 1.2,
                  child: Checkbox(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      activeColor: MyColors.red,
                      value: controller.ghimatTavafoghiBL.value,
                      onChanged: (value) {
                        controller.priceError.value = '';
                        controller.price.value = '';
                        if (value == false) {
                          controller.priceTEC.value.clear();
                        } else {
                          controller.priceTEC.value.text = 'توافقی';
                        }
                        controller.ghimatTavafoghiBL.value = value!;
                      }),
                ),
                Obx(
                  () => Text(
                    digi(controller.price.value),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  MyButton customIconButton(
      {required String result,
      required IconData icon,
      required Color iconColor}) {
    return MyButton(
      onClick: () {
        Get.back(result: result);
      },
      fillColor: Colors.white,
      borderColor: Colors.grey,
      radius: 10,
      width: 100,
      height: 100,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(
          icon,
          color: iconColor,
          size: 55,
        ),
        const SizedBox(height: 5),
        Text(
          result,
          style: const TextStyle(fontSize: 18),
        )
      ]),
    );
  }

  AlertDialog selectGenderDialogue() {
    return AlertDialog(
      insetPadding: const EdgeInsets.all(0),
      title: const Center(child: Text('انتخاب جنسیت')),
      content: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            customIconButton(
                result: 'مهم نیست',
                icon: FontAwesomeIcons.peopleArrows,
                iconColor: MyColors.blue),
            const SizedBox(width: 5),
            customIconButton(
                result: 'خانم',
                icon: FontAwesomeIcons.personDress,
                iconColor: MyColors.orange),
            const SizedBox(width: 5),
            customIconButton(
                result: 'آقا',
                icon: FontAwesomeIcons.person,
                iconColor: MyColors.red),
          ],
        ),
      ),
    );
  }

  String digi(String number) {
    String digit = DigitToWord.toWord(number, StrType.NumWord, isMoney: true);
    return digit;
  }
}
