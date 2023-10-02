import 'package:flutter/material.dart';

class DrawButtonStack extends StatelessWidget {
  final VoidCallback onDrawCancel;
  final VoidCallback onDrawClear;
  final VoidCallback onDrawSave;
  final VoidCallback onColorChange;
  Color paintColor;

  final Color _iconColor = const Color(0xFF41548C);

  DrawButtonStack({
    super.key,
    required this.onDrawCancel,
    required this.onDrawClear,
    required this.onDrawSave,
    required this.onColorChange,
    required this.paintColor
  });

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned(
        top: 50, // Adjust the position as needed
        right: 15,
        child: FloatingActionButton(
          onPressed: onDrawCancel,
          mini: true,
          child: Icon(Icons.cancel, color: _iconColor),
        ),
      ),
      Positioned(
        top: 100, // Adjust the position as needed
        right: 15,
        child: FloatingActionButton(
          onPressed: onDrawClear,
          mini: true,
          child: Icon(Icons.clear, color: _iconColor),
        ),
      ),
      Positioned(
        top: 150, // Adjust the position as needed
        right: 15,
        child: FloatingActionButton(
          onPressed: onDrawSave,
          mini: true,
          child: Icon(Icons.save, color: _iconColor),
        ),
      ),
      Positioned(
        top: 200, // Adjust the position as needed
        right: 15,
        child: FloatingActionButton(
          onPressed: onColorChange,
          mini: true,
          child: Icon(Icons.format_paint, color: paintColor),
        ),
      ),
    ]);
  }
}
