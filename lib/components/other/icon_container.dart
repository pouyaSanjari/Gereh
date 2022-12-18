import 'package:flutter/material.dart';

class IconContainer extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;
  final double? width;
  final double? height;
  final double? radius;
  final double? titleFontSize;
  final double? contentFontSize;
  const IconContainer(
      {super.key,
      required this.title,
      required this.value,
      required this.icon,
      required this.iconColor,
      this.width,
      this.height,
      this.radius,
      this.titleFontSize,
      this.contentFontSize});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: width ?? 50,
          height: height ?? 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius ?? 20),
              color: iconColor.withOpacity(0.1)),
          child: Icon(
            icon,
            color: iconColor,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          title,
          style: TextStyle(color: Colors.grey, fontSize: titleFontSize ?? 14),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: contentFontSize ?? 15),
        )
      ],
    );
  }
}
