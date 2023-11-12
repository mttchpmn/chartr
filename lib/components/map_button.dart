import 'package:flutter/material.dart';

class MapButton extends StatelessWidget {
  final Icon icon;
  final VoidCallback onPressed;

  const MapButton({super.key, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Theme.of(context).colorScheme.primaryContainer),
      child: IconButton(
        onPressed: onPressed,
        icon: icon,
      ),
    );
  }
}
