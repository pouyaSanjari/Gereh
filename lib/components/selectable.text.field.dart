import 'package:flutter/material.dart';

import '../constants/colors.dart';

class MySelectableTextField extends StatelessWidget {
  final String labeltext;
  final GestureTapCallback? onClick;
  final TextEditingController? control;
  final Icon? icon;
  final String? error;
  final String? hint;
  const MySelectableTextField(
      {Key? key,
      required this.labeltext,
      this.onClick,
      this.control,
      this.icon,
      this.error,
      this.hint})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: true,
      controller: control,
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.start,
      onTap: onClick,
      decoration: InputDecoration(
        alignLabelWithHint: true,
        errorText: error,
        focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.redAccent),
            borderRadius: BorderRadius.all(Radius.circular(30))),
        errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.redAccent),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
        counterText: '',
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
            borderRadius: BorderRadius.all(Radius.circular(30))),
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: MyColors.blue),
            borderRadius: BorderRadius.all(Radius.circular(20))),
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
