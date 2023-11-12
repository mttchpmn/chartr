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
    var fg = Theme.of(context).colorScheme.primary;
    var bg = Theme.of(context).colorScheme.secondary;

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 2, bottom: 2),
        child: Column(
          children: [
            Text(
              "DIST: ${distance?.toStringAsFixed(1)} m",
              style: TextStyle(color: fg, fontWeight: FontWeight.bold),
            ),
            Visibility(
              visible: bearing != null,
              child: Text(
                "BRG: ${bearing?.toStringAsFixed(1)} °T",
                style: TextStyle(color: fg, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
