
part of 'map_bloc.dart';

abstract class MapState extends Equatable {
  const MapState();

  @override
  List<Object> get props => [];
}

class MapInitialState extends MapState {}
class MapLoadingState extends MapState {}
class MapLoadedState extends MapState {}
class MapErrorState extends MapState {
  final String message;
  const MapErrorState(this.message);
}
class LocationUpdatedState extends MapState {
  final Point position;
  const LocationUpdatedState(this.position);
}
class MarkersUpdatedState extends MapState {
  final List<Point> markers;
  const MarkersUpdatedState(this.markers);
}