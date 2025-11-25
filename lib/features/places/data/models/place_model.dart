import '../../domain/entities/place_entity.dart';

class PlaceModel extends PlaceEntity {
  const PlaceModel({
    required super.id,
    required super.name,
    required super.category,
    required super.latitude,
    required super.longitude,
    super.description,
    super.rating,
    super.priceLevel,
    super.images = const [],
    this.source = 'cached',
    this.googlePlaceId,
    this.popularityScore,
  });

  final String? googlePlaceId;
  final String source;
  final double? popularityScore;

  factory PlaceModel.fromJson(Map<String, dynamic> json) {
    return PlaceModel(
      id: json['id'].toString(),
      name: json['name'] as String? ?? 'Unknown',
      category: json['category'] as String? ?? 'general',
      latitude: (json['lat'] as num?)?.toDouble() ?? 0,
      longitude: (json['lng'] as num?)?.toDouble() ?? 0,
      description: json['description'] as String?,
      rating: (json['rating'] as num?)?.toDouble(),
      priceLevel: json['price_level'] as int?,
      images: (json['images'] as List?)?.cast<String>() ?? const [],
      source: json['source'] as String? ?? 'cached',
      googlePlaceId: json['google_place_id'] as String?,
      popularityScore: (json['popularity_score'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'description': description,
      'lat': latitude,
      'lng': longitude,
      'rating': rating,
      'price_level': priceLevel,
      'images': images,
      'source': source,
      'google_place_id': googlePlaceId,
      'popularity_score': popularityScore,
    };
  }

  PlaceModel copyWith({
    String? description,
    double? rating,
    int? priceLevel,
    List<String>? images,
    String? source,
    double? popularityScore,
  }) {
    return PlaceModel(
      id: id,
      name: name,
      category: category,
      latitude: latitude,
      longitude: longitude,
      description: description ?? this.description,
      rating: rating ?? this.rating,
      priceLevel: priceLevel ?? this.priceLevel,
      images: images ?? this.images,
      source: source ?? this.source,
      popularityScore: popularityScore ?? this.popularityScore,
      googlePlaceId: googlePlaceId,
    );
  }
}


