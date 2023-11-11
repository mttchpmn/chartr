import 'package:chartr/components/menu_drawer.dart';
import 'package:chartr/components/spinner.dart';
import 'package:chartr/gateways/waypoint_gateway.dart';
import 'package:chartr/models/waypoint.dart';
import 'package:flutter/material.dart';

class WaypointScreen extends StatefulWidget {
  const WaypointScreen({super.key});

  @override
  State<StatefulWidget> createState() => _WaypointScreenState();
}

class _WaypointScreenState extends State<WaypointScreen> {
  final WaypointGateway _waypointGateway = WaypointGateway();

  List<Waypoint> _waypoints = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWaypoints();
  }

  Future<void> _loadWaypoints() async {
    setState(() {
      _isLoading = true;
    });

    var wpts = await _waypointGateway.loadWaypointsFromDisk();

    setState(() {
      _waypoints = wpts;
      _isLoading = false;
    });
  }

  void _deleteWaypoint(Waypoint wpt) async {
    await _waypointGateway.deleteWaypoint(wpt.name);
    await _loadWaypoints();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return Scaffold(body: Spinner());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
      ),
      drawer: const MenuDrawer(),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: _waypoints.length,
                itemBuilder: (ctx, idx) {
                  var wpt = _waypoints[idx];

                  return ListTile(
                    leading: Icon(Icons.location_pin),
                    title: Text(wpt.name),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _deleteWaypoint(wpt);
                      },
                    ),
                    subtitle: Text(
                        "${wpt.latitude.toStringAsFixed(4)}, ${wpt.longitude.toStringAsFixed(4)} - ${wpt.description}"),
                  );
                }),
          ),
          Text("${_waypoints.length} total waypoints")
        ],
      ),
    );
  }
}
