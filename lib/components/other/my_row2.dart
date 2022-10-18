import 'package:flutter/cupertino.dart';

class MyRow2 extends StatelessWidget {
  const MyRow2({
    super.key,
    this.title,
    this.value,
    this.visible,
    this.icon,
    this.iconColor,
  });
  final String? title, value;
  final bool? visible;
  final IconData? icon;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible ?? true,
      child: Row(
        children: [
          Icon(
            icon,
            color: iconColor,
          ),
          const SizedBox(width: 10),
          Expanded(
              child: Text(
            title ?? '',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          )),
          Text(value ?? ''),
        ],
      ),
    );
  }
}
