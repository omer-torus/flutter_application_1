import '../entities/place_entity.dart';

abstract class PlaceRepository {
  Future<List<PlaceEntity>> getNearbyPlaces({
    required double latitude,
    required double longitude,
    List<String> categories,
    bool forceRefresh,
  });
}


