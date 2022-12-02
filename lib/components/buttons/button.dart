import 'package:flutter/material.dart';
import 'package:gereh/constants/my_colors.dart';

class MyButton extends StatelessWidget {
  final VoidCallback? onClick;
  final Color? fillColor;
  final Color? borderColor;
  final bool? enable;
  final double? width;
  final double? height;
  final Widget? child;
  final double? radius;
  final double? elevation;
  const MyButton(
      {Key? key,
      this.child,
      this.onClick,
      this.fillColor,
      this.borderColor,
      this.enable,
      this.width,
      this.height,
      this.radius,
      this.elevation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: onClick,
      focusElevation: 0,
      hoverElevation: 0,
      highlightColor: fillColor ?? MyColors.red,
      constraints:
          BoxConstraints(minWidth: width ?? 80, minHeight: height ?? 40),
      highlightElevation: 0,
      fillColor: fillColor ?? MyColors.red,
      elevation: elevation ?? 3,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(radius ?? 50)),
          side: BorderSide(color: borderColor ?? Colors.transparent)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: child,
      ),
    );
  }
}
