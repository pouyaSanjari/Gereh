import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gereh/pages/sabt_agahi/3_adFeautures/controller/ad_feautures_controller.dart';
import 'package:gereh/pages/sabt_agahi/4_contactInfo/controller/contact_info_controller.dart';
import 'package:gereh/pages/sabt_agahi/1_title/controller/title_controller.dart';
import 'package:gereh/pages/sabt_agahi/3_adFeautures/view/ad_feautures.dart';
import 'package:gereh/pages/sabt_agahi/2_workerDetails/controller/worker_details_controller.dart';
import 'package:gereh/pages/sabt_agahi/5_otherFeautures/controller/other_feautures_controller.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax/iconsax.dart';
import 'package:im_stepper/stepper.dart';
import 'package:lottie/lottie.dart';
import 'package:gereh/components/buttons/my_button.dart';
import 'package:gereh/constants/my_colors.dart';
import 'package:gereh/pages/sabt_agahi/5_otherFeautures/view/p4_other_futures.dart';
import 'package:gereh/services/ui_design.dart';
import 'package:gereh/pages/sabt_agahi/1_title/view/title_page.dart';
import 'package:gereh/pages/sabt_agahi/4_contactInfo/view/contact_info.dart';
import 'package:gereh/pages/sabt_agahi/2_workerDetails/view/worker_details.dart';
import 'package:gereh/pages/sabt_agahi/6_insertToDatabase/p5_inser_to_database.dart';
import 'package:gereh/services/database.dart';
import '../controller/request_controller.dart';

class MainRequestPage extends StatefulWidget {
  const MainRequestPage({Key? key}) : super(key: key);

  @override
  State<MainRequestPage> createState() => _MainRequestPageState();
}

class _MainRequestPageState extends State<MainRequestPage> {
  final controller = Get.put(RequestController());
  final titleController = Get.put(TitleController());
  final adFeauturesController = Get.put(AdFeauturesController());
  final workerDetailsController = Get.put(WorkerDetailsController());
  final contactInfoController = Get.put(ContactInfoController());
  final otherFeauturesController = Get.put(OtherFeauturesController());

  final box = GetStorage();

  // late Animation animation;

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
                TitlePageState titlestate = titleController.validateTitlePage();
                titlestate == TitlePageState.estekhdam
                    ? controller.activeStep.value++
                    : titlestate == TitlePageState.tabligh
                        ? controller.activeStep.value = 2
                        : false;
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
                onClick: () => workerDetailsController.validateWorkerDeatails(),
                child: const Icon(Iconsax.arrow_left_1, color: Colors.white),
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
                elevation: 0,
                fillColor: Colors.grey.withOpacity(0.4),
                child: const Icon(Iconsax.arrow_right_4),
                onClick: () {
                  // برگشت به صفحه اول درصورتی که گزینه تبلیغ رو انتخاب کرده باشه
                  titleController.adType.value == 0
                      ? controller.activeStep.value--
                      : controller.activeStep.value = 0;
                },
              ),
              MyButton(
                fillColor: MyColors.red,
                onClick: () {
                  if (adFeauturesController.descriptionsTEC.value.text
                          .trim()
                          .isEmpty ||
                      adFeauturesController.descriptionsTEC.value.text
                              .trim()
                              .length <
                          15) {
                    adFeauturesController.descriptionsError.value =
                        'لطفا توضیحات آگهی را وارد کنید.';
                  } else {
                    controller.activeStep.value++;
                  }
                },
                child: const Icon(Iconsax.arrow_left_1, color: Colors.white),
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
                elevation: 0,
                child: const Icon(Iconsax.arrow_right_4),
                onClick: () {
                  titleController.adType.value == 0
                      ? controller.activeStep.value--
                      : controller.activeStep.value = 0;
                },
              ),
              MyButton(
                fillColor: MyColors.red,
                child: const Icon(Iconsax.arrow_left_1, color: Colors.white),
                onClick: () {
                  otherFeauturesController.validateOtherFuturesPage();

                  // controller.activeStep.value++;
                },
              )
            ],
          ),
        );
      case 4:
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
                  contactInfoController.validateContactInfos();
                },
              )
            ],
          ),
        );
      case 5:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
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
          padding: const EdgeInsets.symmetric(horizontal: 15),
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
                onClick: () => setState(() {
                  if (controller.activeStep.value <= 4) {
                    controller.activeStep.value++;
                  }
                }),
                child: const Icon(Iconsax.arrow_left_1, color: Colors.white),
              )
            ],
          ),
        );
    }
  }

