import '../../../../core/services/google_places_service.dart';
import '../../../../core/services/supabase_cache_service.dart';
import '../../domain/entities/place_entity.dart';
import '../../domain/repositories/place_repository.dart';
import '../models/place_model.dart';

class PlaceRepositoryImpl implements PlaceRepository {
  PlaceRepositoryImpl({
    required GooglePlacesService googlePlacesService,
    required SupabaseCacheService cacheService,
  })  : _googlePlacesService = googlePlacesService,
        _cacheService = cacheService;

  final GooglePlacesService _googlePlacesService;
  final SupabaseCacheService _cacheService;

  @override
  Future<List<PlaceEntity>> getNearbyPlaces({
    required double latitude,
    required double longitude,
    List<String> categories = const [],
    bool forceRefresh = false,
  }) async {
    final cached = forceRefresh
        ? <PlaceModel>[]
        : await _cacheService.fetchCachedPlaces(lat: latitude, lng: longitude);

    if (cached.isNotEmpty && categories.isEmpty) {
      return cached;
    }

    final googleResults = await _googlePlacesService.nearbySearch(
      lat: latitude,
      lng: longitude,
      types: categories,
    );

    final places = googleResults.map((data) {
      final types = (data['types'] as List?)?.cast<String>() ?? const [];
      final location = data['geometry']?['location'] as Map<String, dynamic>? ?? {};

      return PlaceModel(
        id: data['place_id'] as String,
        name: data['name'] as String? ?? 'Unknown',
        category: types.isNotEmpty ? types.first : 'general',
        latitude: (location['lat'] as num?)?.toDouble() ?? latitude,
        longitude: (location['lng'] as num?)?.toDouble() ?? longitude,
        rating: (data['rating'] as num?)?.toDouble(),
        priceLevel: data['price_level'] as int?,
        images: const [],
        source: 'google',
        googlePlaceId: data['place_id'] as String?,
      );
    }).toList();

    await _cacheService.upsertPlaces(places);
    return places;
  }
}

