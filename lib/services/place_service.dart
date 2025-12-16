import 'api_service.dart';
import '../models/place_model.dart';

/// Place API DTO (Data Transfer Object)
class PlaceDTO {
  final String id;
  final String name;
  final String? address;
  final String? phone;
  final String? website;
  final String? category;
  final double? rating;
  final int? ratingCount;
  final double latitude;
  final double longitude;
  final Map<String, dynamic>? openingHours;
  final Map<String, dynamic>? about;
  final double? distanceKm;
  final List<String>? images;
  // Chat-specific fields from ChatbotOrchestrator
  final Map<String, dynamic>? weather;
  final double? score;

  PlaceDTO({
    required this.id,
    required this.name,
    this.address,
    this.phone,
    this.website,
    this.category,
    this.rating,
    this.ratingCount,
    required this.latitude,
    required this.longitude,
    this.openingHours,
    this.about,
    this.distanceKm,
    this.images,
    this.weather,
    this.score,
  });

  factory PlaceDTO.fromJson(Map<String, dynamic> json) {
    // Backend returns flat latitude/longitude fields
    final lat = json['latitude'] ?? json['coordinates']?['lat'] ?? 0.0;
    final lon = json['longitude'] ?? json['coordinates']?['lon'] ?? 0.0;

    return PlaceDTO(
      id: json['id'] ?? json['place_id'] ?? '',
      name: json['name'] ?? '',
      address: json['address'],
      phone: json['phone'],
      website: json['website'],
      category: json['category'],
      rating: (json['rating'] as num?)?.toDouble(),
      ratingCount: json['rating_count'],
      latitude: (lat as num).toDouble(),
      longitude: (lon as num).toDouble(),
      openingHours: json['opening_hours'] is Map
          ? json['opening_hours']
          : (json['opening_hours'] is String
                ? {'raw': json['opening_hours']}
                : null),
      about: json['about'] is Map
          ? json['about']
          : (json['about'] is String ? {'text': json['about']} : null),
      distanceKm: (json['distance_km'] as num?)?.toDouble(),
      images: (json['images'] as List<dynamic>?)
          ?.map((e) {
            // Backend returns array of strings, not objects
            if (e is String) return e;
            if (e is Map) return e['url'] as String? ?? '';
            return e.toString();
          })
          .where((url) => url.isNotEmpty)
          .toList(),
      // Chat-specific fields from ChatbotOrchestrator
      weather: json['weather'] is Map ? json['weather'] : null,
      score: (json['score'] as num?)?.toDouble(),
    );
  }

  /// Format about object into human-readable text
  String _formatAbout(Map<String, dynamic> aboutData) {
    final List<String> sections = [];

    // Extract description text if present
    if (aboutData['description'] != null) {
      sections.add(aboutData['description'].toString());
    }
    if (aboutData['text'] != null) {
      sections.add(aboutData['text'].toString());
    }

    // Category labels with emojis
    final categoryLabels = {
      'amenities': '🏠 Tiện nghi',
      'service_options': '🍽️ Dịch vụ',
      'parking': '🅿️ Đỗ xe',
      'planning': '📋 Đặt chỗ',
      'beverages': '🍺 Đồ uống',
      'highlights': '⭐ Điểm nổi bật',
      'accessibility': '♿ Tiếp cận',
      'dining_options': '🍴 Phục vụ',
    };

    for (final entry in categoryLabels.entries) {
      final key = entry.key;
      final label = entry.value;

      if (aboutData[key] is Map) {
        final Map<String, dynamic> items = aboutData[key];
        final enabledItems = items.entries
            .where((e) => e.value == true)
            .map((e) => '• ${e.key}')
            .toList();
        if (enabledItems.isNotEmpty) {
          sections.add('$label\n${enabledItems.join('\n')}');
        }
      }
    }

    return sections.isNotEmpty
        ? sections.join('\n\n')
        : 'Không có thông tin chi tiết.';
  }

  /// Format opening hours into readable text
  String? _formatOpeningHours(Map<String, dynamic> hours) {
    if (hours.isEmpty) return null;

    final entries = hours.entries
        .map((e) {
          return '${e.key}: ${e.value}';
        })
        .join(', ');

    return entries.isNotEmpty ? entries : null;
  }

