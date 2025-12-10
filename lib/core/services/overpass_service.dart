import 'dart:convert';

import 'package:dio/dio.dart';

/// Overpass API Service - OpenStreetMap verilerini çekmek için
/// API Key GEREKMİYOR! %100 Ücretsiz! 🎉
class OverpassService {
  OverpassService(this._dio);

  final Dio _dio;
  static const _baseUrl = 'https://overpass-api.de/api/interpreter';

  /// Kategori -> OSM Tag mapping
  static const Map<String, String> _categoryToOsmTag = {
    'museum': 'tourism=museum',
    'restaurant': 'amenity=restaurant',
    'cafe': 'amenity=cafe',
    'hotel': 'tourism=hotel',
    'hostel': 'tourism=hostel',
    'park': 'leisure=park',
    'historic': 'historic',
    'attraction': 'tourism=attraction',
    'viewpoint': 'tourism=viewpoint',
    'monument': 'historic=monument',
    'castle': 'historic=castle',
    'ruins': 'historic=ruins',
    'shopping': 'shop',
    'bar': 'amenity=bar',
    'nightclub': 'amenity=nightclub',
    'beach': 'natural=beach',
    'mosque': 'amenity=place_of_worship',
    'church': 'amenity=place_of_worship',
  };

  /// Yakındaki mekanları bul
  /// 
  /// [lat] - Enlem
  /// [lng] - Boylam
  /// [radius] - Yarıçap (metre)
  /// [categories] - Kategoriler (museum, restaurant, etc.)
  Future<List<Map<String, dynamic>>> nearbySearch({
    required double lat,
    required double lng,
    int radius = 2000,
    List<String> categories = const [],
  }) async {
    try {
      // Overpass QL query oluştur
      final query = _buildQuery(lat, lng, radius, categories);

      // API'ye istek at
      final response = await _dio.post(
        _baseUrl,
        data: query,
        options: Options(
          headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        ),
      );

      // Response'u parse et
      final data = response.data is String 
          ? jsonDecode(response.data as String) 
          : response.data;

      final elements = (data['elements'] as List?) ?? [];

      // OSM verilerini standardize et
      return elements.map((element) => _parseOsmElement(element)).toList();
    } catch (e) {
      print('Overpass API Error: $e');
      return [];
    }
  }

  /// Overpass QL query oluştur
  String _buildQuery(double lat, double lng, int radius, List<String> categories) {
    final buffer = StringBuffer();
    buffer.write('[out:json][timeout:25];');
    buffer.write('(');

    if (categories.isEmpty) {
      // Genel sorgu - turistik yerler
      buffer.write('node["tourism"](around:$radius,$lat,$lng);');
      buffer.write('node["historic"](around:$radius,$lat,$lng);');
      buffer.write('node["amenity"~"restaurant|cafe|bar"](around:$radius,$lat,$lng);');
    } else {
      // Kategoriye göre sorgu
      for (final category in categories) {
        final osmTag = _categoryToOsmTag[category.toLowerCase()];
        if (osmTag != null) {
          if (osmTag.contains('=')) {
            // Spesifik tag (tourism=museum)
            final parts = osmTag.split('=');
            final key = parts[0];
            final value = parts.length > 1 ? parts[1] : '';
            
            if (value.isEmpty) {
              // Sadece key (historic)
              buffer.write('node["$key"](around:$radius,$lat,$lng);');
            } else {
              // Key=value (tourism=museum)
              buffer.write('node["$key"="$value"](around:$radius,$lat,$lng);');
            }
          } else {
            // Genel tag (shop)
            buffer.write('node["$osmTag"](around:$radius,$lat,$lng);');
          }
        }
      }
    }

    buffer.write(');');
    buffer.write('out body;');
    buffer.write('>;');
    buffer.write('out skel qt;');

    return buffer.toString();
  }

