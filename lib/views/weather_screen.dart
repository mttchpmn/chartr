import 'package:chartr/components/menu_drawer.dart';
import 'package:chartr/models/weather_point_data.dart';
import 'package:chartr/services/weather_service.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class WeatherScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final WeatherService _weatherService = WeatherService();

  @override
  void initState() {
    super.initState();

    var input = WeatherPointDataInput(
        point: LatLng(-36.861851, 174.852992),
        fromDate: "2023-11-02T22:31:26.875Z",
        interval: TimeInterval.oneHourly,
        repeat: 6);
    var data = _weatherService.getWeatherPointData(input);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.black45,
          foregroundColor: Colors.white,
        ),
        drawer: const MenuDrawer(),
        body: Padding(
          padding: const EdgeInsets.only(top: 100, left: 16, right: 16),
          child: Column(children: [Text("Weather")]),
        ));
  }
}
