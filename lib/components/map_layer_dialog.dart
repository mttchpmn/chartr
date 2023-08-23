import 'package:chartr/components/map_icons.dart';
import 'package:chartr/models/map_type.dart';
import 'package:flutter/material.dart';

class MapLayerDialog extends StatelessWidget {
  final Function(MapType) onIconPressed;

  MapLayerDialog({required this.onIconPressed});

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text('Select Map Type'),
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                  icon: Icon(MapIcons.car),
                  onPressed: () => onIconPressed(MapType.openStreetMap)),
              IconButton(
                  icon: Icon(MapIcons.mountain),
                  onPressed: () => onIconPressed(MapType.topo50)),
              IconButton(
                  icon: Icon(MapIcons.satellite),
                  onPressed: () => onIconPressed(MapType.satellite)),
              IconButton(
                  icon: Icon(MapIcons.ship),
                  onPressed: () => onIconPressed(MapType.marine)),
            ],
          ),
        )
      ],
    );
  }
}
