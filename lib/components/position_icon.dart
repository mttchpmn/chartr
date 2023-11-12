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
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        const Icon(
          Icons.circle,
          size: 20,
        ),
      ],
    );
  }
}
