import 'package:flutter/material.dart';

import '../constants/colors.dart';

class MyTextField extends StatelessWidget {
  final String labeltext;
  final Icon? icon;
  final TextEditingController control;
  final String? hint;
  final int? minLine;
  final String? error;
  final int? length;
  final TextInputType? textInputType;
  final int? maxLine;
  final bool? enabled;
  final Widget? suffix;
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
      this.textInputAction,
      this.onChange})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      textInputAction: textInputAction,
      onSubmitted: onSubmit,
      onChanged: onChange,
      enabled: enabled,
      controller: control,
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.right,
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
        errorText: error,
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.redAccent),
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.redAccent),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
        suffixIcon: control.text.isEmpty ? null : suffix,
        counterText: '',
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: MyColors.red),
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: MyColors.blueGrey),
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
        ),
        disabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
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
