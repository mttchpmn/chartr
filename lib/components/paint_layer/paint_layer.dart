import 'dart:ui';

import 'package:chartr/components/paint_layer/canvas_painter.dart';
import 'package:chartr/components/paint_layer/draw_button_stack.dart';
import 'package:flutter/material.dart';

class PaintLayer extends StatefulWidget {
  final VoidCallback onExit;
  final Function(MemoryImage) onSaveImage;

  const PaintLayer({super.key, required this.onExit, required this.onSaveImage});

  @override
  State<StatefulWidget> createState() => PaintLayerState();
}

class PaintLayerState extends State<PaintLayer> {
  late Color _paintColor;
  int _paintColorIndex = 0;
  List<Color> _availableColors = [
    Colors.deepOrange,
    Colors.lightBlue,
    Colors.red,
    Colors.green,
    Colors.yellow,
    Colors.black
  ];
  List<Offset?> _points = [];

  @override
  void initState() {
    super.initState();

    setState(() {
      _paintColor = _availableColors[_paintColorIndex];
    });
  }

  void _onClearCanvas() {
    print("#Clear canvas");
    setState(() {
      _points.clear();
    });
  }

  void _onSaveImage() async {
    print("#Save image");

    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);
    final painter = CanvasPainter(_points, _paintColor);
    final size = MediaQuery.of(context).size;

    painter.paint(canvas, size); // Paint on the canvas

    final picture = recorder.endRecording();
    final image = await picture.toImage(size.width.toInt(), size.height.toInt());

    final byteData = await image.toByteData(format: ImageByteFormat.png);
    final bytes = byteData!.buffer.asUint8List();
    var memoryImage = MemoryImage(bytes);

    widget.onSaveImage(memoryImage);

    _onExit();
  }

  void _onExit() {
    print("#Exit painting");
    widget.onExit();
  }

  void _onSelectColor() {
    var newIndex = _paintColorIndex == _availableColors.length - 1
        ? 0
        : _paintColorIndex + 1;

    setState(() {
      _paintColorIndex = newIndex;
      _paintColor = _availableColors[newIndex];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanUpdate: (details) {
          setState(() {
            final renderBox = context.findRenderObject() as RenderBox;
            final localPosition =
                renderBox.globalToLocal(details.globalPosition);
            _points.add(localPosition);
          });
        },
        onPanEnd: (_) {
          setState(() {
            _points.add(null);
          });
          // Drawing finished
        },
        child: CustomPaint(
          size: MediaQuery.of(context).size,
          painter: CanvasPainter(_points, _paintColor),
        ),
      ),
      DrawButtonStack(
        onDrawCancel: _onExit,
        onDrawClear: _onClearCanvas,
        onDrawSave: _onSaveImage,
        paintColor: _paintColor,
        onColorChange: _onSelectColor,
      )
    ]);
  }
}