  /// OSM element'i parse et ve standart formata çevir
  Map<String, dynamic> _parseOsmElement(Map<String, dynamic> element) {
    final tags = element['tags'] as Map<String, dynamic>? ?? {};
    
    // ID oluştur (OSM node ID)
    final id = element['id']?.toString() ?? 'osm_${DateTime.now().millisecondsSinceEpoch}';
    
    // İsim (Türkçe öncelikli)
    final name = tags['name:tr'] as String? ?? 
                 tags['name'] as String? ?? 
                 tags['tourism'] as String? ??
                 tags['amenity'] as String? ??
                 'Unknown Place';

    // Kategori belirle
    final category = _determineCategory(tags);

    // Açıklama
    final description = tags['description'] as String? ??
                       tags['description:tr'] as String?;

    // Konum
    final lat = (element['lat'] as num?)?.toDouble() ?? 0.0;
    final lng = (element['lon'] as num?)?.toDouble() ?? 0.0;

    // Wikipedia/Wikimedia'dan rating tahmini (varsa)
    final hasWikipedia = tags['wikipedia'] != null || tags['wikidata'] != null;
    final rating = hasWikipedia ? 4.5 : null;

    // Açılış saatleri
    final openingHours = tags['opening_hours'] as String?;

    return {
      'place_id': id,
      'name': name,
      'types': [category],
      'geometry': {
        'location': {
          'lat': lat,
          'lng': lng,
        }
      },
      'rating': rating,
      'description': description,
      'opening_hours': openingHours,
      'tags': tags, // OSM tag'lerini sakla
    };
  }

  /// OSM tag'lerinden kategori belirle
  String _determineCategory(Map<String, dynamic> tags) {
    // Öncelik sırasına göre kontrol et
    if (tags.containsKey('tourism')) {
      final tourism = tags['tourism'] as String;
      if (tourism == 'museum') return 'museum';
      if (tourism == 'hotel') return 'hotel';
      if (tourism == 'hostel') return 'hostel';
      if (tourism == 'attraction') return 'attraction';
      if (tourism == 'viewpoint') return 'viewpoint';
      return 'tourism';
    }
    
    if (tags.containsKey('historic')) {
      final historic = tags['historic'] as String;
      if (historic == 'monument') return 'monument';
      if (historic == 'castle') return 'castle';
      if (historic == 'ruins') return 'ruins';
      return 'historic';
    }
    
    if (tags.containsKey('amenity')) {
      final amenity = tags['amenity'] as String;
      if (amenity == 'restaurant') return 'restaurant';
      if (amenity == 'cafe') return 'cafe';
      if (amenity == 'bar') return 'bar';
      if (amenity == 'nightclub') return 'nightclub';
      if (amenity == 'place_of_worship') {
        final religion = tags['religion'] as String?;
        if (religion == 'muslim') return 'mosque';
        if (religion == 'christian') return 'church';
      }
      return 'amenity';
    }
    
    if (tags.containsKey('leisure')) {
      if (tags['leisure'] == 'park') return 'park';
      return 'leisure';
    }
    
    if (tags.containsKey('shop')) {
      return 'shopping';
    }
    
    if (tags.containsKey('natural')) {
      if (tags['natural'] == 'beach') return 'beach';
      return 'nature';
    }
    
    return 'general';
  }

  /// Mekan detaylarını getir (OSM ID ile)
  Future<Map<String, dynamic>?> getPlaceDetails(String osmId) async {
    try {
      final query = '''
        [out:json];
        node($osmId);
        out body;
      ''';

      final response = await _dio.post(
        _baseUrl,
        data: query,
        options: Options(
          headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        ),
      );

      final data = response.data is String 
          ? jsonDecode(response.data as String) 
          : response.data;

      final elements = (data['elements'] as List?) ?? [];
      
      if (elements.isEmpty) return null;
      
      return _parseOsmElement(elements.first);
    } catch (e) {
      print('Overpass API Error (details): $e');
      return null;
    }
  }
}



