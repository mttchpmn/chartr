import 'package:chartr/components/menu_drawer.dart';
import 'package:chartr/components/weather_point_chart.dart';
import 'package:chartr/models/weather_point_data.dart';
import 'package:chartr/services/location_service.dart';
import 'package:chartr/services/weather_service.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class WeatherScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final WeatherService _weatherService = WeatherService();
  final LocationService _locationService = LocationService(0);

  WeatherPointData? _weatherPointData;
  LatLng? _deviceLocation;

  @override
  void initState() {
    super.initState();
    _setLocation();
    _initWeatherPointData();
  }

  void _setLocation() async {
    await _locationService.initializeAsync();
    var loc = await _locationService.getPosition();

    setState(() {
      _deviceLocation = LatLng(loc.latitude, loc.longitude);
    });
  }

  void _initWeatherPointData() async {
    var now = DateTime.now(); // Get current UTC time.
    var midnightLastNight = DateTime(now.year, now.month, now.day);
    var isoDateStr =
        midnightLastNight.toUtc().toIso8601String(); // Convert to ISO string.

    print("Weather from: $isoDateStr");

    var input = WeatherPointDataInput(
        point: const LatLng(-36.861851, 174.852992),
        fromDate: isoDateStr,
        interval: TimeInterval.oneHourly,
        repeat: 24);
    var data = await _weatherService.getWeatherPointData(input);

    setState(() {
      _weatherPointData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_weatherPointData == null || _deviceLocation == null) {
      return const Scaffold(
          body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Text("Loading...")),
        ],
      ));
    }

    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.black45,
          foregroundColor: Colors.white,
        ),
        drawer: const MenuDrawer(),
        body: Padding(
          padding: const EdgeInsets.only(top: 100, left: 16, right: 16),
          child: Column(children: [
            const Text("Weather at your Location"),
            WeatherPointChart(weatherData: _weatherPointData!)
          ]),
        ));
  }
}
