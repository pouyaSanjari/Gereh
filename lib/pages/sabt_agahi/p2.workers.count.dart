import 'package:digit_to_persian_word/digit_to_persian_word.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sarkargar/components/buttons/button.dart';
import 'package:sarkargar/components/textFields/selectable.text.field.dart';
import 'package:sarkargar/components/toggle.switch.dart';
import 'package:sarkargar/components/textFields/text.field.dart';
import 'package:sarkargar/controllers/request_controller.dart';
import 'package:sarkargar/services/uiDesign.dart';
import '../../constants/colors.dart';

class WorkersCount extends StatelessWidget {
  const WorkersCount({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UiDesign uiDesign = UiDesign();
    final controller = Get.put(RequestController());
    double dividerSize = 20;

    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'مشخصات نیرو مورد نیاز',
            style: TextStyle(
                fontFamily: 'titr', fontSize: 30, color: Colors.black87),
          ),
          const SizedBox(height: 20),
          Text('|جنسیت', style: uiDesign.titleTextStyle()),
          MySelectableTextField(
            labeltext: 'آقا، خانم، مهم نیست',
            control: controller.selectGenderTEC.value,
            icon: const Icon(
              Iconsax.woman5,
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
              controller.selectGenderTEC.value.text = result;
            },
          ),
          SizedBox(height: dividerSize),
          Text('|نوع همکاری', style: uiDesign.titleTextStyle()),
          MySelectableTextField(
            labeltext: 'حضوری، دورکاری',
            control: controller.selectCollaborationTypeTEC.value,
            icon: const Icon(
              FontAwesomeIcons.personWalkingLuggage,
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
              controller.selectCollaborationTypeTEC.value.text = result;
            },
          ),
          SizedBox(height: dividerSize),
          Text('|ساعات کاری', style: uiDesign.titleTextStyle()),
          MySelectableTextField(
            labeltext: 'تمام وقت، پاره وقت',
            control: controller.selectWorkTimeTEC.value,
            icon: const Icon(
              FontAwesomeIcons.solidClock,
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
              controller.selectWorkTimeTEC.value.text = result;
            },
          ),
          SizedBox(height: dividerSize),
          Text('|شیوه پرداخت', style: uiDesign.titleTextStyle()),
          MySelectableTextField(
            labeltext: 'روزمزد، ماهیانه',
            control: controller.selectPayMethodTEC.value,
            icon: const Icon(
              FontAwesomeIcons.wallet,
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
              controller.selectPayMethodTEC.value.text = result;
            },
          ),
          SizedBox(height: dividerSize),
          Text('|تخصص', style: uiDesign.titleTextStyle()),
          MyTextField(
            labeltext: 'عنوان تخصص مورد نظر',
            control: controller.skillTEC.value,
            icon: const Icon(
              FontAwesomeIcons.briefcase,
              color: MyColors.black,
            ),
          ),
          SizedBox(height: dividerSize),
          Text('|مبلغ پیشنهادی شما', style: uiDesign.titleTextStyle()),
          const SizedBox(height: 5),
          MyTextField(
            labeltext: 'به تومان وارد کنید',
            icon: const Icon(
              FontAwesomeIcons.sackDollar,
              color: MyColors.black,
            ),
            error: controller.ghimatPishnahadiError.isEmpty
                ? null
                : controller.ghimatPishnahadiError.value,
            control: controller.priceTEC.value,
            hint: 'به تومان وارد کنید',
            length: 8,
            textInputType: const TextInputType.numberWithOptions(),
            maxLine: 1,
            onChange: (value) {
              controller.ghimatPishnahadiError.value = '';
              controller.ghimatPishnahadi.value = value;
            },
          ),
          Row(
            children: [
              const Text('   قیمت توافقی'),
              Transform.scale(
                scale: 1.2,
                child: Checkbox(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    activeColor: MyColors.red,
                    value: controller.ghimatTavafoghiBL.value,
                    onChanged: (value) {
                      controller.ghimatPishnahadiError.value = '';
                      if (value == false) {
                        controller.priceTEC.value.clear();
                      } else {
                        controller.priceTEC.value.text = 'توافقی';
                        controller.ghimatPishnahadi.value = '';
                      }
                      controller.ghimatPishnahadi.value = '';
                      controller.ghimatTavafoghiBL.value = value ?? false;
                    }),
              ),
              Text(digi(controller.ghimatPishnahadi.value)),
            ],
          ),
        ],
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
                icon: FontAwesomeIcons.peopleArrowsLeftRight,
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
