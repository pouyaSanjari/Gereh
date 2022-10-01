import 'package:digit_to_persian_word/digit_to_persian_word.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sarkargar/components/toggle.switch.dart';
import 'package:sarkargar/components/textFields/text.field.dart';
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
          Row(
            children: [
              Expanded(child: Text('جنسیت:', style: uiDesign.titleTextStyle())),
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.5,
                child: MyToggleSwitch(
                  minWidth: MediaQuery.of(context).size.width / 4.54,
                  initialLableIndex: controller.switchEntekhabJensiyat.value,
                  labels: const ['آقا', 'خانم', 'مهم نیست'],
                  totalSwitch: 3,
                  onToggle: (index) {
                    controller.switchEntekhabJensiyat.value = index!;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Expanded(
                  child: Text('نوع همکاری:', style: uiDesign.titleTextStyle())),
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.5,
                child: MyToggleSwitch(
                  initialLableIndex: controller.switchNoeHamkari.value,
                  minWidth: MediaQuery.of(context).size.width / 3.012,
                  labels: const ['حضوری', 'دور کاری'],
                  totalSwitch: 2,
                  onToggle: (index) {
                    controller.switchNoeHamkari.value = index!;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Center(child: Text('ساعات کاری', style: uiDesign.titleTextStyle())),
          const SizedBox(height: 5),
          Center(
            child: MyToggleSwitch(
              initialLableIndex: controller.switchSaatKari.value,
              labels: const ['نیمه وقت', 'تمام وقت'],
              totalSwitch: 2,
              onToggle: (index) {
                controller.switchSaatKari.value = index!;
              },
            ),
          ),
          const SizedBox(height: 10),
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
          const SizedBox(height: 5),
          MyTextField(
              error: controller.tedadNafaratMardError.isEmpty
                  ? null
                  : controller.tedadNafaratMardError.value,
              labeltext: 'تعداد نفرات ',
              icon: const Icon(Iconsax.man4),
              control: tedadNafaratMardTEC,
              length: 2,
              textInputType: const TextInputType.numberWithOptions(),
              onChange: (value) {
                controller.tedadNafaratMardError.value = '';
                controller.tedadNafaratMard.value = value;
              }),
          const SizedBox(height: 5),
          Text('|مبلغ پیشنهادی شما', style: uiDesign.titleTextStyle()),
          Text(
              'سعی کنید مبلغی که پیشنهاد می دهید منصفانه باشد. مبلغ پیشنهادی شما پایین عنوان آگهی درج و تاثیر مستقیم بر شانس کلیک بر روی آگهی دارد.',
              style: uiDesign.descriptionsTextStyle()),
          const SizedBox(height: 5),
          MyTextField(
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
          Row(
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
