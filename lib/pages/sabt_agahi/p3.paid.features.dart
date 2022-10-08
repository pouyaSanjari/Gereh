import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:sarkargar/components/buttons/button.dart';
import 'package:sarkargar/components/error.page.dart';
import 'package:sarkargar/components/switch.dart';
import 'package:sarkargar/components/textFields/text.field.dart';
import 'package:sarkargar/controllers/p3.paid.futures.controller.dart';
import 'package:sarkargar/services/database.dart';
import 'package:sarkargar/services/ui_design.dart';
import '../../constants/colors.dart';
import '../../controllers/request_controller.dart';
import 'map.dart';

class PaidFeatures extends StatefulWidget {
  const PaidFeatures({Key? key}) : super(key: key);

  @override
  State<PaidFeatures> createState() => _PaidFeaturesState();
}

class _PaidFeaturesState extends State<PaidFeatures> {
  final box = GetStorage();
  final controller = Get.put(RequestController());
  final pageController = Get.put(PaidFuturesController());
  final database = AppDataBase();
  final uiDesign = UiDesign();
  final picker = ImagePicker();

  List<String> uploadedImages = [];
  List snap = [];

  String address = '';

  @override
  Widget build(BuildContext context) {
    snap = controller.images;
    return SingleChildScrollView(
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerRight,
            child: Text('راه های ارتباطی',
                style: TextStyle(fontFamily: 'titr', fontSize: 30)),
          ),
          // call
          listTiles(
              onTap: () => pageController.callState(),
              leading: Iconsax.call,
              iconColor: Colors.black,
              title: 'تماس',
              switc: Obx(
                () => MySwitch(
                    val: controller.phoneBool.value,
                    onChange: (value) {
                      pageController.callState();
                    }),
              ),
              sub: 'کاربران می توانند مستقیما با شما تماس بگیرند.'),
          Obx(
            () => MyAnimatedWidget(
                state: controller.phoneBool.value,
                child: MyTextField(
                    textAlign: TextAlign.center,
                    hint: '...0921',
                    textInputType: TextInputType.phone,
                    labeltext: 'شماره تلفن همراه یا ثابت',
                    control: controller.phoneNumberTEC.value)),
          ),
          // sms
          listTiles(
              onTap: () => pageController.smsState(),
              leading: Iconsax.sms,
              iconColor: MyColors.black,
              title: 'پیامک',
              switc: Obx(
                () => MySwitch(
                    val: controller.smsBool.value,
                    onChange: (value) {
                      pageController.smsState();
                    }),
              ),
              sub: 'کاربران می توانند به خط شما پیامک ارسال کنند.'),
          Obx(
            () => MyAnimatedWidget(
                state: controller.smsBool.value,
                child: MyTextField(
                  textAlign: TextAlign.center,
                  hint: '...0921',
                  textInputType: TextInputType.phone,
                  labeltext: 'شماره تلفن همراه یا ثابت',
                  control: controller.smsNumberTEC.value,
                )),
          ),
          // chat
          listTiles(
              onTap: () => pageController.chatState(),
              leading: Iconsax.sms_tracking,
              iconColor: Colors.black,
              title: 'چت',
              switc: Obx(
                () => MySwitch(
                    val: controller.chatBool.value,
                    onChange: (value) {
                      pageController.chatState();
                    }),
              ),
              sub:
                  'کاربران می توانند از طریق چت درون برنامه ای با شما ارتباط برقرار کنند.'),
          // email
          listTiles(
              onTap: () =>
                  controller.emailBool.value = !controller.emailBool.value,
              leading: Icons.email,
              iconColor: MyColors.black,
              title: 'ایمیل',
              switc: Obx(
                () => MySwitch(
                    val: controller.emailBool.value,
                    onChange: (value) {
                      controller.emailBool.value = value;
                    }),
              ),
              sub: 'کاربران می توانند به خط شما پیامک ارسال کنند.'),
          Obx(
            () => MyAnimatedWidget(
                state: controller.emailBool.value,
                child: MyTextField(
                  textAlign: TextAlign.left,
                  hint: 'example@gmail.com',
                  textInputType: TextInputType.emailAddress,
                  labeltext: 'آدرس ایمیل',
                  control: controller.emailAddressTEC.value,
                )),
          ),
          // website
          listTiles(
              onTap: () =>
                  controller.websiteBool.value = !controller.websiteBool.value,
              leading: Iconsax.global,
              iconColor: MyColors.black,
              title: 'وبسایت',
              switc: Obx(
                () => MySwitch(
                    val: controller.websiteBool.value,
                    onChange: (value) {
                      controller.websiteBool.value = value;
                    }),
              ),
              sub: 'هدایت کاربران به صفحه سایت مورد نظر شما'),
          Obx(
            () => MyAnimatedWidget(
                state: controller.websiteBool.value,
                child: MyTextField(
                  textAlign: TextAlign.left,
                  hint: 'example.com',
                  textInputType: TextInputType.emailAddress,
                  labeltext: 'آدرس صفحه وب مورد نظر',
                  control: controller.websiteTEC.value,
                )),
          ),
          // whatsApp
          listTiles(
              onTap: () => controller.whatsappBool.value =
                  !controller.whatsappBool.value,
              leading: FontAwesomeIcons.whatsapp,
              iconColor: controller.whatsappBool.value
                  ? MyColors.green
                  : MyColors.black,
              title: 'واتس اپ',
              switc: Obx(
                () => MySwitch(
                  val: controller.whatsappBool.value,
                  onChange: (value) {
                    controller.whatsappBool.value = value;
                  },
                ),
              ),
              sub: 'هدایت کاربران به صفحه گفتگو در واتس اپ'),
          Obx(
            () => MyAnimatedWidget(
                state: controller.whatsappBool.value,
                child: MyTextField(
                  textAlign: TextAlign.left,
                  hint: '09210000000',
                  textInputType: TextInputType.phone,
                  labeltext: 'شماره تلفن اکانت واتس اپ',
                  control: controller.whatsappNumberTEC.value,
                )),
          ),
          // telegram
          listTiles(
              onTap: () => controller.telegramBool.value =
                  !controller.telegramBool.value,
              leading: FontAwesomeIcons.telegram,
              iconColor: controller.telegramBool.value
                  ? MyColors.blue
                  : MyColors.black,
              title: 'تلگرام',
              switc: Obx(
                () => MySwitch(
                    val: controller.telegramBool.value,
                    onChange: (value) {
                      controller.telegramBool.value = value;
                    }),
              ),
              sub: 'هدایت کاربران به صفحه گفتگو در تلگرام'),
          Obx(
            () => MyAnimatedWidget(
                state: controller.telegramBool.value,
                child: MyTextField(
                  textAlign: TextAlign.left,
                  hint: 'مثال: gereh',
                  textInputType: TextInputType.emailAddress,
                  labeltext: 'آی دی اکانت تلگرام بدون @',
                  control: controller.telegramIdTEC.value,
                )),
          ),
          // instagram
          listTiles(
              onTap: () => controller.instagramIdBool.value =
                  !controller.instagramIdBool.value,
              leading: Iconsax.instagram,
              iconColor: controller.instagramIdBool.value
                  ? MyColors.red
                  : Colors.black,
              title: 'اینستاگرام',
              switc: Obx(
                () => MySwitch(
                    val: controller.instagramIdBool.value,
                    onChange: (value) {
                      controller.instagramIdBool.value = value;
                    }),
              ),
              sub:
                  'کابران به راحتی می توانند صفحه اینستاگرام شما را مشاهده کنند.'),
          Obx(
            () => MyAnimatedWidget(
                state: controller.instagramIdBool.value,
                child: MyTextField(
                  textAlign: TextAlign.end,
                  length: 30,
                  hint: 'بدون @',
                  error: controller.selectedInstagramIdError.value == ''
                      ? null
                      : controller.selectedInstagramIdError.value,
                  labeltext: 'آیدی اینستاگرام خود را وارد کنید.',
                  control: controller.instagramIdTEC.value,
                  onChange: (value) {
                    if (controller.instagramIdTEC.value.text
                        .contains(RegExp(r'[@#$&-+()?!;:*+%-]'))) {
                      controller.selectedInstagramIdError.value =
                          'کاراکتر غیر مجاز!';
                    } else {
                      controller.selectedInstagramIdError.value = '';
                    }
                  },
                )),
          ),
          const SizedBox(height: 30),

          const Align(
            alignment: Alignment.centerRight,
            child: Text(
              'سایر ویژگی های آگهی',
              style: TextStyle(fontFamily: 'titr', fontSize: 30),
            ),
          ),
          // image
          listTiles(
              onTap: () => controller.imageSelectionBool.value =
                  !controller.imageSelectionBool.value,
              leading: Iconsax.gallery,
              iconColor: Colors.black,
              title: 'تصویر',
              switc: Obx(
                () => MySwitch(
                    val: controller.imageSelectionBool.value,
                    onChange: (value) {
                      controller.imageSelectionBool.value = value;
                    }),
              ),
              sub:
                  'افزودن تصویر به آگهی موجب تعامل بیشتر کاربران با آگهی شما خواهد شد.'),
          //###########################################################################################
          Obx(
            () => AnimatedSize(
              curve: Curves.fastLinearToSlowEaseIn,
              duration: const Duration(milliseconds: 1500),
              child: SizedBox(
                height: controller.imageSelectionBool.value ? 280 : 0,
                child: Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FutureBuilder(
                            future: database.paidFeautersImages(uploadedImages),
                            builder: (BuildContext context,
                                AsyncSnapshot<dynamic> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: Lottie.asset(
                                      'assets/lottie/loading.json',
                                      width: 80,
                                      height: 80),
                                );
                              }
                              if (snapshot.hasData) {
                                snap = snapshot.data;
                              }
                              if (snapshot.data == null) {
                                return MyErrorPage(referesh: () {
                                  database.paidFeautersImages(uploadedImages);
                                });
                              }

                              if (snapshot.data.isEmpty) {
                                return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'تصویری موجود نیست می توانید با دکمه پایین یکی اضافه کنید.',
                                        style: uiDesign.titleTextStyle(),
                                        textAlign: TextAlign.center,
                                      ),
                                      MyButton(
                                        fillColor: Colors.green,
                                        child: const Text(
                                            '     افزودن تصویر     '),
                                        onClick: () => database.uploadImage(),
                                      )
                                    ],
                                  ),
                                );
                              }

