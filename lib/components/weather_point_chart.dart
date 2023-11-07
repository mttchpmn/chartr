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
  ChartState _chartState = ChartState.airPressure;

  void _onChartStateChange(ChartState newState) {
    setState(() {
      _chartState = newState;
    });
  }

  String _getChartTitle() {
    switch (_chartState) {
      case ChartState.airPressure:
        return "Air Pressure (hPa)";
      case ChartState.airTemperature:
        return "Air Temperature (deg Celsius)";
      case ChartState.cloudBase:
        return "Cloud Base (m AGL)";
      case ChartState.cloudCover:
        return "Cloud Cover (% of sky)";
      case ChartState.precipitation:
        return "Precipitation (mm/hr)";
      case ChartState.windSpeed:
        return "Wind Speed (kmh)";
      case ChartState.windDirection:
        return "Wind Direction";
    }
  }

  List<FlSpot> _buildSpotList(List<PointData> data) {
    data.removeWhere((element) => element.value == null);

    var result = data
        .map((e) => FlSpot(e.dateTime.toLocal().hour.toDouble(),
            double.parse(e.value!.toStringAsFixed(1))))
        .toList();
    return result;
  }

  double _getMaxY(List<PointData> data) {
    var biggestValue = data
        .map((element) => element.value ?? 0)
        .reduce((value, element) => element > value ? element : value);

    return biggestValue.ceilToDouble();
  }

  double _getMinY(List<PointData> data) {
    var smallest = data
        .map((element) => element.value ?? 0)
        .reduce((value, element) => element < value ? element : value);

    return smallest.floorToDouble();
  }

  LineChartData _getChartData() {
    switch (_chartState) {
      case ChartState.airPressure:
        return _buildChart(widget.weatherData.airPressure, false, Colors.orange,
            "Pressure (hPa)");
      case ChartState.airTemperature:
        return _buildChart(widget.weatherData.airTemperature, false, Colors.red,
            "Temperature (degC)");
      case ChartState.cloudCover:
        return _buildChart(widget.weatherData.cloudCover, true, Colors.green,
            "Cloud Cover (%)");
      case ChartState.cloudBase:
        return _buildChart(
            widget.weatherData.cloudBase, false, Colors.pink, "Cloud Base (m)");
      case ChartState.precipitation:
        return _buildChart(widget.weatherData.precipitationRate, false,
            Colors.blue, "Precipitation Rate (mm/hr)");
      case ChartState.windDirection:
        return _buildChart(widget.weatherData.windDirection, false,
            Colors.lightBlue, "Wind Direction (deg)");
      case ChartState.windSpeed:
        return _buildWindChart();
    }
  }

  LineChartData _buildChart(List<PointData> points, bool isPercentage,
      Color lineColor, String yAxisTitle) {
    return LineChartData(
        minY: isPercentage ? 0 : _getMinY(points) * 0.95,
        maxY: isPercentage ? 100 : _getMaxY(points) * 1.05,
        lineBarsData: [
          LineChartBarData(
              color: lineColor,
              spots: _buildSpotList(points),
              isCurved: true,
              dotData: const FlDotData(show: false)),
        ],
        titlesData: FlTitlesData(
            bottomTitles: const AxisTitles(
              axisNameSize: 20,
              axisNameWidget: Text("Time of Day"),
            ),
            leftTitles: AxisTitles(
              axisNameSize: 20,
              axisNameWidget: Text(yAxisTitle),
            )));
  }

  LineChartData _buildWindChart() {
    return LineChartData(
        minY: 0,
        maxY: _getMaxY(widget.weatherData.windGust) * 1.05,
        lineBarsData: [
          LineChartBarData(
              color: Colors.blue,
              spots: _buildSpotList(widget.weatherData.windSpeed),
              isCurved: true,
              dotData: const FlDotData(show: false)),
          LineChartBarData(
              color: Colors.red,
              spots: _buildSpotList(widget.weatherData.windGust),
              isCurved: true,
              dotData: const FlDotData(show: false)),
        ],
        titlesData: const FlTitlesData(
            bottomTitles: AxisTitles(
              axisNameSize: 20,
              axisNameWidget: Text("Time of Day"),
            ),
            leftTitles: AxisTitles(
              axisNameSize: 20,
              axisNameWidget: Text("Wind Speed (kmh)"),
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          _getChartTitle(),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        AspectRatio(
          aspectRatio: 1.5,
          child: LineChart(_getChartData()),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // IconButton(onPressed: () {}, icon: Icon(Icons.compress)), // pressure
            IconButton(
                color: _chartState == ChartState.airPressure
                    ? Colors.deepOrange
                    : Colors.black54,
                onPressed: () {
                  _onChartStateChange(ChartState.airPressure);
                },
                icon: const Icon(Icons.compress)),
            IconButton(
              onPressed: () {
                _onChartStateChange(ChartState.airTemperature);
              },
              icon: const Icon(Icons.thermostat),
              color: _chartState == ChartState.airTemperature
                  ? Colors.deepOrange
                  : Colors.black54,
            ),

            IconButton(
                color: _chartState == ChartState.cloudCover
                    ? Colors.deepOrange
                    : Colors.black54,
                onPressed: () {
                  _onChartStateChange(ChartState.cloudCover);
                },
                icon: const Icon(Icons.cloud)),
            IconButton(
                color: _chartState == ChartState.cloudBase
                    ? Colors.deepOrange
                    : Colors.black54,
                onPressed: () {
                  _onChartStateChange(ChartState.cloudBase);
                },
                icon: const Icon(Icons.terrain)),
            // cloud - cover / base
            IconButton(
                color: _chartState == ChartState.precipitation
                    ? Colors.deepOrange
                    : Colors.black54,
                onPressed: () {
                  _onChartStateChange(ChartState.precipitation);
                },
                icon: const Icon(Icons.water_drop)),
            // rain

            IconButton(
                color: _chartState == ChartState.windSpeed
                    ? Colors.deepOrange
                    : Colors.black54,
                onPressed: () {
                  _onChartStateChange(ChartState.windSpeed);
                },
                icon: const Icon(Icons.wind_power)),
            IconButton(
                color: _chartState == ChartState.windDirection
                    ? Colors.deepOrange
                    : Colors.black54,
                onPressed: () {
                  _onChartStateChange(ChartState.windDirection);
                },
                icon: const Icon(Icons.flag)),
            // wind - speed / gust / dir
          ],
        )
      ],
    );
  }
}

enum ChartState {
  airPressure,
  airTemperature,
  cloudBase,
  cloudCover,
  precipitation,
  windSpeed,
  windDirection
}
