
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'map_bloc.dart';

class MapView extends StatelessWidget {
  const MapView();

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<MapBloc>();

    return BlocConsumer<MapBloc, MapState>(
      listener: (context, state) {
        if (state is MapErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        final mapObjects = <MapObject>[];

        if (state is LocationUpdatedState) {
          mapObjects.add(PlacemarkMapObject(
            mapId: const MapObjectId('user'),
            point: state.position,
            icon: PlacemarkIcon.single(
              PlacemarkIconStyle(
                image: BitmapDescriptor.fromAssetImage('assets/user.png'),
                scale: 0.7,
              ),
            ),
          ));
        }

        if (state is MarkersUpdatedState) {
          for (int i = 0; i < state.markers.length; i++) {
            mapObjects.add(PlacemarkMapObject(
              mapId: MapObjectId('marker_$i'),
              point: state.markers[i],
              icon: PlacemarkIcon.single(
                PlacemarkIconStyle(
                  image: BitmapDescriptor.fromAssetImage('assets/marker.png'),
                ),
              ),
              onTap: (_, __) => _showDetails(context, i),
            ));
          }
        }

        return Stack(
          children: [
            YandexMap(
                onMapCreated: (controller) async {
                  if(!bloc.mapControllerCompleter.isCompleted) {
                    bloc.mapControllerCompleter.complete(controller);
                  }
                  await controller.moveCamera(
                    CameraUpdate.newCameraPosition(
                      const CameraPosition(
                        target: Point(latitude: 51.169392, longitude: 71.449074),
                        zoom: 12,
                      ),
                    ),
                    animation: const MapAnimation(
                      type: MapAnimationType.linear,
                      duration: 1,
                    ),
                  );

                  bloc.add(LoadMapEvent());
                }
            ),
            if (state is MapLoadingState)
              const Center(child: CircularProgressIndicator()),
          ],
        );
      },
    );
  }

  void _showDetails(BuildContext context, int id) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Мойка #${id + 1}', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 16),
            const Text('Адрес: ул. Примерная, 123'),
            const Text('Режим работы: 08:00-22:00'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Закрыть'),
            ),
          ],
        ),
      ),
    );
  }
}