//ذخیره تبلیغ در دیتابیس
  insertAdToDb() async {
    // گرفتن لیست مزایا و انکود کردن برای ذخیره در دیتابیس
    List<String> mazaya = [];
    for (var element in adFeauturesController.mazayaTEC) {
      mazaya.add(element.text.toString());
    }
    var mazayajson = jsonEncode(mazaya);
    // گرفتن لیست شرایط
    List<String> sharayets = [];
    for (var element in adFeauturesController.sharayetTEC) {
      sharayets.add(element.text.toString());
    }
    var sharayetJson = jsonEncode(sharayets);
    try {
      var response = await dataBase.addNewAD(
        mazaya: mazayajson,
        sharayet: sharayetJson,
        advertizerid: box.read('id').toString(),
        adtype: titleController.adType.value.toString(),
        title: titleController.titleTEC.value.text.trim(),
        category: titleController.categoryTEC.value.text,
        city: titleController.cityTEC.value.text,
        descs: adFeauturesController.descriptionsTEC.value.text.trim(),
        gender: workerDetailsController.genderTEC.value.text,
        workType: workerDetailsController.cooperationTypeTEC.value.text,
        workTime: workerDetailsController.workTimeTEC.value.text,
        payMethod: workerDetailsController.payMethodTEC.value.text,
        profission: workerDetailsController.skillTEC.value.text,
        price: workerDetailsController.priceTEC.value.text,
        resumeBool: otherFeauturesController.resumeBool.value ? '1' : '0',
        callBool: contactInfoController.phoneBool.value ? '1' : '0',
        callNumber: contactInfoController.phoneTEC.value.text,
        smsBool: contactInfoController.smsBool.value ? '1' : '0',
        smsNumber: contactInfoController.smsTEC.value.text,
        chatBool: contactInfoController.chatBool.value ? '1' : '0',
        emailBool: contactInfoController.emailBool.value ? '1' : '0',
        emailAddress: contactInfoController.emailTEC.value.text,
        websiteBool: contactInfoController.websiteBool.value ? '1' : '0',
        websiteAddress: contactInfoController.websiteTEC.value.text,
        instagramBool: contactInfoController.instagramBool.value ? '1' : '0',
        instagramId: contactInfoController.instagramIdTEC.value.text,
        telegramBool: contactInfoController.telegramBool.value ? '1' : '0',
        telegramId: contactInfoController.telegramIdTEC.value.text,
        whatsappBool: contactInfoController.whatsappBool.value ? '1' : '0',
        whatsappNumber: contactInfoController.whatsappTEC.value.text,
        locationbool: otherFeauturesController.locationBool.value ? '1' : '0',
        locationlat: otherFeauturesController.selectedLat.value.toString(),
        locationlon: otherFeauturesController.selectedLon.value.toString(),
        address: otherFeauturesController.address.value.trim().toString(),
      );
      print(response);
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
    } catch (e) {
      print(e);
      e.printError();
    }
  }

//آیکان های استپر
  IconStepper buildIconStepper() {
    return IconStepper(
      enableStepTapping: false,
      enableNextPreviousButtons: false,
      stepReachedAnimationDuration: const Duration(milliseconds: 800),
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
          controller.activeStep.value == 1 ? Iconsax.book5 : Iconsax.book,
          color: controller.activeStep.value == 1 ? MyColors.red : Colors.grey,
        ),
        Icon(
          controller.activeStep.value == 2 ? Iconsax.people5 : Iconsax.people,
          color: controller.activeStep.value == 2 ? MyColors.red : Colors.grey,
        ),

        // contact info page icon
        Icon(
          controller.activeStep.value == 3
              ? Iconsax.call_calling5
              : Iconsax.call,
          color: controller.activeStep.value == 3 ? MyColors.red : Colors.grey,
        ),
        // other futures page icon
        Icon(
          controller.activeStep.value == 4
              ? Iconsax.more_circle5
              : Iconsax.more_circle,
          color: controller.activeStep.value == 4 ? MyColors.red : Colors.grey,
        ),
        // insert page icon
        Icon(
          controller.activeStep.value == 5
              ? Iconsax.tick_square5
              : Iconsax.tick_square,
          color: controller.activeStep.value == 5 ? MyColors.red : Colors.grey,
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
        return const AdFeautures();
      case 3:
        return const OtherFutures();
      case 4:
        return ContactInfo();
      case 5:
        return const InsertToDataBase();
      default:
        return const TitlePage();
    }
  }
}
