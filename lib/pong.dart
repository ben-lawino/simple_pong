import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:simple_pong/components/ball.dart';
import 'package:simple_pong/components/bat.dart';

// Enum to define the direction of the ball movement
enum Direction { up, down, left, right }

class Pong extends StatefulWidget {
  const Pong({super.key});

  @override
  State<Pong> createState() => _PongState();
}

class _PongState extends State<Pong> with SingleTickerProviderStateMixin {
  // Speed of the ball's movement
  double increment = 5;

  // Variables to store the ball's current vertical and horizontal direction
  Direction vDir = Direction.down;
  Direction hDir = Direction.right;

  // Method to check the ball's position against the screen borders
  void checkBorders() {
    double diameter = 50; // Diameter of the ball

    // If the ball hits the left border, reverse horizontal direction to right
    if (posX <= 0 && hDir == Direction.left) {
      hDir = Direction.right;
    }
    // If the ball hits the right border, reverse horizontal direction to left
    if (posX >= width - diameter && hDir == Direction.right) {
      hDir = Direction.left;
    }
    // If the ball hits the bottom border
    if (posY >= height - diameter - batHeight && vDir == Direction.down) {
      // Check if the ball is hitting the bat
      if (posX >= (batPosition - diameter) && posX <= (batPosition + batWidth + diameter)) {
        vDir = Direction.up; // Reverse vertical direction to up
      } else {
        // If the ball misses the bat, stop the game
        controller.stop();
        dispose();
      }
    }
    // If the ball hits the top border, reverse vertical direction to down
    if (posY <= 0 && vDir == Direction.up) {
      vDir = Direction.down;
    }
  }

  // Animation controller for ball movement
  late Animation<double> animation;
  late AnimationController controller;

  // Variables to store the dimensions of the screen and positions
  double width = 0; // Screen width
  double height = 0; // Screen height
  double posX = 0; // Horizontal position of the ball
  double posY = 0; // Vertical position of the ball
  double batWidth = 0; // Width of the bat
  double batHeight = 0; // Height of the bat
  double batPosition = 0; // Horizontal position of the bat

  // Method to move the bat horizontally based on user input
  void moveBat(DragUpdateDetails update) {
    safeSetState(() {
      batPosition += update.delta.dx;
    });
  }

  @override
  void dispose() {
    // Dispose the animation controller to release resources
    controller.dispose();
  }

  // Safely call `setState` only if the widget is mounted and animation is running
  void safeSetState(Function function) {
    if (mounted && controller.isAnimating) {
      setState(() {
        function();
      });
    }
  }

  @override
  void initState() {
    // Initialize ball position
    posX = 0;
    posY = 0;

    // Initialize animation controller with a long duration
    controller = AnimationController(duration: Duration(minutes: 10000), vsync: this);

    // Define animation from 0 to 100
    animation = Tween<double>(begin: 0, end: 100).animate(controller);

    // Listener for animation updates
    animation.addListener(() {
      safeSetState(() {
        // Update ball position based on direction and speed
        (hDir == Direction.right) ? posX += increment : posX -= increment;
        (vDir == Direction.down) ? posY += increment : posY -= increment;
      });
      checkBorders(); // Check for collisions
    });

    // Start the animation
    controller.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // Set screen dimensions based on layout constraints
        height = constraints.maxHeight;
        width = constraints.maxWidth;

        // Define bat dimensions
        batWidth = width / 5;
        batHeight = height / 20;

        return Stack(
          children: [
            // Ball widget positioned based on its current position
            Positioned(
              child: Ball(),
              top: posY,
              left: posX,
            ),
            // Bat widget positioned at the bottom and responsive to user drag
            Positioned(
              bottom: 0,
              left: batPosition,
              child: GestureDetector(
                onHorizontalDragUpdate: (DragUpdateDetails update) => moveBat(update),
                child: Bat(height: batHeight, width: batWidth),
              ),
            ),
          ],
        );
      },
    );
  }
}
