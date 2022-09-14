import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

import '../constants/colors.dart';

class MySwitch extends StatelessWidget {
  final bool val;
  final ValueChanged<bool> onChange;
  const MySwitch({Key? key, required this.val, required this.onChange})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlutterSwitch(
        padding: 2,
        activeColor: MyColors.blueGrey,
        height: 28,
        width: 55,
        value: val,
        onToggle: onChange);
  }
}
