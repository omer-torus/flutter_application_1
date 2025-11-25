import 'package:supabase_flutter/supabase_flutter.dart';

import '../../features/places/data/models/place_model.dart';

class SupabaseCacheService {
  SupabaseCacheService(this._client);

  final SupabaseClient _client;

  SupabaseQueryBuilder get _places => _client.from('places');

  Future<List<PlaceModel>> fetchCachedPlaces({
    required double lat,
    required double lng,
    double radiusKm = 5,
  }) async {
    final degreeRadius = radiusKm / 110;
    final response = await _places
        .select()
        .filter('lat', 'gte', lat - degreeRadius)
        .filter('lat', 'lte', lat + degreeRadius)
        .filter('lng', 'gte', lng - degreeRadius)
        .filter('lng', 'lte', lng + degreeRadius)
        .limit(200);

    return response.map(PlaceModel.fromJson).toList();
  }

  Future<void> upsertPlaces(List<PlaceModel> places) async {
    if (places.isEmpty) return;

    await _places.upsert(
      places.map((e) => e.toJson()).toList(),
      onConflict: 'google_place_id',
    );
  }
}

