import 'package:flutter/foundation.dart';
import 'api_service.dart';
import 'place_service.dart';

/// Chat request model
class ChatRequest {
  final String message;
  final String sessionId;
  final double? userLat;
  final double? userLon;

  ChatRequest({
    required this.message,
    this.sessionId = 'user123',
    this.userLat,
    this.userLon,
  });

  Map<String, dynamic> toJson() => {
    'message': message,
    'session_id': sessionId,
    if (userLat != null) 'user_lat': userLat,
    if (userLon != null) 'user_lon': userLon,
  };
}

/// Chat response model
class ChatResponse {
  final String answer;
  final List<PlaceDTO> places;
  final String queryType;
  final int totalPlaces;
  final Map<String, double>? userLocation;

  ChatResponse({
    required this.answer,
    required this.places,
    required this.queryType,
    this.totalPlaces = 0,
    this.userLocation,
  });

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    debugPrint('🔍 Parsing ChatResponse from: ${json.keys.toList()}');
    debugPrint('🔍 Answer: ${json['answer']}');
    debugPrint('🔍 Places count: ${(json['places'] as List?)?.length ?? 0}');

    return ChatResponse(
      answer: json['answer'] ?? '',
      places:
          (json['places'] as List<dynamic>?)
              ?.map((e) => PlaceDTO.fromJson(e))
              .toList() ??
          [],
      queryType: json['query_type'] ?? 'general',
      totalPlaces: json['total_places'] ?? 0,
      userLocation: (json['user_location'] as Map<String, dynamic>?)?.map(
        (k, v) => MapEntry(k, (v as num).toDouble()),
      ),
    );
  }
}

/// Itinerary save request
class ItinerarySaveRequest {
  final String sessionId;
  final String title;
  final String content;
  final List<Map<String, dynamic>> places;

  ItinerarySaveRequest({
    this.sessionId = 'user123',
    this.title = 'Untitled Itinerary',
    this.content = '',
    this.places = const [],
  });

  Map<String, dynamic> toJson() => {
    'session_id': sessionId,
    'title': title,
    'content': content,
    'places': places,
  };
}

/// Itinerary save response
class ItinerarySaveResponse {
  final bool success;
  final String message;
  final int itineraryId;

  ItinerarySaveResponse({
    required this.success,
    required this.message,
    required this.itineraryId,
  });

  factory ItinerarySaveResponse.fromJson(Map<String, dynamic> json) {
    return ItinerarySaveResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      itineraryId: json['itinerary_id'] ?? 0,
    );
  }
}

/// Service for Chat API
class ChatService {
  final ApiService _api;

  ChatService(this._api);

  /// POST /chat - Send chat message
  Future<ChatResponse> chat(ChatRequest request) async {
    // Use longer timeout for AI processing (90 seconds)
    final response = await _api.post(
      '/chat',
      body: request.toJson(),
      timeout: const Duration(seconds: 90),
    );
    debugPrint('🔍 Chat API Response: $response');
    debugPrint('🔍 Response type: ${response.runtimeType}');
    return ChatResponse.fromJson(response);
  }

  /// GET /chat/config - Get chat configuration
  Future<Map<String, dynamic>> getChatConfig() async {
    return await _api.get('/chat/config');
  }

  /// POST /chat/itinerary/save - Save itinerary
  Future<ItinerarySaveResponse> saveItinerary(
    ItinerarySaveRequest request,
  ) async {
    final response = await _api.post(
      '/chat/itinerary/save',
      body: request.toJson(),
    );
    return ItinerarySaveResponse.fromJson(response);
  }

  /// GET /chat/itinerary/list/{session_id} - List itineraries
  Future<List<Map<String, dynamic>>> listItineraries(String sessionId) async {
    final response = await _api.get('/chat/itinerary/list/$sessionId');
    return (response['itineraries'] as List<dynamic>?)
            ?.cast<Map<String, dynamic>>() ??
        [];
  }
}
