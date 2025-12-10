import 'package:uuid/uuid.dart';

import '../../../../core/services/overpass_service.dart';
import '../../../../core/services/supabase_cache_service.dart';
import '../../domain/entities/place_entity.dart';
import '../../domain/repositories/place_repository.dart';
import '../models/place_model.dart';

class PlaceRepositoryImpl implements PlaceRepository {
  PlaceRepositoryImpl({
    required OverpassService overpassService,
    required SupabaseCacheService cacheService,
  })  : _overpassService = overpassService,
        _cacheService = cacheService;

  final OverpassService _overpassService;
  final SupabaseCacheService _cacheService;
  final _uuid = const Uuid();

  /// OSM ID'yi UUID'ye çevir (deterministik)
  String _osmIdToUuid(String osmId) {
    // UUID v5 kullanarak OSM ID'den UUID oluştur
    // Namespace olarak özel bir UUID kullan (OSM için sabit)
    const osmNamespace = '6ba7b810-9dad-11d1-80b4-00c04fd430c8'; // ISO OID namespace
    return _uuid.v5(osmNamespace, 'osm:$osmId');
  }

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

    // Overpass API'den mekanları çek (ÜCRETSİZ! 🎉)
    final overpassResults = await _overpassService.nearbySearch(
      lat: latitude,
      lng: longitude,
      radius: 5000, // 5km yarıçap
      categories: categories,
    );

    final places = overpassResults.map((data) {
      final types = (data['types'] as List?)?.cast<String>() ?? const [];
      final location = data['geometry']?['location'] as Map<String, dynamic>? ?? {};
      final osmId = data['place_id'] as String;

      return PlaceModel(
        id: _osmIdToUuid(osmId), // OSM ID'yi UUID'ye çevir
        name: data['name'] as String? ?? 'Unknown',
        category: types.isNotEmpty ? types.first : 'general',
        description: data['description'] as String?,
        latitude: (location['lat'] as num?)?.toDouble() ?? latitude,
        longitude: (location['lng'] as num?)?.toDouble() ?? longitude,
        rating: (data['rating'] as num?)?.toDouble(),
        priceLevel: data['price_level'] as int?,
        images: const [],
        source: 'openstreetmap',
        googlePlaceId: osmId, // Orijinal OSM ID'yi sakla
      );
    }).toList();

    await _cacheService.upsertPlaces(places);
    return places;
  }
}

