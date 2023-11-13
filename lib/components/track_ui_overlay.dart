import 'package:chartr/components/map_button.dart';
import 'package:flutter/material.dart';

class TrackRecordingOverlay extends StatefulWidget {
  final VoidCallback onStartTrackRecording;
  final VoidCallback onPauseTrackRecording;
  final VoidCallback onSaveTrackRecording;

  const TrackRecordingOverlay(
      {super.key,
      required this.onStartTrackRecording,
      required this.onPauseTrackRecording,
      required this.onSaveTrackRecording});

  @override
  State<StatefulWidget> createState() => _TrackRecordingOverlayState();
}

class _TrackRecordingOverlayState extends State<TrackRecordingOverlay> {
  TrackRecordingState _state = TrackRecordingState.notStarted;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // NOT STARTED
        if (_state == TrackRecordingState.notStarted)
          Positioned(
            top: 100,
            left: 15,
            child: MapButton(
                onPressed: () {
                  setState(() {
                    _state = TrackRecordingState.started;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      duration: Duration(seconds: 1),
                      backgroundColor: Colors.green,
                      content: Text('Started track recording'),
                    ),
                  );
                  widget.onStartTrackRecording();
                },
                icon: Icon(Icons.radio_button_checked)),
          ),

        // STARTED
        if (_state == TrackRecordingState.started)
          Positioned(
            top: 100,
            left: 15,
            child: MapButton(
                onPressed: () {
                  setState(() {
                    _state = TrackRecordingState.paused;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      duration: Duration(seconds: 1),
                      backgroundColor: Colors.orange,
                      content: Text('Paused track recording'),
                    ),
                  );
                  widget.onPauseTrackRecording();
                },
                icon: Icon(Icons.pause)),
          ),

        // PAUSED
        if (_state == TrackRecordingState.paused)
          Positioned(
            top: 100,
            left: 15,
            child: MapButton(
                onPressed: () {
                  setState(() {
                    _state = TrackRecordingState.started;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      duration: Duration(seconds: 1),
                      backgroundColor: Colors.green,
                      content: Text('Resumed track recording'),
                    ),
                  );
                  widget.onStartTrackRecording();
                },
                icon: Icon(Icons.play_arrow)),
          ),
        if (_state == TrackRecordingState.paused)
          Positioned(
            top: 150,
            left: 15,
            child: MapButton(
                onPressed: () {
                  setState(() {
                    _state = TrackRecordingState.notStarted;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      duration: Duration(seconds: 1),
                      backgroundColor: Colors.blue,
                      content: Text('Saved track recording'),
                    ),
                  );
                  widget.onSaveTrackRecording();
                },
                icon: Icon(Icons.save)),
          ),
      ],
    );
  }
}

enum TrackRecordingState { notStarted, started, paused }
