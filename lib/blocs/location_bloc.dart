import 'dart:async';

import 'package:chartr/services/location_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final LocationService _locationService = LocationService(5);

  LocationBloc() : super(LocationUnsetState()) {
    on<StartTrackingLocationEvent>(_onStartTrackingLocation);
  }

  FutureOr<void> _onStartTrackingLocation(
      StartTrackingLocationEvent event, Emitter<LocationState> emit) async {
    var stream = _locationService.startPassiveTracking();

    await emit.forEach(stream, onData: (location) {
      return LocationUpdatedState(location: location);
    });

  }
}

abstract class LocationEvent {}

class StartTrackingLocationEvent extends LocationEvent {}

abstract class LocationState {}

class LocationUnsetState extends LocationState {}

class LocationUpdatedState extends LocationState {
  final LatLng location;

  LocationUpdatedState({required this.location});
}
