import 'package:flutter/material.dart';

class IconContainer extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  const IconContainer(
      {super.key,
      required this.title,
      required this.value,
      required this.icon,
      required this.iconColor,
      required this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50), color: backgroundColor),
          child: Center(
            child: Icon(
              icon,
              color: iconColor,
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          title,
          style: const TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}
