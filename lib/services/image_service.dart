import 'dart:io';
import 'api_service.dart';
import 'comment_service.dart';

/// Image upload response
class ImageUploadResponse {
  final bool success;
  final String message;
  final List<String> urls;

  ImageUploadResponse({
    required this.success,
    required this.message,
    required this.urls,
  });

  factory ImageUploadResponse.fromJson(Map<String, dynamic> json) {
    return ImageUploadResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      urls: (json['urls'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }
}

/// Service for Images API
class ImageService {
  final ApiService _api;

  ImageService(this._api);

  /// GET /comments/{comment_id}/images - Get comment images
  Future<List<ImageDTO>> getCommentImages(String commentId) async {
    final response = await _api.get('/comments/$commentId/images');
    return (response as List).map((e) => ImageDTO.fromJson(e)).toList();
  }

  /// GET /places/{place_id}/images - Get place images
  Future<List<ImageDTO>> getPlaceImages(String placeId) async {
    final response = await _api.get('/places/$placeId/images');
    return (response as List).map((e) => ImageDTO.fromJson(e)).toList();
  }

  /// POST /api/upload - Upload images
  Future<ImageUploadResponse> uploadImages(List<File> files) async {
    final response = await _api.uploadFiles('/api/upload', files);
    return ImageUploadResponse.fromJson(response);
  }
}
