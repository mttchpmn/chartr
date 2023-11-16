import 'package:chartr/blocs/tracks_bloc.dart';
import 'package:chartr/components/menu_drawer.dart';
import 'package:chartr/components/spinner.dart';
import 'package:chartr/repositories/waypoint_gateway.dart';
import 'package:chartr/models/waypoint.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TracksScreen extends StatefulWidget {
  const TracksScreen({super.key});

  @override
  State<StatefulWidget> createState() => _TracksScreenState();
}

class _TracksScreenState extends State<TracksScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<TracksBloc>(context).add(LoadTracks());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        drawer: const MenuDrawer(),
        body: BlocBuilder<TracksBloc, TracksState>(
          builder: (context, state) {
            if (state is TracksLoading) {
              return CircularProgressIndicator();
            }
            if (state is TracksLoaded) {
              return ListView.builder(
                  itemCount: state.tracks.length,
                  itemBuilder: (ctx, idx) {
                    var track = state.tracks[idx];

                    return ListTile(
                      leading: Icon(Icons.route),
                      title: Text(track.name),
                    );
                  });
            }
            return Text("Error - state is ${state.toString()}");
          },
        ));
  }
}
