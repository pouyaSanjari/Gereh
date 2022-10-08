import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class MyTextField extends StatelessWidget {
  final String labeltext;
  final Widget? icon;
  final TextEditingController control;
  final String? hint;
  final int? minLine;
  final String? error;
  final int? length;
  final TextInputType? textInputType;
  final int? maxLine;
  final bool? enabled;
  final Widget? suffix;
  final TextAlign? textAlign;
  final ValueChanged<String>? onSubmit;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChange;
  const MyTextField(
      {Key? key,
      required this.labeltext,
      this.icon,
      required this.control,
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
      this.onChange})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double radius = 12;
    return TextField(
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
        fillColor: Colors.brown.withOpacity(0.1),
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
        suffixIcon: suffix,

        //  control.text.isEmpty ? null : suffix,
        counterText: '',
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.all(
            Radius.circular(radius),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent),
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
    );
  }
}
