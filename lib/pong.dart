import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:simple_pong/components/ball.dart';
import 'package:simple_pong/components/bat.dart';

class Pong extends StatefulWidget {
  const Pong({super.key});

  @override
  State<Pong> createState() => _PongState();
}

class _PongState extends State<Pong> with SingleTickerProviderStateMixin{
  late Animation<double> animation;
  late AnimationController controller;


  double width = 0; // available width on the screen
  double height = 0; //available width on the screen
  double posX = 0; //horizontal  position of the ball
  double posY = 0; // vertical position of the ball
  double batWidth = 0;
  double batHeight = 0;
  double batPosition = 0; //horizontal position of the bat

  @override
  void initState(){
    posX = 0;
    posY = 0;
    controller =AnimationController(
      duration: Duration(seconds: 3),
        vsync: this);
    animation = Tween<double>(begin: 0, end: 100).animate(controller);
    animation.addListener((){
      setState(() {
        posX++;
        posY++;
      });
    });
    controller.forward();
    super.initState();
  }


  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // You can use `constraints` here for responsive layouts
        height = constraints.maxHeight;
        width = constraints.maxWidth;
        batWidth = width / 5;
        batHeight = height / 20;

        return Stack(
          children: [
            Positioned(
              child: Ball(),
              top: posY,
              left: posX,
            ),
            Positioned(
                bottom: 0, child: Bat(height: batHeight, width: batWidth))
          ],
        );
      },
    );
  }
}
