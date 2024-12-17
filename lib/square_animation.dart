import 'package:flutter/material.dart';

class SquareAnimation extends StatefulWidget {
  const SquareAnimation({super.key});

  @override
  State<SquareAnimation> createState() {
    return SquareAnimationState();
  }
}

class SquareAnimationState extends State<SquareAnimation> {
  static const _squareSize = 50.0;

  bool isTappedRight = false; // Indicates if the "Right" button is tapped.
  bool isTappedLeft = false; // Indicates if the "Left" button is tapped.
  bool isAnimating = false; // Indicates if an animation is currently running.

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // AnimatedContainer on the left side of the square.
            AnimatedContainer(
              width: isTappedRight
                  ? MediaQuery.of(context).size.width - _squareSize
                  : 0,
              duration: const Duration(seconds: 1),
            ),

            Container(
              width: _squareSize,
              height: _squareSize,
              decoration: BoxDecoration(
                color: Colors.red,
                border: Border.all(),
              ),
            ),
            // AnimatedContainer on the right side of the square.
            AnimatedContainer(
              width: isTappedLeft
                  ? MediaQuery.of(context).size.width - _squareSize
                  : 0,
              duration: const Duration(seconds: 1),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Row containing the "Right" and "Left" buttons.
        Row(
          children: [
            // Button to move the square to the right.
            ElevatedButton(
              onPressed: isTappedRight || isAnimating
                  ? null // Disable the button if the animation is running or "Right" is already selected.
                  : () {
                      setState(() {
                        isAnimating = true; // Mark animation as running.
                        isTappedRight = true; // Move square to the right.
                        isTappedLeft = false; // Reset left state.
                      });

                      // Wait for the animation duration to complete before resetting the flag.
                      Future.delayed(const Duration(seconds: 1), () {
                        setState(() {
                          isAnimating = false;
                        });
                      });
                    },
              child: const Text('Right'),
            ),
            const SizedBox(width: 8),

            ElevatedButton(
              onPressed: isTappedLeft || isAnimating
                  ? null
                  : () {
                      setState(() {
                        isAnimating = true;
                        isTappedLeft = true;
                        isTappedRight = false;
                      });

                      Future.delayed(const Duration(seconds: 1), () {
                        setState(() {
                          isAnimating = false;
                        });
                      });
                    },
              child: const Text('Left'),
            ),
          ],
        ),
      ],
    );
  }
}