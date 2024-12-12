import 'package:flutter/material.dart';

class Bat extends StatelessWidget {
  final double width;
  final double height;
  const Bat({super.key,required this.height,required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.blue[900]
      ),
    );
  }
}
