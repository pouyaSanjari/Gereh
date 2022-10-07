import 'package:digit_to_persian_word/digit_to_persian_word.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax/iconsax.dart';
import 'package:im_stepper/stepper.dart';
import 'package:lottie/lottie.dart';
import 'package:sarkargar/components/buttons/button.dart';
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
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Obx(() => body()),
                              ),
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
                if (controller.adType.value == 2) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: MyColors.notWhite,
                    content: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Row(
                        children: const [
                          Expanded(
                            child: Text(
                              'لطفا نوع آگهی خود را انتخاب کنید',
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'sans',
                                color: MyColors.red,
                              ),
                            ),
                          ),
                          Icon(
                            Iconsax.danger,
                            color: MyColors.red,
                            size: 30,
                          ),
                        ],
                      ),
                    ),
                    duration: const Duration(seconds: 3),
                  ));
                } else if (controller.title.trim().isEmpty) {
                  controller.titleError.value = 'وارد کردن عنوان الزامی است.';
                } else if (controller.title.trim().length < 5) {
                  controller.titleError.value = 'حداقل 5 کاراکتر وارد کنید.';
                } else if (controller.category.trim().isEmpty) {
                  controller.categoryError.value = 'یک دسته بندی انتخاب کنید.';
                } else if (controller.desc.trim().isEmpty) {
                  controller.descriptionsError.value =
                      'واردکردن توضیحات آگهی الزامی است.';
                } else if (controller.desc.trim().length < 10) {
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
                onClick: () {
                  if (controller.selectGenderTEC.value.text == '') {}
                  controller.activeStep.value++;
                },
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
                // borderColor: Colors.black,
                elevation: 0,
                child: const Icon(Iconsax.arrow_right_4),
                onClick: () {
                  setState(() {
                    controller.adType.value == 0
                        ? controller.activeStep.value--
                        : controller.activeStep.value = 0;
                  });
                },
              ),
              MyButton(
                fillColor: MyColors.red,
                child: const Icon(Iconsax.arrow_left_1, color: Colors.white),
                onClick: () => controller.activeStep.value++,
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
                  child: const Text('ثبت'),
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
        advertizer: box.read('id').toString(),
        adtype: controller.adType.value.toString(),
        title: controller.title.value.trim(),
        category: controller.category.value,
        city: controller.city.value,
        descs: controller.desc.value.trim(),
        gender: controller.selectGenderTEC.value.text,
        workType: controller.selectCollaborationTypeTEC.value.text,
        workTime: controller.selectWorkTimeTEC.value.text,
        payMethod: controller.selectPayMethodTEC.value.text,
        profession: controller.skillTEC.value.text,
        price: controller.priceTEC.value.text,
        resumeBool: '',
        callBool: controller.phoneBool.value.toString(),
        callNumber: '',
        smsBool: controller.smsBool.value.toString(),
        smsNumber: '',
        chatBool: controller.chatBool.value.toString(),
        emailBool: '',
        emailAddress: '',
        websiteBool: '',
        websiteAddress: '',
        instagramBool: controller.instagramIdSelectionBool.value ? '1' : '0',
        instagramId: controller.instagramIdTEC.value.text,
        whatsappBool: '',
        whatsappNumber: '',
        photobool: controller.phoneBool.value.toString(),
        locationbool: controller.locationSelectionBool.value.toString(),
        locationlat: controller.selectedLat.value.toString(),
        locationlon: controller.selectedLon.value.toString(),
        address: controller.address.value.trim().toString());

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
      enableNextPreviousButtons: false,
      scrollingDisabled: true,
      stepRadius: 18,
      lineDotRadius: 1.4,
      activeStepColor: Colors.transparent,
      stepColor: Colors.transparent,
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
}
