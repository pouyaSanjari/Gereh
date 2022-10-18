import 'package:flutter/material.dart';

class MyContainer extends StatelessWidget {
  final Color color;
  final List<Widget> widgets;
  final double width;
  final double? height;
  final double radius;
  final double contentPadding;
  const MyContainer(
      {super.key,
      required this.color,
      required this.widgets,
      this.width = double.infinity,
      this.radius = 10,
      this.contentPadding = 8,
      this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[50],
      alignment: Alignment.center,
      transformAlignment: Alignment.center,
      child: Container(
        color: const Color(0xfff2f5fc),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(radius),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  color,
                  color,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: color,
                  offset: const Offset(0.0, 0),
                  blurRadius: 5,
                  spreadRadius: 0.0,
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(contentPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: widgets,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