  /// Convert to app's Place model
  Place toPlace() {
    return Place(
      id: id,
      nameLocalized: {'vi': name, 'en': name},
      imageUrl: images?.isNotEmpty == true ? images!.first : '',
      rating: rating ?? 0.0,
      location: address ?? '',
      descriptionLocalized: about != null
          ? {'vi': _formatAbout(about!), 'en': _formatAbout(about!)}
          : null,
      commentCount: ratingCount ?? 0,
      latitude: latitude,
      longitude: longitude,
      price: null,
      openingTime: openingHours != null
          ? _formatOpeningHours(openingHours!)
          : null,
      website: website,
    );
  }
}

/// Service for Places API
class PlaceService {
  final ApiService _api;

  PlaceService(this._api);

  /// GET /places - Get list of places
  Future<List<PlaceDTO>> getPlaces({
    int skip = 0,
    int limit = 20,
    double? lat,
    double? lon,
    int? maxDistance,
    String? location,
    String? categories,
    double? minRating,
    String? search,
    String sortBy = 'rating',
  }) async {
    final response = await _api.get(
      '/places',
      queryParams: {
        'skip': skip,
        'limit': limit,
        if (lat != null) 'lat': lat,
        if (lon != null) 'lon': lon,
        if (maxDistance != null) 'max_distance': maxDistance,
        if (location != null) 'location': location,
        if (categories != null) 'categories': categories,
        if (minRating != null) 'min_rating': minRating,
        if (search != null) 'search': search,
        'sort_by': sortBy,
      },
    );

    return (response as List).map((e) => PlaceDTO.fromJson(e)).toList();
  }

  /// GET /places/nearby - Get nearby places
  Future<List<PlaceDTO>> getNearbyPlaces({
    required double lat,
    required double lon,
    int radius = 5,
    String? categories,
    double? minRating,
    int limit = 20,
  }) async {
    final response = await _api.get(
      '/places/nearby',
      queryParams: {
        'lat': lat,
        'lon': lon,
        'radius': radius,
        if (categories != null) 'categories': categories,
        if (minRating != null) 'min_rating': minRating,
        'limit': limit,
      },
    );

    return (response as List).map((e) => PlaceDTO.fromJson(e)).toList();
  }

  /// GET /places/categories - Get all categories
  Future<List<String>> getCategories() async {
    final response = await _api.get('/places/categories');
    return (response as List).cast<String>();
  }

  /// GET /places/{place_id} - Get place details
  Future<PlaceDTO> getPlace(String placeId) async {
    final response = await _api.get('/places/$placeId');
    return PlaceDTO.fromJson(response);
  }

  /// POST /places - Create new place
  Future<Map<String, dynamic>> createPlace({
    required String name,
    String? address,
    String? phone,
    String? website,
    String? category,
    double? rating,
    int? ratingCount,
    Map<String, dynamic>? openingHours,
    Map<String, dynamic>? about,
    Map<String, double>? coordinates,
  }) async {
    return await _api.post(
      '/places',
      body: {
        'name': name,
        if (address != null) 'address': address,
        if (phone != null) 'phone': phone,
        if (website != null) 'website': website,
        if (category != null) 'category': category,
        if (rating != null) 'rating': rating,
        if (ratingCount != null) 'rating_count': ratingCount,
        if (openingHours != null) 'opening_hours': openingHours,
        if (about != null) 'about': about,
        if (coordinates != null) 'coordinates': coordinates,
      },
    );
  }

  /// PUT /places/{place_id} - Update place
  Future<Map<String, dynamic>> updatePlace(
    String placeId, {
    String? name,
    String? address,
    String? phone,
    String? website,
    String? category,
    double? rating,
    int? ratingCount,
    Map<String, dynamic>? openingHours,
    Map<String, dynamic>? about,
    Map<String, double>? coordinates,
  }) async {
    return await _api.put(
      '/places/$placeId',
      body: {
        if (name != null) 'name': name,
        if (address != null) 'address': address,
        if (phone != null) 'phone': phone,
        if (website != null) 'website': website,
        if (category != null) 'category': category,
        if (rating != null) 'rating': rating,
        if (ratingCount != null) 'rating_count': ratingCount,
        if (openingHours != null) 'opening_hours': openingHours,
        if (about != null) 'about': about,
        if (coordinates != null) 'coordinates': coordinates,
      },
    );
  }

  /// DELETE /places/{place_id} - Delete place
  Future<dynamic> deletePlace(String placeId) async {
    return await _api.delete('/places/$placeId');
  }
}
