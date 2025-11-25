import '../domain/entities/place_entity.dart';

enum PlaceStatus { initial, loading, success, failure }

class PlaceState {
  const PlaceState({
    this.status = PlaceStatus.initial,
    this.places = const [],
    this.error,
  });

  final PlaceStatus status;
  final List<PlaceEntity> places;
  final String? error;

  PlaceState copyWith({
    PlaceStatus? status,
    List<PlaceEntity>? places,
    String? error,
  }) {
    return PlaceState(
      status: status ?? this.status,
      places: places ?? this.places,
      error: error ?? this.error,
    );
  }
}

