class EventEntity {
  const EventEntity({
    required this.id,
    required this.name,
    required this.category,
    required this.startDate,
    required this.venueName,
    required this.city,
    required this.country,
    required this.latitude,
    required this.longitude,
    this.imageUrl,
    this.priceRange,
    this.url,
    this.description,
  });

  final String id;
  final String name;
  final String category;
  final DateTime? startDate;
  final String venueName;
  final String city;
  final String country;
  final double? latitude;
  final double? longitude;
  final String? imageUrl;
  final String? priceRange;
  final String? url;
  final String? description;

}


