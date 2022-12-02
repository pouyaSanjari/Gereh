import 'package:flutter/material.dart';
import 'package:gereh/constants/my_colors.dart';

class MyChip extends StatelessWidget {
  final bool val;
  final bool? disabled;
  final String text;
  final Function(bool) onSelected;
  const MyChip({
    Key? key,
    required this.val,
    required this.text,
    required this.onSelected,
    this.disabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      backgroundColor: Colors.brown.withOpacity(0.1),
      label: Text(
        text,
        style: TextStyle(color: val ? Colors.white : Colors.black),
      ),
      selected: val,
      onSelected: disabled ?? false ? null : onSelected,
      // labelPadding: const EdgeInsets.symmetric(horizontal: 20),
      selectedColor: MyColors.blueGrey,
    );
  }
}
