// VietSpot API Usage Examples
// Copy các đoạn code này vào project của bạn để sử dụng

import 'dart:io';
import 'package:flutter/material.dart';
import '../services/services.dart';

/// Ví dụ cách sử dụng VietSpot API Services
class ApiUsageExamples {
  late final ApiService _api;
  late final AuthService _authService;
  late final PlaceService _placeService;
  late final CommentService _commentService;
  late final ImageService _imageService;
  late final ChatService _chatService;
  late final UserService _userService;

  ApiUsageExamples() {
    // Khởi tạo services
    _api = ApiService();
    _authService = AuthService();
    _placeService = PlaceService(_api);
    _commentService = CommentService(_api);
    _imageService = ImageService(_api);
    _chatService = ChatService(_api);
    _userService = UserService(_api);
  }

  // ========================
  // AUTHENTICATION
  // ========================

  /// Đăng ký với email
  Future<void> signUpExample() async {
    final response = await _authService.signUpWithEmail(
      email: 'user@example.com',
      password: 'securePassword123',
      displayName: 'Nguyễn Văn A',
    );

    if (response.success) {
      debugPrint('Đăng ký thành công!');
      debugPrint('Kiểm tra email để xác nhận tài khoản');
    } else {
      debugPrint('Lỗi: ${response.message}');
    }
  }

  /// Đăng nhập với email
  Future<void> signInExample() async {
    final response = await _authService.signInWithEmail(
      email: 'user@example.com',
      password: 'securePassword123',
    );

    if (response.success && response.session != null) {
      debugPrint('Đăng nhập thành công!');
      debugPrint('User ID: ${response.session!.user.id}');
      debugPrint('Email: ${response.session!.user.email}');

      // Set user ID cho API service để các request khác sử dụng
      _api.setUserId(response.session!.user.id);
    } else {
      debugPrint('Lỗi: ${response.message}');
    }
  }

  /// Đăng nhập với OTP (gửi mã qua email/SMS)
  Future<void> signInWithOtpExample() async {
    // Bước 1: Gửi OTP
    final otpResponse = await _authService.signInWithOtp(
      email: 'user@example.com',
    );

    if (otpResponse.success) {
      debugPrint('OTP đã được gửi!');

      // Bước 2: Verify OTP (khi user nhập mã)
      final verifyResponse = await _authService.verifyOtp(
        email: 'user@example.com',
        token: '123456', // Mã OTP từ user
        type: 'email',
      );

      if (verifyResponse.success) {
        debugPrint('Xác thực thành công!');
        _api.setUserId(verifyResponse.session!.user.id);
      }
    }
  }

  /// Quên mật khẩu
  Future<void> forgotPasswordExample() async {
    final response = await _authService.resetPasswordForEmail(
      'user@example.com',
    );

    if (response.success) {
      debugPrint('Email đặt lại mật khẩu đã được gửi');
    }
  }

  /// Cập nhật profile
  Future<void> updateProfileExample() async {
    final response = await _authService.updateUser(
      displayName: 'Tên mới',
      avatarUrl: 'https://example.com/avatar.jpg',
    );

    if (response.success) {
      debugPrint('Đã cập nhật profile');
    }
  }

  /// Đăng xuất
  Future<void> signOutExample() async {
    await _authService.signOut();
    _api.setUserId(null);
    debugPrint('Đã đăng xuất');
  }

  // ========================
  // PLACES API
  // ========================

  /// Lấy danh sách địa điểm
  Future<void> getPlacesExample() async {
    try {
      // Lấy danh sách places với filters
      final places = await _placeService.getPlaces(
        limit: 20,
        location: 'Hà Nội', // Tìm theo thành phố
        categories: 'restaurant,cafe', // Lọc theo danh mục
        minRating: 4.0, // Rating tối thiểu
        search: 'phở', // Tìm kiếm theo tên
        sortBy: 'rating', // Sắp xếp: rating, distance, popularity
      );

      for (final place in places) {
        debugPrint('${place.name} - ${place.rating}⭐ - ${place.address}');

        // Convert sang app model nếu cần
        final placeModel = place.toPlace();
        debugPrint('App model: ${placeModel.localizedName('vi')}');
      }
    } on ApiException catch (e) {
      debugPrint('Error: ${e.message}');
    }
  }

