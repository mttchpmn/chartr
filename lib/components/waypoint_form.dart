import 'dart:ffi';

import 'package:chartr/gateways/waypoint_gateway.dart';
import 'package:chartr/models/grid_ref.dart';
import 'package:chartr/models/waypoint.dart';
import 'package:chartr/services/coordinate_service.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class WaypointForm extends StatefulWidget {
  final VoidCallback onWaypointSaved;

  GridRef mapCenter;

  WaypointForm(
      {super.key, required this.onWaypointSaved, required this.mapCenter});

  @override
  State<WaypointForm> createState() => _WaypointFormState();
}

class _WaypointFormState extends State<WaypointForm> {
  final CoordinateService _coordinateService = CoordinateService();
  final WaypointGateway _waypointGateway = WaypointGateway();

  late TextEditingController _eastingsController;
  late TextEditingController _northingsController;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _eastingsController =
        TextEditingController(text: widget.mapCenter.eastings.toString());
    _northingsController =
        TextEditingController(text: widget.mapCenter.northings.toString());
  }

  void _onSaveWaypoint() {
    var e = int.parse(_eastingsController.text);
    var n = int.parse(_northingsController.text);
    var gr = GridRef(e, n);

    var latLng = _coordinateService.gridRefToLatLng(gr);
    var wpt = Waypoint(
        latitude: latLng.latitude,
        longitude: latLng.longitude,
        name: _nameController.text,
        description: _descriptionController.text);

    _waypointGateway.saveWaypoint(wpt);

    widget.onWaypointSaved();

    _eastingsController.clear();
    _northingsController.clear();
    _nameController.clear();
    _descriptionController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Save Waypoint",
          style: TextStyle(color: Colors.deepOrange),
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          children: [
            Expanded(
                child: TextField(
              controller: _eastingsController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                  labelText: "Eastings",
                  labelStyle: TextStyle(color: Colors.white),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepOrange)),
                  border: OutlineInputBorder()),
            )),
            const SizedBox(
              width: 10,
            ),
            Expanded(
                child: TextField(
              controller: _northingsController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                  labelText: "Northings",
                  labelStyle: TextStyle(color: Colors.white),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepOrange)),
                  border: OutlineInputBorder()),
            )),
          ],
        ),
        TextInput(
          controller: _nameController,
          label: "Name",
        ),
        TextInput(
          controller: _descriptionController,
          label: "Description",
        ),
        const SizedBox(
          height: 20,
        ),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
            onPressed: () {
              Navigator.of(context).pop();
              _onSaveWaypoint();
            },
            child: Text("Save Waypoint".toUpperCase()))
      ],
    );
  }
}

class TextInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;

  const TextInput({
    super.key,
    required this.controller,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(color: Colors.white),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.deepOrange)),
            border: const OutlineInputBorder()),
      ),
    );
  }
}