                              return GridView.builder(
                                physics: const BouncingScrollPhysics(),
                                itemCount: 8,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 4,
                                        mainAxisSpacing: 10,
                                        crossAxisSpacing: 10),
                                itemBuilder: (context, int index) {
                                  if (snap.length < index + 1) {
                                    return InkResponse(
                                      onTap: () => database.uploadImage(),
                                      child: Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: const Icon(
                                            Iconsax.gallery_add,
                                            size: 35,
                                          )),
                                    );
                                  } else {
                                    return InkResponse(
                                      onLongPress: () {
                                        //حذف تصویر انتخاب شده
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: const Center(
                                                child: Text('تصویر حذف شود؟')),
                                            content: const Directionality(
                                              textDirection: TextDirection.rtl,
                                              child: Text(
                                                  'آیا مطمئن هستید که میخواهید این تصویر را حذف کنید؟ در صورت تایید امکان بازیابی تصویر وجود ندارد.'),
                                            ),
                                            actions: [
                                              TextButton(
                                                  onPressed: () async {
                                                    await database.deleteImage(
                                                        snap[index]['id']);
                                                    if (!mounted) return;
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text(
                                                    "حذف",
                                                    style: TextStyle(
                                                        color:
                                                            Colors.redAccent),
                                                  )),
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text("لغو"))
                                            ],
                                          ),
                                        );
                                      },
                                      onTap: () {
                                        showDialog(
                                          useSafeArea: false,
                                          context: context,
                                          builder: (context) => Dialog(
                                            insetPadding:
                                                const EdgeInsets.all(0),
                                            backgroundColor: Colors.black,
                                            child: Container(
                                              color: MyColors.black,
                                              child: Column(
                                                children: [
                                                  Expanded(
                                                    child: CachedNetworkImage(
                                                      imageUrl: snap[index]
                                                          ['image'],
                                                    ),
                                                  ),
                                                  IconButton(
                                                      splashColor: Colors.white,
                                                      icon: const Icon(
                                                          Icons.arrow_back,
                                                          color: Colors.white,
                                                          size: 30),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      }),
                                                  const SizedBox(height: 20)
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: CachedNetworkImage(
                                          imageUrl: snap[index]['image'],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    );
                                  }
                                },
                              );
                            }),
                      ),
                    ),
                    const Text(
                        '(با نگه داشتن روی تصویر می توانید آن را حذف کنید)')
                  ],
                ),
              ),
            ),
          ),
          //###########################################################################################
          // location
          listTiles(
              onTap: () => controller.locationSelectionBool.value =
                  !controller.locationSelectionBool.value,
              leading: Iconsax.map_1,
              iconColor: Colors.black,
              title: 'نمایش مکان روی نقشه',
              switc: Obx(
                () => MySwitch(
                    val: controller.locationSelectionBool.value,
                    onChange: (value) {
                      controller.locationSelectionBool.value = value;
                    }),
              ),
              sub: 'آگهی شما بر روی نقشه نمایش داده خواهد شد'),
          Obx(
            () => MyAnimatedWidget(
                state: controller.locationSelectionBool.value,
                child: MyButton(
                  fillColor: MyColors.blueGrey,
                  child: const Text(
                    'انتخاب موقعیت از روی نقشه',
                    style: TextStyle(color: Colors.white),
                  ),
                  onClick: () => Get.to(() => const MapPage())
                      ?.then((value) => address = value[0]),
                )),
          )
        ],
      ),
    );
  }

  ListTile listTiles(
      {void Function()? onTap,
      required IconData leading,
      required Color iconColor,
      required String title,
      required Widget switc,
      required String sub}) {
    return ListTile(
      onTap: onTap,
      minLeadingWidth: 5,
      leading: Icon(leading, color: iconColor),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: uiDesign.titleTextStyle()),
          switc,
        ],
      ),
      subtitle: Text(sub, style: uiDesign.descriptionsTextStyle()),
      contentPadding: EdgeInsets.zero,
    );
  }
}

class MyAnimatedWidget extends StatelessWidget {
  final bool state;
  final Widget child;
  const MyAnimatedWidget({
    Key? key,
    required this.state,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      curve: Curves.fastLinearToSlowEaseIn,
      opacity: state ? 1 : 0,
      duration: const Duration(milliseconds: 1500),
      child: AnimatedSize(
        curve: Curves.fastLinearToSlowEaseIn,
        duration: const Duration(milliseconds: 1500),
        child: SizedBox(
          height: state ? 50 : 0,
          child: child,
        ),
      ),
    );
  }
}
