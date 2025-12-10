import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../data/repositories/place_repository_impl.dart';
import '../domain/repositories/place_repository.dart';
import 'place_state.dart';

class PlaceController extends StateNotifier<PlaceState> {
  PlaceController(this._repository) : super(const PlaceState());

  final PlaceRepository _repository;

  Future<void> loadNearby({
    required double latitude,
    required double longitude,
    List<String> categories = const [],
    bool forceRefresh = false,
  }) async {
    state = state.copyWith(status: PlaceStatus.loading, error: null);

    try {
      final places = await _repository.getNearbyPlaces(
        latitude: latitude,
        longitude: longitude,
        categories: categories,
        forceRefresh: forceRefresh,
      );
      state = state.copyWith(status: PlaceStatus.success, places: places);
    } catch (error) {
      state = state.copyWith(status: PlaceStatus.failure, error: error.toString());
    }
  }
}

final placeRepositoryProvider = Provider<PlaceRepository>((ref) {
  final overpass = ref.watch(overpassServiceProvider);
  final cache = ref.watch(supabaseCacheServiceProvider);
  return PlaceRepositoryImpl(
    overpassService: overpass,
    cacheService: cache,
  );
});

final placeControllerProvider =
    StateNotifierProvider<PlaceController, PlaceState>((ref) {
  final repository = ref.watch(placeRepositoryProvider);
  return PlaceController(repository);
});

