import 'package:chartr/views/map_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';

import 'components/draw_painter.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  await FlutterMapTileCaching.initialise();
  await FMTC.instance('mapStore').manage.createAsync();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const FullScreenMapWidget(),
      // home: PaintCanvas(),
    );
  }
}

class PaintCanvas extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PaintCanvasState();
}

class PaintCanvasState extends State<PaintCanvas> {
  List<Offset> points = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
       Column(children: [Text("Hello")],),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onPanUpdate: (details) {
            setState(() {
              final renderBox = context.findRenderObject() as RenderBox;
              final localPosition =
              renderBox.globalToLocal(details.globalPosition);
              print(localPosition);
              points.add(localPosition);
            });
            print("DRAW");
          },
          onPanEnd: (_) {
            // Drawing finished
          },
          child: CustomPaint(
            size: Size.infinite,
            painter: DrawPainter(points),
          ),
        ),
      ],),
    );
  }
}