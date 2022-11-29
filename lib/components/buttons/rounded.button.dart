import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class MyRoundedButton extends StatelessWidget {
  final Widget icon;
  final Color backColor;
  final String text;
  final VoidCallback? onClick;
  const MyRoundedButton(
      {Key? key,
      required this.icon,
      required this.backColor,
      required this.text,
      this.onClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RawMaterialButton(
          constraints: const BoxConstraints(minHeight: 20, minWidth: 60),
          elevation: 5,
          fillColor: backColor,
          splashColor: MyColors.red,
          highlightColor: MyColors.red,
          padding: const EdgeInsets.all(15),
          shape: const CircleBorder(),
          onPressed: onClick,
          child: icon,
        ),
        text == ''
            ? Container()
            : Padding(
                padding: const EdgeInsets.only(top: 2, bottom: 3),
                child: Material(
                  color: Colors.transparent,
                  child: Text(
                    text,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              )
      ],
    );
  }
}
