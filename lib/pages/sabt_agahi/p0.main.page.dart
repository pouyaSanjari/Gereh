import 'package:digit_to_persian_word/digit_to_persian_word.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax/iconsax.dart';
import 'package:im_stepper/stepper.dart';
import 'package:lottie/lottie.dart';
import 'package:sarkargar/components/button.dart';
import 'package:sarkargar/constants/colors.dart';
import 'package:sarkargar/services/uiDesign.dart';
import 'package:sarkargar/pages/sabt_agahi/p1.title.dart';
import 'package:sarkargar/pages/sabt_agahi/p3.paid.features.dart';
import 'package:sarkargar/pages/sabt_agahi/p2.workers.count.dart';
import 'package:sarkargar/pages/sabt_agahi/p4.insert.to.database.dart';
import 'package:sarkargar/services/database.dart';
import '../../controllers/request_controller.dart';

class MainRequestPage extends StatefulWidget {
  const MainRequestPage({Key? key}) : super(key: key);

  @override
  State<MainRequestPage> createState() => _MainRequestPageState();
}

class _MainRequestPageState extends State<MainRequestPage>
    with SingleTickerProviderStateMixin {
  final box = GetStorage();
  final controller = Get.put(RequestController());
  late Animation animation;

  UiDesign uiDesign = UiDesign();
  AppDataBase dataBase = AppDataBase();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: uiDesign.cTheme(),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  //قسمت بالای صفحه مربوط به استپر
                  Obx(() => buildIconStepper()),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          //قسمت وارد کردن اطلاعات
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Obx(() => body()),
                          ),
                        ],
                      ),
                    ),
                  ),

                  //دکمه های کنترل استپر
                  Obx(() => buttons())
                ],
              ),
            ),
          )),
    );
  }

  //دکمه های هر صفحه و عملکرد آنها
  Padding buttons() {
    switch (controller.activeStep.value) {
      case 0:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: MyButton(
              fillColor: MyColors.red,
              text: 'ادامه...',
              onClick: () {
                if (controller.title.trim().isEmpty) {
                  controller.titleError.value = 'وارد کردن عنوان الزامی است.';
                } else if (controller.title.trim().length < 5) {
                  controller.titleError.value = 'حداقل 5 کاراکتر وارد کنید.';
                } else if (controller.selectedCategory.trim().isEmpty) {
                  controller.categoryError.value = 'یک دسته بندی انتخاب کنید.';
                } else if (controller.descriptions.trim().isEmpty) {
                  controller.descriptionsError.value =
                      'واردکردن توضیحات آگهی الزامی است.';
                } else if (controller.descriptions.trim().length < 10) {
                  controller.descriptionsError.value =
                      'حداقل 10 کاراکتر وارد کنید.';
                } else {
                  controller.adType.value == 0
                      ? controller.activeStep.value++
                      : controller.activeStep.value = 2;
                }
              }),
        );
      case 1:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              backBTN(),
              MyButton(
                text: 'ادامه',
                fillColor: MyColors.red,
                icon: const Icon(Iconsax.arrow_left_1, color: Colors.white),
                onClick: () {
                  switch (controller.switchEntekhabJensiyat.value) {
                    //جنسیت آقا انتخال شده

                    case 0:
                      if (controller.tedadNafaratMard.value == '') {
                        controller.tedadNafaratMardError.value =
                            'تعداد نفرات درخواستی را وارد کنید.';
                      } else if (controller.ghimatPishnahadiMard.isEmpty &&
                          controller.ghimatTavafoghiMardBL.value == false) {
                        controller.ghimatPishnahadiMardError.value =
                            'یا یک قیمت پیشنهاد دهید یا قیمت توافقی را انتخاب کنید.';
                      } else {
                        controller.activeStep.value++;
                      }
                      break;
                    //جنسیت خانم انتخاب شده
                    case 1:
                      if (controller.tedadNafaratZan.value == '') {
                        controller.tedadNafaratZanError.value =
                            'تعداد نفرات درخواستی را وارد کنید.';
                      } else if (controller.ghimatPishnahadiZan.isEmpty &&
                          controller.ghimatTavafoghiZanBL.value == false) {
                        controller.ghimatPishnahadiZanError.value =
                            'یا یک قیمت پیشنهاد دهید یا قیمت توافقی را انتخاب کنید.';
                      } else {
                        controller.activeStep.value++;
                      }
                      break;
                    //هردو جنسیت انتخاب شده
                    case 2:
                      if (controller.tedadNafaratMard.value == '') {
                        controller.tedadNafaratMardError.value =
                            'تعداد نفرات درخواستی را وارد کنید.';
                      } else if (controller.tedadNafaratZan.value == '') {
                        controller.tedadNafaratZanError.value =
                            'تعداد نفرات درخواستی را وارد کنید.';
                      } else if (controller.ghimatPishnahadiMard.isEmpty &&
                          controller.ghimatTavafoghiMardBL.value == false) {
                        controller.ghimatPishnahadiMardError.value =
                            'یا یک قیمت پیشنهاد دهید یا قیمت توافقی را انتخاب کنید.';
                      } else if (controller.ghimatPishnahadiZan.isEmpty &&
                          controller.ghimatTavafoghiZanBL.value == false) {
                        controller.ghimatPishnahadiZanError.value =
                            'یا یک قیمت پیشنهاد دهید یا قیمت توافقی را انتخاب کنید.';
                      } else {
                        controller.activeStep.value++;
                      }
                      break;
                    default:
                  }
                },
              )
            ],
          ),
        );
      case 2:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MyButton(
                fillColor: Colors.grey[50],
                borderColor: Colors.black,
                icon: const Icon(Iconsax.arrow_right_4),
                onClick: () {
                  setState(() {
                    controller.adType.value == 0
                        ? controller.activeStep.value--
                        : controller.activeStep.value = 0;
                  });
                },
                text: 'بازگشت',
              ),
              MyButton(
                fillColor: MyColors.red,
                icon: const Icon(Iconsax.arrow_left_1, color: Colors.white),
                onClick: () => controller.activeStep.value++,
                text: 'ادامه',
              )
            ],
          ),
        );

      case 3:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              backBTN(),
              MyButton(
                  fillColor: Colors.green,
                  text: 'ثبت',
                  onClick: () {
                    setState(() {
                      insertAdToDb();
                    });
                  })
            ],
          ),
        );
      default:
        return Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MyButton(
                onClick: () {
                  setState(() {
                    if (controller.activeStep.value >= 1) {
                      controller.activeStep.value--;
                    }
                  });
                },
                text: 'بازگشت',
              ),
              MyButton(
                onClick: () => setState(() {
                  if (controller.activeStep.value <= 4) {
                    controller.activeStep.value++;
                  }
                }),
                text: 'ادامه',
              )
            ],
          ),
        );
    }
  }

  MyButton backBTN() {
    return MyButton(
      fillColor: Colors.transparent,
      borderColor: Colors.black,
      icon: const Icon(Iconsax.arrow_right_4),
      onClick: () {
        controller.activeStep.value--;
      },
    );
  }

