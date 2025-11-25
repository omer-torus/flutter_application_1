class PlaceEntity {
  const PlaceEntity({
    required this.id,
    required this.name,
    required this.category,
    required this.latitude,
    required this.longitude,
    this.description,
    this.rating,
    this.priceLevel,
    this.images = const [],
  });

  final String id;
  final String name;
  final String category;
  final double latitude;
  final double longitude;
  final String? description;
  final double? rating;
  final int? priceLevel;
  final List<String> images;
}


