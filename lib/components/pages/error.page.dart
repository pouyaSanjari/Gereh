import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class MyErrorPage extends StatelessWidget {
  final VoidCallback? referesh;
  const MyErrorPage({Key? key, required this.referesh}) : super(key: key);

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
        TextButton(onPressed: referesh, child: const Text('تلاش مجدد'))
      ],
    ));
  }
}
