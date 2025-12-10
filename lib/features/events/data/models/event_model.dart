import '../../domain/entities/event_entity.dart';

class EventModel extends EventEntity {
  const EventModel({
    required super.id,
    required super.name,
    required super.category,
    required super.startDate,
    required super.venueName,
    required super.city,
    required super.country,
    required super.latitude,
    required super.longitude,
    super.imageUrl,
    super.priceRange,
    super.url,
    super.description,
  });

  factory EventModel.fromTicketmaster(Map<String, dynamic> json) {
    final classifications = json['classifications'] as List?;
    final firstClassification =
        classifications != null && classifications.isNotEmpty ? classifications.first : null;
    final segment = firstClassification?['segment']?['name'] as String?;

    final embedded = json['_embedded'] as Map<String, dynamic>?;
    final venues = embedded?['venues'] as List?;
    final venue = venues != null && venues.isNotEmpty ? venues.first as Map<String, dynamic> : null;

    final location = venue?['location'] as Map<String, dynamic>?;
    final city = venue?['city']?['name'] as String? ?? 'Bilinmeyen Şehir';
    final country = venue?['country']?['name'] as String? ?? 'Bilinmeyen Ülke';
    final venueName = venue?['name'] as String? ?? 'Bilinmeyen Mekan';

    final images = json['images'] as List<dynamic>? ?? [];
    String? imageUrl;
    if (images.isNotEmpty) {
      images.sort((a, b) {
        final widthA = a['width'] as int? ?? 0;
        final widthB = b['width'] as int? ?? 0;
        return widthB.compareTo(widthA);
      });
      imageUrl = images.first['url'] as String?;
    }

    final dateMap = json['dates']?['start'] as Map<String, dynamic>?;
    DateTime? startDate;
    if (dateMap != null) {
      final localDate = dateMap['dateTime'] as String? ?? dateMap['localDate'] as String?;
      if (localDate != null) {
        startDate = DateTime.tryParse(localDate);
      }
    }

    final priceRanges = json['priceRanges'] as List?;
    String? priceText;
    if (priceRanges != null && priceRanges.isNotEmpty) {
      final price = priceRanges.first;
      final min = price['min'];
      final max = price['max'];
      final currency = price['currency'] ?? 'TRY';
      if (min != null && max != null) {
        priceText = '$min-$max $currency';
      } else if (min != null) {
        priceText = '$min $currency';
      }
    }

    return EventModel(
      id: json['id'] as String,
      name: json['name'] as String? ?? 'Bilinmeyen Etkinlik',
      category: segment ?? 'Etkinlik',
      startDate: startDate,
      venueName: venueName,
      city: city,
      country: country,
      latitude: (location?['latitude'] as String?) != null
          ? double.tryParse(location!['latitude'] as String)
          : null,
      longitude: (location?['longitude'] as String?) != null
          ? double.tryParse(location!['longitude'] as String)
          : null,
      imageUrl: imageUrl,
      priceRange: priceText,
      url: json['url'] as String?,
      description: json['info'] as String? ?? json['pleaseNote'] as String?,
    );
  }
}



