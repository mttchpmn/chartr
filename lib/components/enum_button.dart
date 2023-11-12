import 'package:flutter/material.dart';

class EnumButton<T> extends StatelessWidget {
  List<T> enumValues;
  T value;
  Function(T?) onChanged;

  EnumButton(
      {super.key,
      required this.enumValues,
      required this.value,
      required this.onChanged});

  List<DropdownMenuItem<T>> _getItems() {
    var result = enumValues
        .map((e) => DropdownMenuItem<T>(
            value: e, child: Text(e.toString().split(".").last)))
        .toList();

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<T>(
        value: value,
        dropdownColor: Theme.of(context).scaffoldBackgroundColor,
        items: _getItems(),
        onChanged: onChanged);
  }
}
