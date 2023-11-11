import 'package:flutter/material.dart';

class PositionIcon extends StatelessWidget {
  const PositionIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 25,
          height: 25,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black,
          ),
        ),
        const Icon(
          Icons.circle,
          color: Colors.purpleAccent,
          size: 20,
        ),
      ],
    );
  }
}
