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
        IconButton(icon: Icon(Icons.home), onPressed: () => onIconPressed(MapType.openStreetMap)),
        IconButton(icon: Icon(Icons.work), onPressed: () => onIconPressed(MapType.topo50)),
        IconButton(icon: Icon(Icons.school), onPressed: () => onIconPressed(MapType.topo250)),
        IconButton(icon: Icon(Icons.pets), onPressed: () => onIconPressed(MapType.marine)),
      ],
    );
  }
}
