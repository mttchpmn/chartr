import 'package:flutter/material.dart';

class DistanceDisplay extends StatelessWidget {
  const DistanceDisplay({
    super.key,
    required this.distance,
    required this.bearing,
  });

  final double? distance;
  final double? bearing;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 2, bottom: 2),
        child: Column(
          children: [
            Text(
              "DIST: ${distance?.toStringAsFixed(1)} m",
              style: Theme.of(context).textTheme.labelLarge,
            ),
            Visibility(
              visible: bearing != null,
              child: Text(
                "BRG: ${bearing?.toStringAsFixed(1)} °T",
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
