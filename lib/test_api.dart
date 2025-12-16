import 'package:flutter/foundation.dart';
import 'services/api_service.dart';
import 'services/place_service.dart';
import 'services/chat_service.dart';

/// Test file to verify backend integration
/// Run with: flutter run lib/test_api.dart
void main() async {
  debugPrint('🚀 Testing VietSpot Backend Integration...\n');

  final apiService = ApiService();
  final placeService = PlaceService(apiService);
  final chatService = ChatService(apiService);

  try {
    // Test 1: Get Categories
    debugPrint('📂 Test 1: Get Categories');
    final categories = await placeService.getCategories();
    debugPrint('✅ Categories: ${categories.take(5).join(", ")}...\n');

    // Test 2: Get Places
    debugPrint('🏛️ Test 2: Get Places (limit 3)');
    final places = await placeService.getPlaces(limit: 3);
    debugPrint('✅ Found ${places.length} places:');
    for (var place in places) {
      debugPrint('   - ${place.name} (${place.category})');
    }
    debugPrint('');

    // Test 3: Chat
    debugPrint('💬 Test 3: Chat AI');
    final chatResponse = await chatService.chat(
      ChatRequest(message: 'Gợi ý địa điểm du lịch ở Hà Nội'),
    );
    debugPrint('✅ Chat response: ${chatResponse.answer.substring(0, 100)}...');
    debugPrint('   Suggested places: ${chatResponse.places.length}');
    debugPrint('');

    debugPrint('✅ All tests passed! Backend integration working! 🎉');
  } catch (e) {
    debugPrint('❌ Error: $e');
    debugPrint('\n⚠️ Backend might be down or endpoint changed.');
  } finally {
    apiService.dispose();
  }
}