  /// Lấy địa điểm gần vị trí hiện tại
  Future<void> getNearbyPlacesExample() async {
    try {
      final nearbyPlaces = await _placeService.getNearbyPlaces(
        lat: 21.0285, // Latitude của user
        lon: 105.8542, // Longitude của user
        radius: 5, // Bán kính 5km
        categories: 'cafe', // Chỉ lấy quán cafe
        limit: 10,
      );

      for (final place in nearbyPlaces) {
        debugPrint('${place.name} - ${place.distanceKm?.toStringAsFixed(1)}km');
      }
    } on ApiException catch (e) {
      debugPrint('Error: ${e.message}');
    }
  }

  /// Lấy chi tiết một địa điểm
  Future<void> getPlaceDetailExample() async {
    try {
      final place = await _placeService.getPlace('place-uuid-here');
      debugPrint('Name: ${place.name}');
      debugPrint('Address: ${place.address}');
      debugPrint('Phone: ${place.phone}');
      debugPrint('Website: ${place.website}');
      debugPrint('Rating: ${place.rating}');
    } on ApiException catch (e) {
      debugPrint('Error: ${e.message}');
    }
  }

  /// Lấy danh sách categories
  Future<void> getCategoriesExample() async {
    try {
      final categories = await _placeService.getCategories();
      debugPrint('Categories: $categories');
    } on ApiException catch (e) {
      debugPrint('Error: ${e.message}');
    }
  }

  // ========================
  // COMMENTS API
  // ========================

  /// Lấy comments của một địa điểm
  Future<void> getPlaceCommentsExample() async {
    try {
      final comments = await _commentService.getPlaceComments(
        'place-uuid-here',
        limit: 20,
        offset: 0,
        orderBy: 'recent', // recent hoặc rating
      );

      for (final comment in comments) {
        debugPrint('${comment.author}: ${comment.text} - ${comment.rating}⭐');

        // Convert sang app model
        final commentModel = comment.toPlaceComment();
        debugPrint('Timestamp: ${commentModel.timestamp}');
      }
    } on ApiException catch (e) {
      debugPrint('Error: ${e.message}');
    }
  }

  /// Tạo comment mới
  Future<void> createCommentExample() async {
    try {
      final response = await _commentService.createComment(
        placeId: 'place-uuid-here',
        userId: 'user-uuid-here',
        authorName: 'Nguyễn Văn A',
        rating: 5,
        text: 'Địa điểm rất đẹp, phong cảnh tuyệt vời!',
        imageUrls: [], // Thêm URLs ảnh nếu có (upload trước)
      );

      if (response.success) {
        debugPrint('Comment created successfully!');
      }
    } on ApiException catch (e) {
      debugPrint('Error: ${e.message}');
    }
  }

  /// Cập nhật comment
  Future<void> updateCommentExample() async {
    try {
      final response = await _commentService.updateComment(
        'comment-uuid-here',
        rating: 4,
        text: 'Cập nhật: Vẫn rất tốt nhưng hơi đông',
      );

      debugPrint('Updated: ${response.success}');
    } on ApiException catch (e) {
      debugPrint('Error: ${e.message}');
    }
  }

  /// Xóa comment
  Future<void> deleteCommentExample() async {
    try {
      final response = await _commentService.deleteComment('comment-uuid-here');
      debugPrint('Deleted: ${response.success}');
    } on ApiException catch (e) {
      debugPrint('Error: ${e.message}');
    }
  }

  // ========================
  // IMAGES API
  // ========================

