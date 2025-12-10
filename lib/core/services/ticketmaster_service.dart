import 'dart:convert';

import 'package:dio/dio.dart';

import '../config/app_env.dart';

/// Ticketmaster Discovery API servisi
class TicketmasterService {
  TicketmasterService(this._dio);

  final Dio _dio;
  static const _baseUrl = 'https://app.ticketmaster.com/discovery/v2';

  Future<List<Map<String, dynamic>>> fetchEvents({
    required double lat,
    required double lng,
    int radius = 50,
    List<String> categories = const [],
    int size = 50,
  }) async {
    final apiKey = AppEnv.ticketmasterApiKey;
    if (apiKey.isEmpty || apiKey == 'ticketmaster-api-key') {
      throw Exception(
        'Ticketmaster API anahtarı bulunamadı. Lütfen .env dosyasına TICKETMASTER_API_KEY ekleyin.',
      );
    }

    final params = <String, dynamic>{
      'apikey': apiKey,
      'latlong': '$lat,$lng',
      'radius': radius,
      'unit': 'km',
      'sort': 'date,asc',
      'locale': '*', // tüm diller
      'size': size,
    };

    if (categories.isNotEmpty) {
      params['classificationName'] = categories.join(',');
    }

    final response = await _dio.get(
      '$_baseUrl/events.json',
      queryParameters: params,
    );

    final data =
        response.data is String ? jsonDecode(response.data as String) : response.data;

    final embedded = data['_embedded'] as Map<String, dynamic>?;
    if (embedded == null || embedded['events'] == null) {
      return [];
    }

    final events = embedded['events'] as List;
    return events.cast<Map<String, dynamic>>();
  }
}



