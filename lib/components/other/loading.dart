import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Center(
        child: Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: const Color.fromARGB(214, 242, 245, 252),
            borderRadius: BorderRadius.circular(20),
          ),
          child:
              Lottie.asset('assets/lottie/loading.json', width: 80, height: 80),
        ),
      ),
    );
  }
}
