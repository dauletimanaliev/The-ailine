import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gghgggfsfs/presentation/client/_mapView.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'map_bloc.dart';
import 'package:gghgggfsfs/presentation/client/location.dart';

class MapHomeScreen extends StatefulWidget {
  const MapHomeScreen({super.key});

  @override
  State<MapHomeScreen> createState() => _MapHomeScreenState();
}

class _MapHomeScreenState extends State<MapHomeScreen> {
  final Completer<YandexMapController> _mapControllerCompleter = Completer();
  final List<MapObject> _mapObjects = [];
  Point? _userLocation;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    setState(() => _loading = true);

    // Запрашиваем текущее местоположение
    final permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      final position = await Geolocator.getCurrentPosition();
      _userLocation = Point(
        latitude: position.latitude,
        longitude: position.longitude,
      );

      // Добавляем маркер текущего местоположения
      _mapObjects.add(
        PlacemarkMapObject(
          mapId: const MapObjectId('user_location'),
          point: _userLocation!,
          icon: PlacemarkIcon.single(
            PlacemarkIconStyle(
              image: BitmapDescriptor.fromAssetImage('assets/user_pin.png'),
              scale: 0.5,
            ),
          ),
        ),
      );

      // Перемещаем камеру к текущему местоположению
      if (_mapControllerCompleter.isCompleted) {
        final controller = await _mapControllerCompleter.future;
        await controller.moveCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: _userLocation!, zoom: 15),
          ),
          animation: const MapAnimation(
            type: MapAnimationType.linear,
            duration: 1,
          ),
        );
      }
    }

    setState(() => _loading = false);
  }

  Future<void> _addCarWashMarkers() async {
    final carWashes = [
      Point(latitude: 55.751244, longitude: 37.618423),
      Point(latitude: 55.761244, longitude: 37.628423),
    ];

    for (int i = 0; i < carWashes.length; i++) {
      _mapObjects.add(
        PlacemarkMapObject(
          mapId: MapObjectId('car_wash_$i'),
          point: carWashes[i],
          icon: PlacemarkIcon.single(
            PlacemarkIconStyle(
              image: BitmapDescriptor.fromAssetImage('assets/car_wash_pin.png'),
            ),
          ),
          onTap: (_, __) => _showCarWashDetails(i),
        ),
      );
    }

    setState(() {});
  }

  void _showCarWashDetails(int id) {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Мойка #${id + 1}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                const Text('Адрес: ул. Примерная, 123'),
                const Text('Режим работы: 08:00-22:00'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Закрыть'),
                ),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MapBloc(LocationService()),
      child: Scaffold(body: MapView()),
    );
  }
}
