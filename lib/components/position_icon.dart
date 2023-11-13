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
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).colorScheme.primaryContainer,
          ),
        ),
        const Icon(
          Icons.explore,
          size: 20,
        ),
      ],
    );
  }
}
