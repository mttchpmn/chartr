import 'package:chartr/components/map_button.dart';
import 'package:flutter/material.dart';

class DrawButtonStack extends StatelessWidget {
  final VoidCallback onDrawCancel;
  final VoidCallback onDrawClear;
  final VoidCallback onDrawSave;
  final VoidCallback onColorChange;
  Color paintColor;

  final Color _iconColor = Colors.deepOrange;

  DrawButtonStack(
      {super.key,
      required this.onDrawCancel,
      required this.onDrawClear,
      required this.onDrawSave,
      required this.onColorChange,
      required this.paintColor});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned(
        top: 100, // Adjust the position as needed
        right: 15,
        child: MapButton(
          onPressed: onDrawCancel,
          icon: const Icon(
            Icons.clear,
          ),
        ),
      ),
      Positioned(
        top: 150, // Adjust the position as needed
        right: 15,
        child: MapButton(
          onPressed: onDrawSave,
          icon: const Icon(
            Icons.check,
          ),
        ),
      ),
      Positioned(
        top: 200, // Adjust the position as needed
        right: 15,
        child: MapButton(
          onPressed: onColorChange,
          icon: Icon(Icons.palette, color: paintColor),
        ),
      ),
    ]);
  }
}
