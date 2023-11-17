import 'package:chartr/blocs/active_track_bloc.dart';
import 'package:chartr/components/map_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TrackRecordingOverlay extends StatefulWidget {
  const TrackRecordingOverlay({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _TrackRecordingOverlayState();
}

class _TrackRecordingOverlayState extends State<TrackRecordingOverlay> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BlocBuilder<ActiveTrackBloc, ActiveTrackState>(
            builder: (context, state) {
          // NOT STARTED
          if (state is TrackNotStarted) {
            return Positioned(
              top: 100,
              left: 15,
              child: MapButton(
                  onPressed: () {
                    BlocProvider.of<ActiveTrackBloc>(context)
                        .add(StartTrackingEvent());
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        duration: Duration(seconds: 1),
                        backgroundColor: Colors.green,
                        content: Text('Started track recording'),
                      ),
                    );
                  },
                  icon: Icon(Icons.radio_button_checked)),
            );
          }

          // STARTED
          if (state is TrackInProgress || state is TrackUpdated) {
            return Positioned(
              top: 100,
              left: 15,
              child: MapButton(
                  onPressed: () {
                    BlocProvider.of<ActiveTrackBloc>(context)
                        .add(PauseTrackingEvent());
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        duration: Duration(seconds: 1),
                        backgroundColor: Colors.orange,
                        content: Text('Paused track recording'),
                      ),
                    );
                  },
                  icon: Icon(Icons.pause)),
            );
          }

          // PAUSED
          if (state is TrackPaused) {
            return Stack(children: [
              Positioned(
                top: 100,
                left: 15,
                child: MapButton(
                    onPressed: () {
                      BlocProvider.of<ActiveTrackBloc>(context)
                          .add(ResumeTrackingEvent());
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          duration: Duration(seconds: 1),
                          backgroundColor: Colors.green,
                          content: Text('Resumed track recording'),
                        ),
                      );
                    },
                    icon: Icon(Icons.play_arrow)),
              ),
              Positioned(
                top: 150,
                left: 15,
                child: MapButton(
                    onPressed: () {
                      BlocProvider.of<ActiveTrackBloc>(context)
                          .add(SaveTrackingEvent());
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          duration: Duration(seconds: 1),
                          backgroundColor: Colors.blue,
                          content: Text('Saved track recording'),
                        ),
                      );
                    },
                    icon: Icon(Icons.save)),
              ),
              Positioned(
                top: 200,
                left: 15,
                child: MapButton(
                    onPressed: () {
                      BlocProvider.of<ActiveTrackBloc>(context)
                          .add(DiscardTrackingEvent());
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          duration: Duration(seconds: 1),
                          backgroundColor: Colors.red,
                          content: Text('Discarded track recording'),
                        ),
                      );
                    },
                    icon: Icon(Icons.delete)),
              )
            ]);
          }

          throw UnimplementedError("State: ${state.toString()} not supported");
        })
      ],
    );
  }
}

enum TrackRecordingState { notStarted, started, paused }
