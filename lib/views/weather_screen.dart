import 'package:chartr/components/menu_drawer.dart';
import 'package:chartr/components/weather_point_chart.dart';
import 'package:chartr/models/weather_point_data.dart';
import 'package:chartr/services/location_service.dart';
import 'package:chartr/services/mapbox_service.dart';
import 'package:chartr/services/weather_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

class WeatherScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final WeatherService _weatherService = WeatherService();
  final LocationService _locationService = LocationService(0);
  final MapboxService _mapboxService = MapboxService();

  late DateTime _date;
  WeatherPointData? _weatherPointData;
  List<PointData>? _tideData;
  bool _weatherPointDataLoading = false;
  LatLng? _deviceLocation;
  String? _locality;

  @override
  void initState() {
    super.initState();
    _setDate();
    _setLocation();
    _setWeatherPointData();
  }

  void _setDate() {
    var now = DateTime.now(); // Get current UTC time.
    var midnightThisMorning = DateTime(now.year, now.month, now.day);

    setState(() {
      _date = midnightThisMorning;
    });
  }

  void _setDateNextDay() {
    var newDate = _date.add(Duration(days: 1));

    setState(() {
      _date = newDate;
    });

    _setWeatherPointData();
  }

  void _setDatePrevDay() {
    var newDate = _date.subtract(Duration(days: 1));

    setState(() {
      _date = newDate;
    });

    _setWeatherPointData();
  }

  void _setLocation() async {
    await _locationService.initializeAsync();
    var loc = await _locationService.getPosition();
    var location = LatLng(loc.latitude, loc.longitude);
    var locality = await _mapboxService.getLocalityForCoordinates(location);

    setState(() {
      _deviceLocation = location;
      _locality = locality;
    });
  }

  void _setWeatherPointData() async {
    setState(() {
      _weatherPointDataLoading = true;
    });
    var input = WeatherPointDataInput(
        point: const LatLng(-36.861851, 174.852992),
        fromDate: _date.toUtc().toIso8601String(),
        interval: TimeInterval.oneHourly,
        repeat: 24);
    var data = await _weatherService.getWeatherPointData(input);
    var tide = await _weatherService.getTideData(input);

    setState(() {
      _weatherPointData = data;
      _tideData = tide;
      _weatherPointDataLoading = false;
    });
  }

  String _getDate() {
    return DateFormat('EEE dd MMMM').format(_date);
  }

  @override
  Widget build(BuildContext context) {
    if (_weatherPointData == null || _deviceLocation == null) {
      return const Scaffold(body: Spinner());
    }

    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.deepOrange,
          foregroundColor: Colors.white,
        ),
        drawer: const MenuDrawer(),
        body: Padding(
          padding: const EdgeInsets.only(top: 100, left: 16, right: 16),
          child: Column(children: [
            Text(
              "Showing Weather for ${_locality ?? "Your Location"}",
              style: TextStyle(fontSize: 20),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                    onPressed: _setDatePrevDay,
                    icon: Icon(Icons.arrow_circle_left)),
                Text(_getDate()),
                IconButton(
                    onPressed: _setDateNextDay,
                    icon: Icon(Icons.arrow_circle_right))
              ],
            ),
            SizedBox(
              height: 15,
            ),
            _weatherPointDataLoading
                ? const Spinner()
                : WeatherPointChart(
                    weatherData: _weatherPointData!,
                    tideData: _tideData!,
                  )
          ]),
        ));
  }
}

class Spinner extends StatelessWidget {
  const Spinner({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(child: Text("Loading...")),
      ],
    );
  }
}
