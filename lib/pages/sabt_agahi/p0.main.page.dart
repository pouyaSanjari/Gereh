import 'package:digit_to_persian_word/digit_to_persian_word.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax/iconsax.dart';
import 'package:im_stepper/stepper.dart';
import 'package:lottie/lottie.dart';
import 'package:gereh/components/buttons/button.dart';
import 'package:gereh/constants/colors.dart';
import 'package:gereh/pages/sabt_agahi/p4_other_futures.dart';
import 'package:gereh/services/ui_design.dart';
import 'package:gereh/pages/sabt_agahi/p1.title.dart';
import 'package:gereh/pages/sabt_agahi/p3_contact_info.dart';
import 'package:gereh/pages/sabt_agahi/p2_worker_details.dart';
import 'package:gereh/pages/sabt_agahi/p5_inser_to_database.dart';
import 'package:gereh/services/database.dart';
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

  AppDataBase dataBase = AppDataBase();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: UiDesign.cTheme(),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              SafeArea(
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      //قسمت بالای صفحه مربوط به استپر
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Obx(() => buildIconStepper()),
                              //قسمت وارد کردن اطلاعات
                              Obx(() => body()),
                              const SizedBox(height: 50)
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              //دکمه های کنترل استپر
              Directionality(
                textDirection: TextDirection.rtl,
                child: Positioned(
                    bottom: 0,
                    width: MediaQuery.of(context).size.width,
                    child: Obx(() => buttons())),
              ),
            ],
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
              child: const Text(
                'ادامه...',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onClick: () {
                controller.validateTitlePage();
              }),
        );
      case 1:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MyButton(
                elevation: 0,
                fillColor: Colors.grey.withOpacity(0.4),
                child: const Icon(Iconsax.arrow_right_4),
                onClick: () {
                  controller.activeStep.value--;
                },
              ),
              MyButton(
                fillColor: MyColors.red,
                onClick: () => controller.validateWorkerDeatails(),
                child: const Text(
                  'ادامه',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
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
                fillColor: Colors.grey.withOpacity(0.4),
                elevation: 0,
                child: const Icon(Iconsax.arrow_right_4),
                onClick: () {
                  controller.adType.value == 0
                      ? controller.activeStep.value--
                      : controller.activeStep.value = 0;
                },
              ),
              MyButton(
                fillColor: MyColors.red,
                child: const Icon(Iconsax.arrow_left_1, color: Colors.white),
                onClick: () {
                  controller.validateContactInfos();
                  // controller.activeStep.value++;
                },
              )
            ],
          ),
        );
      case 3:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MyButton(
                fillColor: Colors.grey.withOpacity(0.4),
                // borderColor: Colors.black,
                elevation: 0,
                child: const Icon(Iconsax.arrow_right_4),
                onClick: () {
                  controller.activeStep.value--;
                },
              ),
              MyButton(
                fillColor: MyColors.red,
                child: const Icon(Iconsax.arrow_left_1, color: Colors.white),
                onClick: () {
                  controller.validateOtherFuturesPage();
                },
              )
            ],
          ),
        );
      case 4:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              backBTN(),
              MyButton(
                  fillColor: Colors.green,
                  child: const Text(
                    'ثبت نهایی آگهی',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
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
                child: const Text('بازگشت'),
              ),
              MyButton(
                onClick: () => setState(() {
                  if (controller.activeStep.value <= 4) {
                    controller.activeStep.value++;
                  }
                }),
                child: const Text('ادامه'),
              )
            ],
          ),
        );
    }
  }

  MyButton backBTN() {
    return MyButton(
      elevation: 0,
      fillColor: Colors.grey.withOpacity(0.4),
      child: const Icon(Iconsax.arrow_right_4),
      onClick: () {
        controller.activeStep.value--;
      },
    );
  }

