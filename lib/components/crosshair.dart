import 'package:flutter/material.dart';

class Crosshair extends StatelessWidget {
  const Crosshair({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100, // Width of the crosshair
      height: 100, // Height of the crosshair
      decoration: const BoxDecoration(
        color: Colors.transparent, // Make the container transparent
      ),
      child: Stack(
        children: [
          Center(
            child: Container(
              width: 3, // Width of the vertical line
              height: 40, // Height of the vertical line
              color: Colors.black45, // Color of the vertical line
            ),
          ),
          Center(
            child: Container(
              width: 40, // Width of the horizontal line
              height: 3, // Height of the horizontal line
              color: Colors.black45, // Color of the horizontal line
            ),
          ),
        ],
      ),
    );
  }
}
