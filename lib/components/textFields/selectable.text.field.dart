import 'package:flutter/material.dart';

import '../../constants/my_colors.dart';

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
    double radius = 12;
    return TextField(
      readOnly: true,
      controller: control,
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.start,
      onTap: onClick,
      decoration: InputDecoration(
        alignLabelWithHint: true,
        errorText: error,
        fillColor: Colors.brown.withOpacity(0.1),
        filled: true,
        focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: MyColors.red),
            borderRadius: BorderRadius.all(Radius.circular(radius))),
        errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: MyColors.red),
            borderRadius: BorderRadius.all(Radius.circular(radius))),
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
        counterText: '',
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.all(Radius.circular(radius))),
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.all(Radius.circular(radius))),
        hintText: hint,
        prefixIcon: icon,
        labelText: labeltext,
        labelStyle: const TextStyle(
          color: Colors.black38,
        ),
        suffixIcon: const Icon(
          Icons.arrow_drop_down_rounded,
          size: 35,
          color: Colors.grey,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.never,
      ),
    );
  }
}
