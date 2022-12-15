import 'package:flutter/material.dart';
import 'package:gereh/components/buttons/my_button.dart';
import 'package:gereh/components/textFields/text.field.dart';
import 'package:gereh/constants/my_colors.dart';
import 'package:gereh/constants/my_text_styles.dart';
import 'package:gereh/pages/sabt_agahi/controller/request_controller.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class AdFeautures extends GetView<RequestController> {
  const AdFeautures({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'شرایط احراز',
            style: MyTextStyles.titleTextStyle(Colors.black),
          ),
        ),
        Flexible(
          child: Obx(
            () => ListView.builder(
              shrinkWrap: true,
              itemCount: controller.sharayetTEC.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    _SharayetRow(
                      label: 'سن، مدرک تحصیلی، سابقه کار و ...',
                      control: controller.sharayetTEC[index],
                      focusNode: controller.sharayetFocus[index],
                      onclick: () {
                        if (controller.sharayetTEC.length != 1) {
                          controller.sharayetFocus[index].unfocus();
                          controller.sharayetFocus.removeAt(index);
                          controller.sharayetTEC.removeAt(index);
                        } else {
                          controller.sharayetTEC.first.clear();
                          controller.sharayetFocus.first.unfocus();
                        }
                      },
                    ),
                    const SizedBox(height: 5),
                  ],
                );
              },
            ),
          ),
        ),
        _AddButton(
          onTap: () => controller.addSharayetTextField(),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'تسهیلات و مزایا',
            style: MyTextStyles.titleTextStyle(Colors.black),
          ),
        ),
        Flexible(
          child: Obx(
            () => ListView.builder(
              shrinkWrap: true,
              itemCount: controller.mazayaTEC.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    _SharayetRow(
                      label: 'پورسانت، صبحانه، بیمه و ...',
                      control: controller.mazayaTEC[index],
                      focusNode: controller.mazayaFocus[index],
                      onclick: () {
                        if (controller.mazayaTEC.length != 1) {
                          controller.mazayaFocus[index].unfocus();
                          controller.mazayaFocus.removeAt(index);
                          controller.mazayaTEC.removeAt(index);
                        } else {
                          controller.mazayaTEC.first.clear();
                          controller.mazayaFocus.first.unfocus();
                        }
                      },
                    ),
                    const SizedBox(height: 5),
                  ],
                );
              },
            ),
          ),
        ),
        _AddButton(
          onTap: () => controller.addMazayaTextField(),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'توضیحات',
            style: MyTextStyles.titleTextStyle(Colors.black),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: SizedBox(
            height: 300,
            child: Obx(
              () => MyTextField(
                onChange: (value) {
                  controller.descriptionsError.value = '';
                },
                error: controller.descriptionsError.isEmpty
                    ? null
                    : controller.descriptionsError.value,
                textAlignVertical: TextAlignVertical.top,
                labeltext: '',
                control: controller.descriptionsTEC.value,
                length: 1000,
                textInputAction: TextInputAction.newline,
                textInputType: TextInputType.multiline,
                expands: true,
              ),
            ),
          ),
        )
      ],
    );
  }
}

class _AddButton extends StatelessWidget {
  const _AddButton({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MyButton(
        fillColor: MyColors.blue.withOpacity(0.5),
        elevation: 0,
        radius: 5,
        width: MediaQuery.of(context).size.width,
        onClick: onTap,
        child: const Icon(
          Iconsax.add,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _SharayetRow extends StatelessWidget {
  const _SharayetRow({
    Key? key,
    this.control,
    this.focusNode,
    this.onclick,
    required this.label,
  }) : super(key: key);
  final TextEditingController? control;
  final void Function()? onclick;
  final FocusNode? focusNode;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 10),
        Container(
          width: 10,
          height: 10,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black54,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
            child: MyTextField(
          labeltext: label,
          control: control!,
          focusNode: focusNode,
        )),
        InkWell(
            onTap: onclick,
            borderRadius: BorderRadius.circular(50),
            child: const Padding(
              padding: EdgeInsets.all(10.0),
              child: Icon(Iconsax.close_circle),
            )),
      ],
    );
  }
}
