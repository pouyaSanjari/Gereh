import 'package:digit_to_persian_word/digit_to_persian_word.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sarkargar/components/toggle.switch.dart';
import 'package:sarkargar/components/text.field.dart';
import 'package:sarkargar/controllers/request_controller.dart';
import 'package:sarkargar/services/uiDesign.dart';
import '../../constants/colors.dart';

class WorkersCount extends StatefulWidget {
  const WorkersCount({Key? key}) : super(key: key);

  @override
  State<WorkersCount> createState() => _WorkersCountState();
}

class _WorkersCountState extends State<WorkersCount> {
  final controller = Get.put(RequestController());
  UiDesign uiDesign = UiDesign();
  TextEditingController tedadNafaratMardTEC = TextEditingController();
  TextEditingController tedadNafaratZanTEC = TextEditingController();
  TextEditingController ghimatPishnahadiMardTEC = TextEditingController();
  TextEditingController ghimatPishnahadiZanTEC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(child: Text('جنسیت', style: uiDesign.titleTextStyle())),
          const SizedBox(height: 5),
          Center(
            child: MyToggleSwitch(
              initialLableIndex: controller.switchEntekhabJensiyat.value,
              labels: const ['آقا', 'خانم', 'هر دو'],
              totalSwitch: 3,
              onToggle: (index) {
                switch (index) {
                  case 0:
                    tedadNafaratZanTEC.clear();
                    ghimatPishnahadiZanTEC.clear();
                    controller.ghimatPishnahadiZan.value = '';
                    controller.tedadNafaratZan.value = '';
                    controller.maleVisibility.value = true;
                    controller.femaleVisibility.value = false;
                    controller.switchEntekhabJensiyat.value = 0;
                    return;
                  case 1:
                    controller.maleVisibility.value = false;
                    ghimatPishnahadiMardTEC.clear();
                    tedadNafaratMardTEC.clear();
                    controller.ghimatPishnahadiMard.value = '';
                    controller.tedadNafaratMard.value = '';
                    controller.femaleVisibility.value = true;
                    controller.switchEntekhabJensiyat.value = 1;
                    return;
                  case 2:
                    controller.maleVisibility.value = true;
                    controller.femaleVisibility.value = true;
                    controller.switchEntekhabJensiyat.value = 2;
                    return;
                }
              },
            ),
          ),
          const SizedBox(height: 40),
          Center(child: Text('نوع استخدام', style: uiDesign.titleTextStyle())),
          const SizedBox(height: 5),
          Center(
            child: MyToggleSwitch(
              initialLableIndex: controller.switchHiringType.value,
              labels: const ['روزمزد', 'ماهیانه'],
              totalSwitch: 2,
              onToggle: (index) => controller.switchHiringType.value = index!,
            ),
          ),
          const SizedBox(height: 40),
          Text('|تعداد نفرات مورد نیاز', style: uiDesign.titleTextStyle()),
          Visibility(
              visible: controller.maleVisibility.value,
              child: const SizedBox(height: 5)),
          AnimatedOpacity(
            opacity: controller.maleVisibility.value ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 500),
            child: Visibility(
              visible: controller.maleVisibility.value,
              child: MyTextField(
                  error: controller.tedadNafaratMardError.isEmpty
                      ? null
                      : controller.tedadNafaratMardError.value,
                  labeltext: 'تعداد نفرات آقا مورد نیاز',
                  icon: const Icon(Iconsax.man4),
                  control: tedadNafaratMardTEC,
                  length: 2,
                  textInputType: const TextInputType.numberWithOptions(),
                  onChange: (value) {
                    controller.tedadNafaratMardError.value = '';
                    controller.tedadNafaratMard.value = value;
                  }),
            ),
          ),
          Visibility(
              visible: controller.femaleVisibility.value,
              child: const SizedBox(height: 5)),
          AnimatedOpacity(
            opacity: controller.femaleVisibility.value ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 500),
            child: Visibility(
              visible: controller.femaleVisibility.value,
              child: Obx(
                () => MyTextField(
                    error: controller.tedadNafaratZanError.value == ''
                        ? null
                        : controller.tedadNafaratZanError.value,
                    labeltext: 'تعداد نفرات خانم مورد نیاز',
                    icon: const Icon(Iconsax.woman4),
                    control: tedadNafaratZanTEC,
                    length: 2,
                    textInputType: const TextInputType.numberWithOptions(),
                    onChange: (value) {
                      controller.tedadNafaratZanError.value = '';
                      controller.tedadNafaratZan.value = value;
                    }),
              ),
            ),
          ),
          const SizedBox(height: 40),
          Text('|مبلغ پیشنهادی شما', style: uiDesign.titleTextStyle()),
          Text(
              'سعی کنید مبلغی که پیشنهاد می دهید منصفانه باشد. مبلغ پیشنهادی شما پایین عنوان آگهی درج و تاثیر مستقیم بر شانس کلیک بر روی آگهی دارد.',
              style: uiDesign.descriptionsTextStyle()),
          const SizedBox(height: 5),
          AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            opacity: controller.maleVisibility.value ? 1.0 : 0.0,
            child: Visibility(
              visible: controller.maleVisibility.value,
              child: MyTextField(
                  enabled: controller.ghimatTavafoghiMardBL.value == false
                      ? true
                      : false,
                  labeltext: 'مبلغ پیشنهادی برای آقا',
                  icon: const Icon(Iconsax.dollar_circle),
                  error: controller.ghimatPishnahadiMardError.isEmpty
                      ? null
                      : controller.ghimatPishnahadiMardError.value,
                  control: ghimatPishnahadiMardTEC,
                  hint: 'به تومان وارد کنید',
                  length: 8,
                  textInputType: const TextInputType.numberWithOptions(),
                  maxLine: 1,
                  onChange: (value) {
                    controller.ghimatPishnahadiMardError.value = '';
                    controller.ghimatPishnahadiMard.value = value;
                  }),
            ),
          ),
          Visibility(
            visible: controller.maleVisibility.value,
            child: Row(
              children: [
                const Text('   قیمت توافقی'),
                Transform.scale(
                  scale: 1.2,
                  child: Checkbox(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      activeColor: MyColors.red,
                      value: controller.ghimatTavafoghiMardBL.value,
                      onChanged: (value) {
                        controller.ghimatPishnahadiMardError.value = '';
                        if (value == false) {
                          ghimatPishnahadiMardTEC.clear();
                        } else {
                          ghimatPishnahadiMardTEC.text = 'توافقی';
                          controller.ghimatPishnahadiMard.value = '';
                        }
                        controller.ghimatPishnahadiMard.value = '';
                        controller.ghimatTavafoghiMardBL.value = value ?? false;
                      }),
                ),
                Text(digi(controller.ghimatPishnahadiMard.value)),
              ],
            ),
          ),
          AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            opacity: controller.femaleVisibility.value ? 1.0 : 0.0,
            child: Visibility(
              visible: controller.femaleVisibility.value,
              child: MyTextField(
                  error: controller.ghimatPishnahadiZanError.isEmpty
                      ? null
                      : controller.ghimatPishnahadiZanError.value,
                  enabled: controller.ghimatTavafoghiZanBL.value == false
                      ? true
                      : false,
                  labeltext: 'مبلغ پیشنهادی برای خانم',
                  icon: const Icon(Iconsax.dollar_circle),
                  control: ghimatPishnahadiZanTEC,
                  hint: 'به تومان وارد کنید',
                  length: 8,
                  textInputType: const TextInputType.numberWithOptions(),
                  maxLine: 1,
                  onChange: (value) {
                    controller.ghimatPishnahadiZanError.value = '';
                    controller.ghimatPishnahadiZan.value = value;
                  }),
            ),
          ),
          Visibility(
            visible: controller.femaleVisibility.value,
            child: Row(
              children: [
                const Text('   قیمت توافقی'),
                Transform.scale(
                  scale: 1.2,
                  child: Checkbox(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      activeColor: MyColors.red,
                      value: controller.ghimatTavafoghiZanBL.value,
                      onChanged: (value) {
                        controller.ghimatPishnahadiZanError.value = '';
                        if (value == false) {
                          ghimatPishnahadiZanTEC.clear();
                        } else {
                          ghimatPishnahadiZanTEC.text = 'توافقی';
                          controller.ghimatPishnahadiZan.value = '';
                        }

                        controller.ghimatPishnahadiZan.value = '';
                        controller.ghimatTavafoghiZanBL.value = value!;
                      }),
                ),
                Text(
                  digi(controller.ghimatPishnahadiZan.value),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  String digi(String number) {
    String digit = DigitToWord.toWord(number, StrType.NumWord, isMoney: true);
    return digit;
  }

  @override
  void initState() {
    tedadNafaratMardTEC.text = controller.tedadNafaratMard.value;
    ghimatPishnahadiMardTEC.text = controller.ghimatPishnahadiMard.value;

    tedadNafaratZanTEC.text = controller.tedadNafaratZan.value;
    ghimatPishnahadiZanTEC.text = controller.ghimatPishnahadiZan.value;
    super.initState();
  }
}
