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
          MenuTile(
            icon: Icons.map,
            title: "NAVIGATION",
            destination: "/home",
          ),
          MenuTile(
            icon: Icons.sunny,
            title: "WEATHER",
            destination: "/weather",
          ),
          MenuTile(
            icon: Icons.location_pin,
            title: "WAYPOINTS",
            destination: "/waypoints",
          ),
          MenuTile(
            icon: Icons.route,
            title: "TRACKS",
            destination: "/tracks",
          ),
          Divider(),
          MenuTile(
            icon: Icons.cloud_download,
            title: "DOWNLOADS",
            destination: "/downloads",
          ),
          MenuTile(
            icon: Icons.settings,
            title: "SETTINGS",
            destination: "/settings",
          ),
        ],
      ),
    );
  }
}

class MenuTile extends StatelessWidget {
  IconData icon;
  String title;
  String destination;

  MenuTile({
    super.key,
    required this.icon,
    required this.title,
    required this.destination,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      onTap: () {
        Navigator.of(context).pushNamed(destination);
      },
    );
  }
}
