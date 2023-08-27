import 'dart:async';
import 'dart:convert';
import 'package:chartr/models/ais_position_report.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class AisService {
  final StreamController<AisPositionReport> _controller =
      StreamController.broadcast();
  late WebSocketChannel channel;

  final String aisApiKey = dotenv.env['AIS_API_KEY'] ?? "";
  final List<double> topLeft = [-35.8, 174.2];
  final List<double> bottomRight = [-37.3, 176.3];

  AisService() {
    channel = WebSocketChannel.connect(
      Uri.parse('wss://stream.aisstream.io/v0/stream'),
    );

    final Map<String, dynamic> subscriptionMessage = {
      'Apikey': aisApiKey,
      'BoundingBoxes': [
        [topLeft, bottomRight]
      ],
      'FilterMessageTypes': ['PositionReport'],
    };

    channel.sink.add(jsonEncode(subscriptionMessage));

    channel.stream.listen((event) {
      print("AIS Service listening...");
      String data = event is String ? event : String.fromCharCodes(event);
      Map<String, dynamic> parsedData = jsonDecode(data);
      var positionReport = AisPositionReport.fromJson(parsedData);
      print("Received AIS message:");
      print(positionReport.toString());
      _controller.add(positionReport);
    });
  }

  Stream<AisPositionReport> get stream => _controller.stream;

  void close() {
    channel.sink.close();
    _controller.close();
  }
}
