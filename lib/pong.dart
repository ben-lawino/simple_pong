import 'package:flutter/material.dart';
import 'package:simple_pong/components/ball.dart';
import 'dart:math';

import 'package:simple_pong/components/bat.dart';

// Enum for ball direction
enum Direction { up, down, left, right }

class Pong extends StatefulWidget {
  const Pong({super.key});

  @override
  State<Pong> createState() => _PongState();
}

class _PongState extends State<Pong> with SingleTickerProviderStateMixin {
  // Random multipliers to make ball movement unpredictable
  double randX = 1; // Horizontal random factor
  double randY = 1; // Vertical random factor

  // Speed of ball movement
  double increment = 5;

  // Current ball direction
  Direction vDir = Direction.down; // Vertical direction (up or down)
  Direction hDir = Direction.right; // Horizontal direction (left or right)

  // Dimensions of the screen and game objects
  double width = 0; // Screen width
  double height = 0; // Screen height
  double posX = 0; // Ball's X position
  double posY = 0; // Ball's Y position
  double batWidth = 0; // Bat's width
  double batHeight = 0; // Bat's height
  double batPosition = 0; // Bat's X position

  // Animation controller and animation for ball movement
  late Animation<double> animation;
  late AnimationController controller;

  // Initialize the game setup
  @override
  void initState() {
    super.initState();

    // Set initial ball position at (0, 0)
    posX = 0;
    posY = 0;

    // Create a long-running animation controller for smooth game updates
    controller = AnimationController(duration: const Duration(minutes: 10000), vsync: this);

    // Define an animation (not tied to actual values but used to trigger updates)
    animation = Tween<double>(begin: 0, end: 100).animate(controller);

    // Listen to the animation for frame updates
    animation.addListener(() {
      safeSetState(() {
        // Update ball's X position based on its horizontal direction
        posX += (hDir == Direction.right ? increment * randX : -increment * randX).round();

        // Update ball's Y position based on its vertical direction
        posY += (vDir == Direction.down ? increment * randY : -increment * randY).round();
      });
      checkBorders(); // Check for collisions with screen borders or bat
    });

    controller.forward(); // Start the animation
  }

  // Generate a random number between 0.5 and 1.5 to vary ball movement
  double randomNumber() {
    var ran = Random(); // Random number generator
    return (50 + ran.nextInt(101)) / 100; // Random value between 0.5 and 1.5
  }

  // Check if the ball hits any screen borders or the bat
  void checkBorders() {
    const double diameter = 50; // Diameter of the ball

    // Reverse horizontal direction if ball hits left or right screen borders
    if (posX <= 0 && hDir == Direction.left) {
      hDir = Direction.right; // Change direction to right
      randX = randomNumber(); // Adjust random factor
    }
    if (posX >= width - diameter && hDir == Direction.right) {
      hDir = Direction.left; // Change direction to left
      randX = randomNumber(); // Adjust random factor
    }

    // Check if the ball hits the bottom of the screen
    if (posY >= height - diameter - batHeight && vDir == Direction.down) {
      // Ball hits the bat if within bat's horizontal range
      if (posX >= (batPosition - diameter) && posX <= (batPosition + batWidth + diameter)) {
        vDir = Direction.up; // Reverse vertical direction upwards
        randY = randomNumber(); // Adjust random factor
      } else {
        controller.stop(); // Stop the animation if ball misses the bat
        dispose(); // Dispose resources
      }
    }

    // Reverse vertical direction if ball hits the top of the screen
    if (posY <= 0 && vDir == Direction.up) {
      vDir = Direction.down; // Change direction to down
      randY = randomNumber(); // Adjust random factor
    }
  }

  // Move the bat horizontally based on user drag input
  void moveBat(DragUpdateDetails update) {
    safeSetState(() {
      batPosition += update.delta.dx; // Update bat's position by drag amount
    });
  }

  // Safely call `setState` to update UI only when widget is mounted and animation is running
  void safeSetState(Function function) {
    if (mounted && controller.isAnimating) {
      setState(() {
        function();
      });
    }
  }

  // Clean up resources when the widget is disposed
  @override
  void dispose() {
    controller.dispose(); // Dispose the animation controller
    super.dispose();
  }

  // Build the game UI
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // Update screen dimensions based on layout constraints
        height = constraints.maxHeight; // Screen height
        width = constraints.maxWidth; // Screen width

        // Set bat dimensions as a fraction of screen size
        batWidth = width / 5; // Bat width is 1/5 of screen width
        batHeight = height / 20; // Bat height is 1/20 of screen height

        return Stack(
          children: [
            // Ball widget positioned based on its current position
            Positioned(
              child: Ball(), // Ball component
              top: posY, // Ball's vertical position
              left: posX, // Ball's horizontal position
            ),
            // Bat widget positioned at the bottom of the screen
            Positioned(
              bottom: 0, // Place bat at the bottom
              left: batPosition, // Set bat's horizontal position
              child: GestureDetector(
                onHorizontalDragUpdate: moveBat, // Update bat position on drag
                child: Bat(height: batHeight, width: batWidth), // Bat component
              ),
            ),
          ],
        );
      },
    );
  }
}
