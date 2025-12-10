import '../entities/event_entity.dart';

abstract class EventRepository {
  Future<List<EventEntity>> getNearbyEvents({
    required double latitude,
    required double longitude,
    List<String> categories,
    int radius,
  });
}



