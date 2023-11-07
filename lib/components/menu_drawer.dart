import 'package:flutter/material.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.deepOrange,
            ),
            child: Text(
              'RANGR',
              style: TextStyle(fontSize: 32),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.map),
            title: const Text(
              'NAVIGATION',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.of(context).pushNamed("/home");
            },
          ),
          ListTile(
            leading: const Icon(Icons.sunny),
            title: const Text(
              'WEATHER',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.of(context).pushNamed("/weather");
            },
          ),
        ],
      ),
    );
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
