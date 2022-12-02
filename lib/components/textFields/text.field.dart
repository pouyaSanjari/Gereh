import 'package:flutter/material.dart';

import '../../constants/my_colors.dart';

class MyTextField extends StatelessWidget {
  final String labeltext;
  final Color? backgroundColor;
  final Color? borderColor;

  final Widget? icon;
  final Widget? suffix;
  final TextEditingController control;
  final String? hint;
  final String? error;
  final int? minLine;
  final int? length;
  final int? maxLine;
  final double? height;
  final bool? enabled;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;
  final TextAlign? textAlign;
  final ValueChanged<String>? onSubmit;
  final ValueChanged<String>? onChange;
  const MyTextField(
      {Key? key,
      required this.labeltext,
      required this.control,
      this.icon,
      this.hint,
      this.minLine,
      this.error,
      this.length,
      this.textInputType,
      this.maxLine,
      this.enabled,
      this.suffix,
      this.onSubmit,
      this.textAlign,
      this.textInputAction,
      this.onChange,
      this.backgroundColor,
      this.borderColor,
      this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double radius = 12;
    return SizedBox(
      height: height ?? 50,
      child: TextField(
        textInputAction: textInputAction,
        onSubmitted: onSubmit,
        onChanged: onChange,
        enabled: enabled,
        controller: control,
        textAlign: textAlign ?? TextAlign.start,
        onTap: () {
          if (control.selection ==
              TextSelection.fromPosition(
                  TextPosition(offset: control.text.length - 1))) {
            control.selection = TextSelection.fromPosition(
                TextPosition(offset: control.text.length));
          }
        },
        maxLength: length ?? 30,
        keyboardType: textInputType ?? TextInputType.text,
        minLines: minLine,
        maxLines: maxLine ?? 1,
        decoration: InputDecoration(
          fillColor: backgroundColor ?? Colors.brown.withOpacity(0.1),
          filled: true,
          errorText: error,
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: MyColors.red),
            borderRadius: BorderRadius.all(
              Radius.circular(radius),
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: MyColors.red),
            borderRadius: BorderRadius.all(
              Radius.circular(radius),
            ),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
          suffixIcon: suffix,

          //  control.text.isEmpty ? null : suffix,
          counterText: '',
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor ?? Colors.transparent),
            borderRadius: BorderRadius.all(
              Radius.circular(radius),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor ?? Colors.transparent),
            borderRadius: BorderRadius.all(
              Radius.circular(radius),
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.all(
              Radius.circular(radius),
            ),
          ),
          hintText: hint,
          prefixIcon: icon,
          labelText: labeltext,
          labelStyle: const TextStyle(
            color: Colors.black38,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.never,
        ),
      ),
    );
  }
}
