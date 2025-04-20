import 'package:geolocator/geolocator.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class AppLatLong {
  final double lat;
  final double long;

  const AppLatLong({
    required this.lat,
    required this.long,
  });

  Point toPoint() => Point(latitude: lat, longitude: long);
}

class AstanaLocation extends AppLatLong {
  const AstanaLocation() : super(lat: 51.169392, long: 71.449074);
}

abstract class AppLocation {
  Future<AppLatLong> getCurrentLocation();
  Future<bool> requestPermission();
  Future<bool> checkPermission();
  Future<LocationPermission> getPermissionStatus();
}

class LocationService implements AppLocation {
  static const _defaultLocation = AstanaLocation();

  @override
  Future<AppLatLong> getCurrentLocation() async {
    try {
      final isServiceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!isServiceEnabled) {
        return _defaultLocation;
      }

      final permission = await checkPermission();
      if (!permission) {
        return _defaultLocation;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      return AppLatLong(lat: position.latitude, long: position.longitude);
    } catch (e) {
      return _defaultLocation;
    }
  }

  @override
  Future<bool> requestPermission() async {
    try {
      final status = await Geolocator.requestPermission();
      return _isPermissionGranted(status);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> checkPermission() async {
    try {
      final status = await Geolocator.checkPermission();
      return _isPermissionGranted(status);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<LocationPermission> getPermissionStatus() async {
    return await Geolocator.checkPermission();
  }

  bool _isPermissionGranted(LocationPermission status) {
    return status == LocationPermission.always ||
        status == LocationPermission.whileInUse;
  }

  Future<double> calculateDistance(
      AppLatLong start,
      AppLatLong end,
      ) async {
    return Geolocator.distanceBetween(
      start.lat,
      start.long,
      end.lat,
      end.long,
    );
  }

  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  Stream<AppLatLong> getLocationStream() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).map((position) => AppLatLong(
      lat: position.latitude,
      long: position.longitude,
    ));
  }
}