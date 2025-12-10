import '../../../../core/services/ticketmaster_service.dart';
import '../../domain/entities/event_entity.dart';
import '../../domain/repositories/event_repository.dart';
import '../models/event_model.dart';

class EventRepositoryImpl implements EventRepository {
  EventRepositoryImpl(this._ticketmasterService);

  final TicketmasterService _ticketmasterService;

  @override
  Future<List<EventEntity>> getNearbyEvents({
    required double latitude,
    required double longitude,
    List<String> categories = const [],
    int radius = 50,
  }) async {
    final response = await _ticketmasterService.fetchEvents(
      lat: latitude,
      lng: longitude,
      radius: radius,
      categories: categories,
    );

    return response.map(EventModel.fromTicketmaster).toList();
  }
}



