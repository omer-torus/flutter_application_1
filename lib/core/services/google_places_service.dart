import 'dart:convert';

import 'package:dio/dio.dart';

import '../config/app_env.dart';

class GooglePlacesService {
  GooglePlacesService(this._dio);

  final Dio _dio;
  static const _baseUrl = 'https://maps.googleapis.com/maps/api/place';

  Future<List<Map<String, dynamic>>> nearbySearch({
    required double lat,
    required double lng,
    int radius = 2000,
    List<String> types = const [],
  }) async {
    final params = <String, dynamic>{
      'location': '$lat,$lng',
      'radius': radius,
      if (types.isNotEmpty) 'types': types.join('|'),
      'key': AppEnv.googlePlacesKey,
    };

    final response = await _dio.get('$_baseUrl/nearbysearch/json', queryParameters: params);
    final data = response.data is String ? jsonDecode(response.data as String) : response.data;
    final results = data['results'] as List? ?? [];
    return results.cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>?> getPlaceDetails(String placeId) async {
    final response = await _dio.get(
      '$_baseUrl/details/json',
      queryParameters: {
        'place_id': placeId,
        'key': AppEnv.googlePlacesKey,
      },
    );
    final data = response.data is String ? jsonDecode(response.data as String) : response.data;
    return data['result'] as Map<String, dynamic>?;
  }
}

