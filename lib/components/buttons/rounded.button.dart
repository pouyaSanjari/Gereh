import 'package:flutter/material.dart';

import '../../constants/my_colors.dart';

class MyRoundedButton extends StatelessWidget {
  final Widget icon;
  final Color? backColor;
  final String? text;
  final VoidCallback? onClick;
  final double? elevation;
  const MyRoundedButton(
      {Key? key,
      required this.icon,
      this.backColor,
      this.text,
      this.onClick,
      this.elevation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RawMaterialButton(
          constraints: const BoxConstraints(minHeight: 20, minWidth: 60),
          elevation: elevation ?? 5,
          fillColor: backColor ?? MyColors.backgroundColor,
          splashColor: MyColors.red.withOpacity(0.5),
          highlightColor: MyColors.red,
          padding: const EdgeInsets.all(15),
          shape: const CircleBorder(),
          onPressed: onClick,
          child: icon,
        ),
        text == '' || text == null
            ? Container()
            : Padding(
                padding: const EdgeInsets.only(top: 2, bottom: 3),
                child: Material(
                  color: Colors.transparent,
                  child: Text(
                    text ?? '',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              )
      ],
    );
  }
}
