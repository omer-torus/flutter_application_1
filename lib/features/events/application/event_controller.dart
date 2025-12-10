import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../data/repositories/event_repository_impl.dart';
import '../domain/entities/event_entity.dart';
import '../domain/repositories/event_repository.dart';
import 'event_state.dart';

class EventController extends StateNotifier<EventState> {
  EventController(this._repository) : super(const EventState());

  final EventRepository _repository;

  Future<void> loadEvents({
    required double latitude,
    required double longitude,
    List<String> categories = const [],
  }) async {
    state = state.copyWith(status: EventStatus.loading, error: null);
    try {
      final events = await _repository.getNearbyEvents(
        latitude: latitude,
        longitude: longitude,
        categories: categories,
      );
      state = state.copyWith(status: EventStatus.success, events: events);
    } catch (e) {
      state = state.copyWith(
        status: EventStatus.failure,
        error: e.toString(),
      );
    }
  }
}

final eventRepositoryProvider = Provider<EventRepository>((ref) {
  final ticketmasterService = ref.watch(ticketmasterServiceProvider);
  return EventRepositoryImpl(ticketmasterService);
});

final eventControllerProvider =
    StateNotifierProvider<EventController, EventState>((ref) {
  final repository = ref.watch(eventRepositoryProvider);
  return EventController(repository);
});



