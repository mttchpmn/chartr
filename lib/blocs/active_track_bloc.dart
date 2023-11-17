import 'dart:async';

import 'package:chartr/models/Track.dart';
import 'package:chartr/services/location_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ActiveTrackBloc extends Bloc<ActiveTrackEvent, ActiveTrackState> {
  final LocationService _locationService = LocationService(1);
  StreamSubscription<TrackPoint>? _locationSubscription;

  ActiveTrackBloc() : super(TrackNotStarted()) {
    on<StartTrackingEvent>((event, emit) async {
      await _locationSubscription?.cancel();
      var stream = _locationService.startActiveTracking();

      emit(TrackInProgress(track: _locationService.getActiveTrack()));

      await emit.forEach(stream, onData: (trackPoint) {
        return TrackUpdated(track: _locationService.getActiveTrack());
      });
    });

    on<PauseTrackingEvent>((event, emit) {
      _locationService.stopActiveTracking();
      emit(TrackPaused(track: _locationService.getActiveTrack()));
    });

    on<ResumeTrackingEvent>((event, emit) {
      _locationService.startActiveTracking();
      emit(TrackInProgress(track: _locationService.getActiveTrack()));
    });

    on<SaveTrackingEvent>((event, emit) async {
      _locationService.saveActiveTrack();
      await _locationSubscription?.cancel();
      emit(TrackNotStarted());
    });

    on<DiscardTrackingEvent>((event, emit) async {
      _locationService.discardActiveTrack();
      await _locationSubscription?.cancel();
      emit(TrackNotStarted());
    });
  }

  @override
  Future<void> close() {
    _locationSubscription?.cancel(); //
    return super.close();
  }
}

abstract class ActiveTrackEvent {}

class StartTrackingEvent extends ActiveTrackEvent {}

class PauseTrackingEvent extends ActiveTrackEvent {}

class ResumeTrackingEvent extends ActiveTrackEvent {}

class SaveTrackingEvent extends ActiveTrackEvent {}

class DiscardTrackingEvent extends ActiveTrackEvent {}

abstract class ActiveTrackState {}

abstract class ActiveTrackStateWithTrack extends ActiveTrackState {
  final List<TrackPoint> track;

  ActiveTrackStateWithTrack({required this.track});
}

class TrackNotStarted extends ActiveTrackState {}

class TrackInProgress extends ActiveTrackStateWithTrack {
  TrackInProgress({required super.track});
}

class TrackPaused extends ActiveTrackStateWithTrack {
  TrackPaused({required super.track});
}

class TrackUpdated extends ActiveTrackStateWithTrack {
  TrackUpdated({required super.track});
}