//ذخیره تبلیغ در دیتابیس
  insertAdToDb() async {
    var response = await dataBase.addNewAD(
      advertizerid: box.read('id').toString(),
      adtype: controller.adType.value.toString(),
      title: controller.titleTEC.value.text.trim(),
      category: controller.categoryTEC.value.text,
      city: controller.cityTEC.value.text,
      descs: controller.descriptionsTEC.value.text.trim(),
      gender: controller.genderTEC.value.text,
      workType: controller.cooperationTypeTEC.value.text,
      workTime: controller.workTimeTEC.value.text,
      payMethod: controller.payMethodTEC.value.text,
      profission: controller.skillTEC.value.text,
      price: controller.priceTEC.value.text,
      resumeBool: controller.resumeBool.value ? '1' : '0',
      callBool: controller.phoneBool.value ? '1' : '0',
      callNumber: controller.phoneTEC.value.text,
      smsBool: controller.smsBool.value ? '1' : '0',
      smsNumber: controller.smsTEC.value.text,
      chatBool: controller.chatBool.value ? '1' : '0',
      emailBool: controller.emailBool.value ? '1' : '0',
      emailAddress: controller.emailTEC.value.text,
      websiteBool: controller.websiteBool.value ? '1' : '0',
      websiteAddress: controller.websiteTEC.value.text,
      instagramBool: controller.instagramBool.value ? '1' : '0',
      instagramId: controller.instagramIdTEC.value.text,
      telegramBool: controller.telegramBool.value ? '1' : '0',
      telegramId: controller.telegramIdTEC.value.text,
      whatsappBool: controller.whatsappBool.value ? '1' : '0',
      whatsappNumber: controller.whatsappTEC.value.text,
      locationbool: controller.locationBool.value ? '1' : '0',
      locationlat: controller.selectedLat.value.toString(),
      locationlon: controller.selectedLon.value.toString(),
      address: controller.address.value.trim().toString(),
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
                    controller.activeStep.value = 0;
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
      enableNextPreviousButtons: false,
      stepReachedAnimationDuration: const Duration(milliseconds: 1),
      stepReachedAnimationEffect: Curves.fastLinearToSlowEaseIn,
      stepRadius: 20,
      lineDotRadius: 1.4,
      activeStepColor: Colors.transparent,
      stepColor: Colors.transparent,
      lineColor: MyColors.blueGrey,
      activeStepBorderColor: Colors.transparent,
      activeStep: controller.activeStep.value,
      // lineLength: 100,
      steppingEnabled: true,
      onStepReached: (index) {
        setState(() {
          controller.activeStep.value = index;
        });
      },
      icons: [
        // title page icon
        Icon(
          controller.activeStep.value == 0
              ? Iconsax.message_question5
              : Iconsax.message_question,
          color: controller.activeStep.value == 0 ? MyColors.red : Colors.grey,
        ),
        // worker datails page icon
        Icon(
          controller.activeStep.value == 1 ? Iconsax.people5 : Iconsax.people,
          color: controller.activeStep.value == 1 ? MyColors.red : Colors.grey,
        ),
        // contact info page icon
        Icon(
          controller.activeStep.value == 2
              ? Iconsax.call_calling5
              : Iconsax.call,
          color: controller.activeStep.value == 2 ? MyColors.red : Colors.grey,
        ),
        // other futures page icon
        Icon(
          controller.activeStep.value == 3
              ? Iconsax.more_circle5
              : Iconsax.more_circle,
          color: controller.activeStep.value == 3 ? MyColors.red : Colors.grey,
        ),
        // insert page icon
        Icon(
          controller.activeStep.value == 4
              ? Iconsax.tick_square5
              : Iconsax.tick_square,
          color: controller.activeStep.value == 4 ? MyColors.red : Colors.grey,
        ),
      ],
    );
  }

  //بدنه هر استپر
  Widget body() {
    switch (controller.activeStep.value) {
      case 1:
        return const WorkerDetails();
      case 2:
        return ContactInfo();
      case 3:
        return const OtherFutures();
      case 4:
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
}
