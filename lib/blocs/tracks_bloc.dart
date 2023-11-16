import 'package:chartr/repositories/tracks_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/Track.dart';

class TracksBloc extends Bloc<TracksEvent, TracksState> {
  final TracksRepository _tracksRepository = TracksRepository();

  TracksBloc() : super(TracksLoading()) {
    on<LoadTracks>((event, emit) async {
      var tracks = await _tracksRepository.loadTracks();

      emit(TracksLoaded(tracks: tracks));
    });
  }
}

abstract class TracksState {}

class TracksLoading extends TracksState {}

class TracksLoaded extends TracksState {
  List<Track> tracks;

  TracksLoaded({required this.tracks});
}

abstract class TracksEvent {}

class LoadTracks extends TracksEvent {}