  /// Upload ảnh
  Future<void> uploadImagesExample() async {
    try {
      // Giả sử bạn có list File từ image_picker
      final files = <File>[
        File('/path/to/image1.jpg'),
        File('/path/to/image2.jpg'),
      ];

      final response = await _imageService.uploadImages(files);

      if (response.success) {
        debugPrint('Uploaded URLs: ${response.urls}');

        // Sau đó dùng URLs này để tạo comment hoặc thêm vào comment
        await _commentService.createComment(
          placeId: 'place-uuid',
          rating: 5,
          text: 'Ảnh đẹp!',
          imageUrls: response.urls,
        );
      }
    } on ApiException catch (e) {
      debugPrint('Error: ${e.message}');
    }
  }

  /// Lấy ảnh của địa điểm
  Future<void> getPlaceImagesExample() async {
    try {
      final images = await _imageService.getPlaceImages('place-uuid-here');

      for (final image in images) {
        debugPrint('Image URL: ${image.url}');
      }
    } on ApiException catch (e) {
      debugPrint('Error: ${e.message}');
    }
  }

  // ========================
  // CHAT API (AI Assistant)
  // ========================

  /// Gửi tin nhắn chat với AI
  Future<void> chatExample() async {
    try {
      final response = await _chatService.chat(
        ChatRequest(
          message: 'Tìm cho tôi các quán phở ngon ở Hà Nội',
          sessionId: 'user-session-123',
          userLat: 21.0285, // Vị trí user (optional)
          userLon: 105.8542,
        ),
      );

      debugPrint('AI Answer: ${response.answer}');
      debugPrint(
        'Query Type: ${response.queryType}',
      ); // general, nearby, specific
      debugPrint('Found ${response.totalPlaces} places');

      for (final place in response.places) {
        debugPrint('- ${place.name}: ${place.address}');
      }
    } on ApiException catch (e) {
      debugPrint('Error: ${e.message}');
    }
  }

  /// Lưu lịch trình
  Future<void> saveItineraryExample() async {
    try {
      final response = await _chatService.saveItinerary(
        ItinerarySaveRequest(
          sessionId: 'user-session-123',
          title: 'Du lịch Hà Nội 3 ngày',
          content: 'Ngày 1: Tham quan Hồ Gươm...',
          places: [
            {'place_id': 'uuid-1', 'name': 'Hồ Gươm'},
            {'place_id': 'uuid-2', 'name': 'Văn Miếu'},
          ],
        ),
      );

      if (response.success) {
        debugPrint('Saved itinerary ID: ${response.itineraryId}');
      }
    } on ApiException catch (e) {
      debugPrint('Error: ${e.message}');
    }
  }

  /// Lấy danh sách lịch trình đã lưu
  Future<void> listItinerariesExample() async {
    try {
      final itineraries = await _chatService.listItineraries(
        'user-session-123',
      );

      for (final itinerary in itineraries) {
        debugPrint('${itinerary['title']}: ${itinerary['content']}');
      }
    } on ApiException catch (e) {
      debugPrint('Error: ${e.message}');
    }
  }

  // ========================
  // USER API
  // ========================

  /// Lấy comments của user
  Future<void> getUserCommentsExample() async {
    try {
      final comments = await _userService.getUserComments(
        'user-uuid-here',
        limit: 20,
      );

      for (final comment in comments) {
        debugPrint('Place: ${comment.placeId} - ${comment.text}');
      }
    } on ApiException catch (e) {
      debugPrint('Error: ${e.message}');
    }
  }

  /// Lấy danh sách places mà user đã comment
  Future<void> getUserCommentedPlacesExample() async {
    try {
      final response = await _userService.getUserCommentedPlaces(
        'user-uuid-here',
      );

      debugPrint('User đã comment ${response.count} địa điểm:');
      for (final place in response.places) {
        debugPrint('- ${place.name} (${place.category})');
      }
    } on ApiException catch (e) {
      debugPrint('Error: ${e.message}');
    }
  }

  // ========================
  // Cleanup
  // ========================

  void dispose() {
    _api.dispose();
  }
}