//ذخیره تبلیغ در دیتابیس
  insertAdToDb() async {
    var response = await dataBase.addNewAD(
      advertizer: box.read('id').toString(),
      adtype: controller.adType.value.toString(),
      hiringtype: controller.switchHiringType.value.toString(),
      title: controller.title.value.trim(),
      category: controller.selectedCategory.value,
      city: controller.selectedCity.value,
      address: controller.locationSelectionBool.value
          ? controller.address.value
          : '',
      instagramid: controller.instagramIdSelectionBool.value
          ? controller.selectedInstagramId.value
          : '',
      locationlat: controller.locationSelectionBool.value
          ? controller.selectedLat.value.toString()
          : '',
      locationlon: controller.locationSelectionBool.value
          ? controller.selectedLon.value.toString()
          : '',
      phonebool: controller.phoneBool.value ? '1' : '0',
      smsbool: controller.smsbool.value ? '1' : '0',
      chatbool: controller.chatBool.value ? '1' : '0',
      photobool: controller.imageSelectionBool.value ? '1' : '0',
      locationbool: controller.locationSelectionBool.value ? '1' : '0',
      instagrambool: controller.instagramIdSelectionBool.value ? '1' : '0',
      men: mardVisibility() ? controller.tedadNafaratMard.value : '',
      women: zanVisibility() ? controller.tedadNafaratZan.value : '',
      mprice: mardVisibility() ? controller.ghimatPishnahadiMard.value : '',
      wprice: zanVisibility() ? controller.ghimatPishnahadiZan.value : '',
      descs: controller.descriptions.value,
    );
    setState(() {
      if (response.toString() == '200') {
        showDialog<void>(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              content: SingleChildScrollView(
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: Column(
                      children: [
                        Lottie.asset(
                          'assets/lottie/done.json',
                          height: 150,
                          width: 150,
                        ),
                        const Text(
                          '( ثبت شد )',
                          style: TextStyle(color: Colors.green, fontSize: 22),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'کاربر گرامی آگهی شما با موفقیت ثبت گردید و پس از تایید نمایش داده خواهد شد.',
                          style: TextStyle(height: 1.8),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text(
                    'تایید',
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () {
                    setState(() {
                      controller.activeStep.value = 0;
                    });
                    Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                  },
                ),
              ],
            );
          },
        );
      }
    });
  }

//آیکان های استپر
  IconStepper buildIconStepper() {
    return IconStepper(
      enableStepTapping: false,
      stepReachedAnimationEffect: Curves.easeOutBack,
      stepRadius: 20,
      lineDotRadius: 1.4,
      activeStepColor: Colors.transparent,
      stepColor: Colors.transparent,
      enableNextPreviousButtons: false,
      lineColor: MyColors.blueGrey,
      activeStepBorderColor: Colors.transparent,
      activeStep: controller.activeStep.value,
      // lineLength: 100,
      onStepReached: (index) {
        setState(() {
          controller.activeStep.value = index;
        });
      },
      icons: [
        Icon(
          Iconsax.message_question,
          color: controller.activeStep.value == 0 ? MyColors.red : Colors.grey,
        ),
        Icon(
          Iconsax.people,
          color: controller.activeStep.value == 1 ? MyColors.red : Colors.grey,
        ),
        Icon(
          Iconsax.dollar_circle,
          color: controller.activeStep.value == 2 ? MyColors.red : Colors.grey,
        ),
        Icon(
          Iconsax.tick_square,
          color: controller.activeStep.value == 3 ? MyColors.red : Colors.grey,
        )
      ],
    );
  }

  //بدنه هر استپر
  Widget body() {
    switch (controller.activeStep.value) {
      case 1:
        return const WorkersCount();
      case 2:
        return const PaidFeatures();
      case 3:
        return const InsertToDataBase();
      default:
        return const TitlePage();
    }
  }

  //اعداد دریافتی را به تومان تبدیل میکند
  String digi(String number) {
    String digit = DigitToWord.toWord(number, StrType.NumWord, isMoney: true);
    return digit;
  }

  bool zanVisibility() =>
      controller.tedadNafaratZan.isEmpty || controller.adType.value == 1
          ? false
          : true;
  bool mardVisibility() =>
      controller.tedadNafaratMard.isEmpty || controller.adType.value == 1
          ? false
          : true;
}
