import 'package:chartr/models/grid_ref.dart';
import 'package:chartr/models/waypoint.dart';
import 'package:chartr/services/coordinate_service.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class WaypointIcon extends StatelessWidget {
  final Waypoint waypoint;

  const WaypointIcon({super.key, required this.waypoint});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _onWaypointTap(context);
      },
      child: Stack(
        children: [
          Center(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Icon(
                  Icons.pin_drop,
                  size: 16,
                  shadows: [Shadow()],
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 10,
                ),
                Text(
                  waypoint.name.length > 6
                      ? waypoint.name.substring(0, 6)
                      : waypoint.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  GridRef _getWaypointGridRef() {
    var latLng = LatLng(waypoint.latitude, waypoint.longitude);
    var grid = CoordinateService().latLngToGrid(latLng);

    return grid;
  }

  void _onWaypointTap(BuildContext context) {
    var grid = _getWaypointGridRef();

    showDialog(
        context: context,
        builder: (context) => SimpleDialog(
              title: Center(
                  child: Text("${waypoint.name} (${grid.toSixFigure()})")),
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(waypoint.description ?? ""),
                      Divider(),
                      Text(
                        "LAT: ${waypoint.latitude.toStringAsFixed(6)}",
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        "LNG: ${waypoint.longitude.toStringAsFixed(6)}",
                        textAlign: TextAlign.left,
                      ),
                      Divider(),
                      Text(
                        "E: ${grid.eastings}",
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        "N: ${grid.northings}",
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                )
              ],
            ));
  }
}
