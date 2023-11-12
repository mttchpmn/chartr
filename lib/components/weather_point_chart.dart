import 'package:chartr/models/weather_point_data.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class WeatherPointChart extends StatefulWidget {
  WeatherPointData weatherData;
  List<PointData> tideData;

  WeatherPointChart(
      {super.key, required this.weatherData, required this.tideData});

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
      case ChartState.tide:
        return "Tides";
    }
  }

  List<FlSpot> _buildSpotList(List<PointData> data) {
    data.removeWhere((element) => element.value == null);

    var result = data
        .map((e) => FlSpot(
            e.dateTime.toLocal().hour + (e.dateTime.toLocal().minute / 60),
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
            "Pressure (hPa)", "hPa");
      case ChartState.airTemperature:
        return _buildChart(widget.weatherData.airTemperature, false, Colors.red,
            "Temperature (degC)", "deg C");
      case ChartState.cloudCover:
        return _buildChart(widget.weatherData.cloudCover, true, Colors.green,
            "Cloud Cover (%)", "%");
      case ChartState.cloudBase:
        return _buildChart(widget.weatherData.cloudBase, false, Colors.pink,
            "Cloud Base (m)", "%");
      case ChartState.precipitation:
        return _buildChart(widget.weatherData.precipitationRate, false,
            Colors.blue, "Precipitation Rate (mm/hr)", "mm/hr");
      case ChartState.windDirection:
        return _buildChart(widget.weatherData.windDirection, false,
            Colors.lightBlue, "Wind Direction (deg)", "deg");
      case ChartState.windSpeed:
        return _buildWindChart();
      case ChartState.tide:
        return _buildChart(
            widget.tideData, false, Colors.blueAccent, "Tide Height", "m",
            isCurved: false);
    }
  }

  LineChartData _buildChart(List<PointData> points, bool isPercentage,
      Color lineColor, String yAxisTitle, String units,
      {bool isCurved = true}) {
    var now = DateTime.now();
    var hour = now.hour + (now.minute / 60);
    return LineChartData(
      clipData: const FlClipData.all(),
      minY: isPercentage ? 0 : _getMinY(points) * 0.95,
      maxY: isPercentage ? 100 : _getMaxY(points) * 1.05,
      extraLinesData: ExtraLinesData(verticalLines: [
        VerticalLine(
            x: hour,
            color: Theme.of(context).highlightColor,
            strokeWidth: 5,
            label: VerticalLineLabel(labelResolver: (line) => 'Now'))
      ]),
      lineBarsData: [
        LineChartBarData(
            barWidth: 3,
            color: lineColor,
            spots: _buildSpotList(points),
            isCurved: isCurved,
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
          )),
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          // Customize the tooltip box here
          tooltipBgColor: Theme.of(context).colorScheme.primary,
          getTooltipItems: (List<LineBarSpot> touchedSpots) {
            return touchedSpots.map((touchedSpot) {
              // Assuming you have a way to convert the x-axis value to a more readable format
              String xValue = '${touchedSpot.x}';
              String yValue = '${touchedSpot.y}';

              return LineTooltipItem(
                  'Time: ${xValue}0\nValue: $yValue $units', TextStyle());
            }).toList();
          },
        ),
        // Other touch data properties
      ),
    );
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
    Color fg = Theme.of(context).highlightColor;
    var unselectedIcon = Theme.of(context).colorScheme.primary;
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
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              IconButton(
                  color: _chartState == ChartState.airPressure
                      ? fg
                      : unselectedIcon,
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
                    ? fg
                    : unselectedIcon,
              ),

              IconButton(
                  color: _chartState == ChartState.cloudCover
                      ? fg
                      : unselectedIcon,
                  onPressed: () {
                    _onChartStateChange(ChartState.cloudCover);
                  },
                  icon: const Icon(Icons.cloud)),
              IconButton(
                  color:
                      _chartState == ChartState.cloudBase ? fg : unselectedIcon,
                  onPressed: () {
                    _onChartStateChange(ChartState.cloudBase);
                  },
                  icon: const Icon(Icons.terrain)),
              // cloud - cover / base
              IconButton(
                  color: _chartState == ChartState.precipitation
                      ? fg
                      : unselectedIcon,
                  onPressed: () {
                    _onChartStateChange(ChartState.precipitation);
                  },
                  icon: const Icon(Icons.water_drop)),
              // rain

              IconButton(
                  color:
                      _chartState == ChartState.windSpeed ? fg : unselectedIcon,
                  onPressed: () {
                    _onChartStateChange(ChartState.windSpeed);
                  },
                  icon: const Icon(Icons.wind_power)),
              IconButton(
                  color: _chartState == ChartState.windDirection
                      ? fg
                      : unselectedIcon,
                  onPressed: () {
                    _onChartStateChange(ChartState.windDirection);
                  },
                  icon: const Icon(Icons.flag)),
              IconButton(
                  color: _chartState == ChartState.tide ? fg : unselectedIcon,
                  onPressed: () {
                    _onChartStateChange(ChartState.tide);
                  },
                  icon: const Icon(Icons.waves)),
              // wind - speed / gust / dir
            ],
          ),
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
  windDirection,
  tide
}
