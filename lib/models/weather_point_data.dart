import 'package:latlong2/latlong.dart';

class WeatherPointData {
  final LatLng point;
  final DateTime fromDate;
  final TimeInterval interval;
  final int repeat;

  final List<PointData> airPressure;
  final List<PointData> airHumidity;
  final List<PointData> airTemperature;

  final List<PointData> cloudCover;
  final List<PointData> cloudBase;
  final List<PointData> precipitationRate;

  final List<PointData> windDirection;
  final List<PointData> windSpeed;
  final List<PointData> windGust;

  WeatherPointData({
    required this.point,
    required this.fromDate,
    required this.interval,
    required this.repeat,
    required this.airPressure,
    required this.airTemperature,
    required this.airHumidity, // %
    required this.cloudCover, // %
    required this.cloudBase,
    required this.precipitationRate,
    required this.windDirection,
    required this.windSpeed, // kmh
    required this.windGust, // kmh
  });
}

class PointData {
  final DateTime dateTime;
  final double? value;
  final String unit;

  PointData({required this.dateTime, required this.value, required this.unit});
}

enum TimeInterval { oneHourly, twoHourly, threeHourly, sixHourly }

class WeatherPointDataInput {
  final LatLng point;
  final String fromDate;
  final TimeInterval interval;
  final int repeat;

  WeatherPointDataInput(
      {required this.point,
      required this.fromDate,
      required this.interval,
      required this.repeat});
}
