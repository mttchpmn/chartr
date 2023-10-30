import 'dart:ffi';

import 'package:flutter/material.dart';

class WaypointForm extends StatefulWidget {
  final Function(String, String?) onSaveWaypoint;

  const WaypointForm({super.key, required this.onSaveWaypoint});

  @override
  State<WaypointForm> createState() => _WaypointFormState();
}

class _WaypointFormState extends State<WaypointForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

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
              widget.onSaveWaypoint(
                  _nameController.text, _descriptionController.text);
              _nameController.clear();
              _descriptionController.clear();
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
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(color: Colors.white),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.deepOrange)),
            border: OutlineInputBorder()),
      ),
    );
  }
}
