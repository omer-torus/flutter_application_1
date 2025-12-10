import 'package:geolocator/geolocator.dart';

/// Konum servisi - Kullanıcının GPS konumunu alır
class LocationService {
  /// Konum izni durumunu kontrol et
  Future<bool> checkPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Konum servisi açık mı?
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    // İzin durumunu kontrol et
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  /// Kullanıcının mevcut konumunu al
  Future<Position?> getCurrentLocation() async {
    try {
      // İzin kontrolü
      final hasPermission = await checkPermission();
      if (!hasPermission) {
        return null;
      }

      // Konum al
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      return position;
    } catch (e) {
      print('Location Error: $e');
      return null;
    }
  }

  /// Konum değişikliklerini dinle (realtime)
  Stream<Position> getLocationStream() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100, // 100 metre değişince güncelle
      ),
    );
  }

  /// İki nokta arasındaki mesafeyi hesapla (metre)
  double calculateDistance(
    double startLat,
    double startLng,
    double endLat,
    double endLng,
  ) {
    return Geolocator.distanceBetween(
      startLat,
      startLng,
      endLat,
      endLng,
    );
  }

  /// İki nokta arasındaki mesafeyi hesapla (km)
  double calculateDistanceInKm(
    double startLat,
    double startLng,
    double endLat,
    double endLng,
  ) {
    final distanceInMeters = calculateDistance(
      startLat,
      startLng,
      endLat,
      endLng,
    );
    return distanceInMeters / 1000;
  }

  /// Ayarlar sayfasını aç (izin reddi durumunda)
  Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }

  /// Uygulama ayarlarını aç (kalıcı red durumunda)
  Future<void> openAppSettings() async {
    await Geolocator.openAppSettings();
  }
}



