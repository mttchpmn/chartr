import 'package:flutter/material.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Text("MENU"),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed("/home");
              },
              child: const Row(
                children: [Icon(Icons.home), Text("Home")],
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed("/weather");
              },
              child: const Row(
                children: [Icon(Icons.sunny), Text("Weather")],
              ),
            )
          ],
        ),
      ),
    );
  }
}
