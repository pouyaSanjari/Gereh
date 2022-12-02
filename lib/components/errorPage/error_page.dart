import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ErrorPage extends StatelessWidget {
  final VoidCallback? onReferesh;
  const ErrorPage({Key? key, required this.onReferesh}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Iconsax.info_circle,
          size: 150,
          color: Colors.red,
        ),
        const SizedBox(height: 20),
        const Text(
          'اتصال اینترنت خود را بررسی کنید...',
        ),
        TextButton(onPressed: onReferesh, child: const Text('تلاش مجدد'))
      ],
    ));
  }
}
