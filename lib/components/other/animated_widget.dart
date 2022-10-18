import 'package:flutter/cupertino.dart';

class MyAnimatedWidget extends StatelessWidget {
  final bool state;
  final Widget child;
  final double? height;
  const MyAnimatedWidget({
    Key? key,
    required this.state,
    required this.child,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      curve: Curves.fastLinearToSlowEaseIn,
      opacity: state ? 1 : 0,
      duration: const Duration(milliseconds: 1000),
      child: AnimatedSize(
        curve: Curves.fastLinearToSlowEaseIn,
        duration: const Duration(milliseconds: 1000),
        child: SizedBox(
          height: state ? height ?? 70 : 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: child,
          ),
        ),
      ),
    );
  }
}
