import 'dart:async';

import 'package:chartr/services/location_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final LocationService _locationService = LocationService(5);
  bool _locationSet = false;

  LocationBloc() : super(LocationUnsetState()) {
    on<StartTrackingLocationEvent>(_onStartTrackingLocation);
  }

  FutureOr<void> _onStartTrackingLocation(
      StartTrackingLocationEvent event, Emitter<LocationState> emit) async {
    await _locationService.initializeAsync();
    var stream = _locationService.startPassiveTracking();

    await emit.forEach(stream, onData: (location) {
      if (!_locationSet) {
        _locationSet = true;
        return LocationSetState(location: location);
      }

      return LocationUpdatedState(location: location);
    });
  }
}

abstract class LocationEvent {}

class StartTrackingLocationEvent extends LocationEvent {}

abstract class LocationState {}

class LocationUnsetState extends LocationState {}

class LocationStateWithLocation extends LocationState {
  final LatLng location;

  LocationStateWithLocation({required this.location});
}

class LocationSetState extends LocationStateWithLocation {
  LocationSetState({required super.location});
}

class LocationUpdatedState extends LocationStateWithLocation {
  LocationUpdatedState({required super.location});
}
