import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../constants/colors.dart';

class MyToggleSwitch extends StatelessWidget {
  final void Function(int?)? onToggle;
  final int initialLableIndex;
  final int totalSwitch;
  final List<String> labels;
  const MyToggleSwitch(
      {Key? key,
      this.onToggle,
      required this.initialLableIndex,
      required this.labels,
      required this.totalSwitch})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ToggleSwitch(
      activeBgColor: const [MyColors.blueGrey],
      inactiveBgColor: MyColors.bluewhite,
      minWidth: 200,
      cornerRadius: 20,
      animate: true,
      animationDuration: 200,
      initialLabelIndex: initialLableIndex,
      totalSwitches: totalSwitch,
      labels: labels,
      onToggle: onToggle,
    );
  }
}