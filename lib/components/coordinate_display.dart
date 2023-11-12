import 'package:chartr/models/grid_ref.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class CoordinateDisplay extends StatefulWidget {
  LatLng? mapCenter;
  GridRef? mapCenterGrid;

  @override
  State<StatefulWidget> createState() {
    return CoordinateDisplayState();
  }

  CoordinateDisplay(
      {super.key, required this.mapCenter, required this.mapCenterGrid});
}

class CoordinateDisplayState extends State<CoordinateDisplay> {
  bool _displayGrid = true;

  @override
  Widget build(BuildContext context) {
    var bg = Theme.of(context).colorScheme.secondary;
    var fg = Theme.of(context).colorScheme.primary;

    return Container(
        decoration:
            BoxDecoration(borderRadius: BorderRadius.circular(8), color: bg),
        child: Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, bottom: 2, top: 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: !_displayGrid,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _displayGrid = !_displayGrid;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Changed to Grid Reference (NZTM)'),
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "LAT: ${widget.mapCenter?.latitude.toStringAsFixed(6) ?? ""}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: fg),
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        "LNG: ${widget.mapCenter?.longitude.toStringAsFixed(6) ?? ""}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: fg),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: _displayGrid,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _displayGrid = !_displayGrid;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Changed to Lat/Lng (WGS84)'),
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "E: ${widget.mapCenterGrid?.eastings ?? ""}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: fg),
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        "N: ${widget.mapCenterGrid?.northings ?? ""}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: fg),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
