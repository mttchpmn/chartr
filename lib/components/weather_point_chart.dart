import 'package:chartr/models/weather_point_data.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class WeatherPointChart extends StatefulWidget {
  WeatherPointData weatherData;

  WeatherPointChart({super.key, required this.weatherData});

  @override
  State<StatefulWidget> createState() => _WeatherPointChartState();
}

class _WeatherPointChartState extends State<WeatherPointChart> {
  List<FlSpot> _buildSpotList(List<PointData> data) {
    var result = data
        .map((e) => FlSpot(e.dateTime.toLocal().hour.toDouble(), e.value ?? 0))
        .toList();
    return result;
  }

  double _getMaxY(List<PointData> data) {
    var biggestValue = data
        .map((element) => element.value ?? 0)
        .reduce((value, element) => element > value ? element : value);

    var result = biggestValue * 1.3;

    return result.ceilToDouble();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: LineChart(LineChartData(
          minY: 0,
          maxY: _getMaxY(widget.weatherData.windGust),
          lineBarsData: [
            LineChartBarData(
                color: Colors.blue,
                spots: _buildSpotList(widget.weatherData.windSpeed),
                isCurved: true,
                dotData: FlDotData(show: false)),
            LineChartBarData(
                color: Colors.red,
                spots: _buildSpotList(widget.weatherData.windGust),
                isCurved: true,
                dotData: FlDotData(show: false)),
            // LineChartBarData(
            //     color: Colors.green,
            //     spots: _buildSpotList(widget.weatherData.airHumidity),
            //     isCurved: true,
            //     dotData: FlDotData(show: false))
          ],
          titlesData: FlTitlesData(
              bottomTitles:
                  AxisTitles(sideTitles: SideTitles(showTitles: true))))),
    );
  }
}
