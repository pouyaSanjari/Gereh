import 'package:flutter/material.dart';
import 'package:sarkargar/constants/colors.dart';

class MyButton extends StatelessWidget {
  final String? text;
  final VoidCallback? onClick;
  final Color? fillColor;
  final Widget? icon;
  final Color? borderColor;
  final bool? enable;
  final double? width;
  final double? height;
  const MyButton(
      {Key? key,
      this.text,
      this.onClick,
      this.fillColor,
      this.icon,
      this.borderColor,
      this.enable,
      this.width,
      this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: onClick,
      focusElevation: 0,
      hoverElevation: 0,
      constraints:
          BoxConstraints(minWidth: width ?? 80, minHeight: height ?? 40),
      highlightElevation: 0,
      fillColor: fillColor ?? MyColors.red,
      elevation: 2,
      shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(50)),
          side: BorderSide(color: borderColor ?? Colors.transparent)),
      child: icon ??
          Text(
            text ?? 'Button',
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
    );
  }
}
