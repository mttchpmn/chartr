import 'dart:ui';

import 'package:flutter/material.dart';

class DrawPainter extends CustomPainter {
  final List<Offset> points;

  DrawPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < points.length - 1; i++) {
      final p1 = points[i];
      final p2 = points[i + 1];
      canvas.drawLine(p1, p2, paint);
    }
  }

  void clear() {
    points.clear();
  }

  void getImage() {}

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
