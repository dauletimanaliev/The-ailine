
import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:gghgggfsfs/presentation/client/location.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final LocationService _locationService;
  final Completer<YandexMapController> mapControllerCompleter = Completer<YandexMapController>();

  MapBloc(this._locationService) : super(MapInitialState()) {
    on<LoadMapEvent>(_onLoadMap);
    on<RequestLocationEvent>(_onRequestLocation);
    on<AddMarkersEvent>(_onAddMarkers);
  }

  Future<void> _onLoadMap(LoadMapEvent event, Emitter<MapState> emit) async {
    emit(MapLoadingState());
    await mapControllerCompleter.future;
    add(RequestLocationEvent());
    add(AddMarkersEvent());
    emit(MapLoadedState());
  }

  Future<void> _onRequestLocation(
      RequestLocationEvent event,
      Emitter<MapState> emit
      ) async {
    try {
      final isEnabled = await _locationService.isLocationServiceEnabled();
      if (!isEnabled) {
        emit(MapErrorState('Геолокация отключена на устройстве'));
        return;
      }

      final hasPermission = await _locationService.requestPermission();
      if (!hasPermission) {
        emit(MapErrorState('Необходимо разрешение на доступ к геолокации'));
        return;
      }

      final location = await _locationService.getCurrentLocation();
      final userPoint = location.toPoint();

      if (!mapControllerCompleter.isCompleted) {
        final controller = await mapControllerCompleter.future;
        await controller.moveCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: userPoint, zoom: 15),
          ),
          animation: const MapAnimation(
            type: MapAnimationType.smooth,
            duration: 1,
          ),
        );
      }

      emit(LocationUpdatedState(userPoint));
    } catch (e) {
      emit(MapErrorState('Ошибка получения местоположения: $e'));
    }
  }

  Future<void> _onAddMarkers(AddMarkersEvent event, Emitter<MapState> emit) async {
    try {
      final carWashes = [
        Point(latitude: 55.751244, longitude: 37.618423),
        Point(latitude: 55.761244, longitude: 37.628423),
      ];

      emit(MarkersUpdatedState(carWashes));
    } catch (e) {
      emit(MapErrorState('Ошибка загрузки моек: $e'));
    }
  }
}