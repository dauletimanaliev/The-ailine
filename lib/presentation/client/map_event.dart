
part of 'map_bloc.dart';

abstract class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object> get props => [];
}
class LoadMapEvent extends MapEvent {}
class RequestLocationEvent extends MapEvent {}
class AddMarkersEvent extends MapEvent {}