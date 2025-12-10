import '../domain/entities/event_entity.dart';

enum EventStatus { initial, loading, success, failure }

class EventState {
  const EventState({
    this.status = EventStatus.initial,
    this.events = const [],
    this.error,
  });

  final EventStatus status;
  final List<EventEntity> events;
  final String? error;

  EventState copyWith({
    EventStatus? status,
    List<EventEntity>? events,
    String? error,
  }) {
    return EventState(
      status: status ?? this.status,
      events: events ?? this.events,
      error: error,
    );
  }
}


