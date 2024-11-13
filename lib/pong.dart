import 'package:flutter/material.dart';
import 'package:simple_pong/components/ball.dart';
import 'package:simple_pong/components/bat.dart';

class Pong extends StatefulWidget {
  const Pong({super.key});

  @override
  State<Pong> createState() => _PongState();
}

class _PongState extends State<Pong> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // You can use `constraints` here for responsive layouts
        return Stack(
          children: [
            Positioned(
              child: Ball(),
              top: 0,
            ),
            Positioned(
              bottom: 0,
                child: Bat(height: 50, width:200))
          ],
        );
      },
    );
  }
}
