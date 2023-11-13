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
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 100,
          left: 15,
          child: MapButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: Colors.green,
                    content: Text('Started track recording'),
                  ),
                );
                widget.onStartTrackRecording();
              },
              icon: Icon(Icons.radio_button_checked)),
        ),
        Positioned(
          top: 150,
          left: 15,
          child: MapButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: Colors.orange,
                    content: Text('Paused track recording'),
                  ),
                );
                widget.onPauseTrackRecording();
              },
              icon: Icon(Icons.pause)),
        ),
        Positioned(
          top: 200,
          left: 15,
          child: MapButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
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
