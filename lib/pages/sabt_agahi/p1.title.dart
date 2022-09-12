import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sarkargar/components/my.toggle.switch.dart';
import 'package:sarkargar/components/select.category.dart';
import 'package:sarkargar/components/select.city.dart';
import 'package:sarkargar/components/selectable.text.field.dart';
import 'package:sarkargar/components/text.field.dart';
import 'package:sarkargar/services/uiDesign.dart';
import 'package:sarkargar/services/database.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../../constants/colors.dart';
import '../../controllers/request_controller.dart';

class TitlePage extends StatefulWidget {
  const TitlePage({Key? key}) : super(key: key);

  @override
  State<TitlePage> createState() => _TitlePageState();
}

class _TitlePageState extends State<TitlePage> {
  final controller = Get.put(RequestController());
  final box = GetStorage();
  late FocusNode focusNode;
  UiDesign uiDesign = UiDesign();
  final dataBase = AppDataBase();

  TextEditingController titleTEC = TextEditingController();
  TextEditingController descriptionsTEC = TextEditingController();
  TextEditingController categoryTEC = TextEditingController();
  TextEditingController cityTEC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
            child: Text('|   نوع آگهی   |', style: uiDesign.titleTextStyle())),
        const SizedBox(height: 5),
        Center(
          child: Obx(
            () {
              return MyToggleSwitch(
                initialLableIndex: controller.adType.value,
                labels: const ['استخدام نیرو', 'تبلیغ کسب و کار'],
                totalSwitch: 2,
                onToggle: (index) => controller.adType.value = index ?? 0,
              );
            },
          ),
        ),

        const SizedBox(height: 20),

        Obx(
          () => Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (controller.images.isEmpty)
                InkWell(
                  onTap: () => dataBase.uploadImage(),
                  child: Container(
                      width: 85,
                      height: 85,
                      decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(10)),
                      child: const Icon(
                        Iconsax.gallery_add,
                        size: 35,
                      )),
                )
              else
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    width: 85,
                    height: 85,
                    child: CachedNetworkImage(
                        imageUrl: controller.images[0], fit: BoxFit.cover),
                  ),
                ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(' تصویر شاخص', style: uiDesign.titleTextStyle()),
                    Text('   این تصور در لیست آگهی ها نمایش داده خواهد شد.',
                        style: uiDesign.descriptionsTextStyle()),
                    Text('   (با نگه داشتن روی تصویر می توانید آن را حذف کنید)',
                        style: uiDesign.descriptionsTextStyle())
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Text('|عنوان آگهی', style: uiDesign.titleTextStyle()),
        Text('   توضیح مختصری از آگهی خود را وارد کنید.',
            style: uiDesign.descriptionsTextStyle()),
        const SizedBox(height: 5),

        //تکست فیلد وارد کردن عنوان آگهی
        Obx(
          () => MyTextField(
            error: controller.titleError.value.isEmpty
                ? null
                : controller.titleError.value,
            labeltext: 'عنوان',
            icon: const Icon(Iconsax.subtitle),
            control: titleTEC,
            hint: 'عنوان درخواست خود را وارد کنید',
            onChange: (value) {
              controller.title.value = value;
              controller.titleError.value = '';
            },
          ),
        ),
        const SizedBox(height: 15),
        Text('|دسته بندی ', style: uiDesign.titleTextStyle()),
        Text('   انتخاب دسته بندی صحیح بازدید آگهی شما را افزایش خواهد داد.',
            style: uiDesign.descriptionsTextStyle()),
        const SizedBox(height: 5),

        Obx(
          () => MySelectableTextField(
              error: controller.categoryError.isEmpty
                  ? null
                  : controller.categoryError.value,
              control: categoryTEC,
              icon: const Icon(Iconsax.category_2),
              labeltext: 'یک دسته بندی انتخاب کنید',
              onClick: () {
                focusNode.unfocus();
                Get.to(() => SelectCategory())?.then((value) {
                  controller.selectedCategory.value = value;
                  setState(() {
                    categoryTEC.text = value;
                  });
                });
              }),
        ),

        const SizedBox(height: 15),
        Text('|شهر محل آگهی ', style: uiDesign.titleTextStyle()),
        Text('   آگهی شما در لیست آگهی های کدام شهر نمایش داده شود؟',
            style: uiDesign.descriptionsTextStyle()),
        const SizedBox(height: 5),

        Obx(
          () => MySelectableTextField(
              error: controller.cityError.isEmpty
                  ? null
                  : controller.cityError.value,
              control: cityTEC,
              icon: const Icon(Iconsax.building_3),
              labeltext: 'شهر خود را انتخاب کنید.',
              onClick: () {
                focusNode.unfocus();
                Get.to(() => SelectCity(isFirstTime: false))
                    ?.then((value) => setState(() {
                          cityTEC.text = controller.selectedCity.value;
                        }));
              }),
        ),

        const SizedBox(height: 15),
        Text('|توضیحات', style: uiDesign.titleTextStyle()),
        Text(
          '   سعی کنید شرح کاملی از درخواست خود را وارد کنید تا هیچ ابهامی باقی نماند، این مورد می تواند شانس استخدام نیرو و جذب مشتری را افزایش دهد.',
          style: uiDesign.descriptionsTextStyle(),
        ),
        const SizedBox(height: 5),
        Obx(
          () => MyTextField(
              error: controller.descriptionsError.isEmpty
                  ? null
                  : controller.descriptionsError.value,
              textInputType: TextInputType.multiline,
              control: descriptionsTEC,
              minLine: 5,
              maxLine: 10,
              icon: const Icon(Iconsax.textalign_justifyright),
              length: 400,
              hint: 'توضیحات کامل آگهی خود را اینجا وارد کنید',
              onChange: (value) {
                controller.descriptions.value = value;
                controller.descriptionsError.value = '';
              },
              labeltext: 'توضیحات آگهی '),
        ),
      ],
    );
  }

  @override
  // ignore: must_call_super
  void initState() {
    dataBase.getImages();
    focusNode = FocusNode();
    titleTEC.text = controller.title.value;
    categoryTEC.text = controller.selectedCategory.value;
    descriptionsTEC.text = controller.descriptions.value;
    cityTEC.text = controller.selectedCity.value;
  }

  @override
  void dispose() {
    focusNode.dispose();

    super.dispose();
  }
}
