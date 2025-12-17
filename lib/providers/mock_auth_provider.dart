import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'package:uuid/uuid.dart';

/// Simple auth provider with mock user ID
/// Use this for development until backend has proper auth endpoints
class MockAuthProvider with ChangeNotifier {
  final ApiService _apiService;
  String? _userId;
  String? _userName;
  bool _isAuthenticated = false;

  MockAuthProvider(this._apiService);

  bool get isAuthenticated => _isAuthenticated;
  String? get userId => _userId;
  String? get userName => _userName;

  /// Mock login - generates a UUID and sets it as user ID
  Future<void> mockLogin(String name) async {
    _userId = const Uuid().v4();
    _userName = name;
    _isAuthenticated = true;

    // Set user ID in API service for all subsequent requests
    _apiService.setUserId(_userId);

    notifyListeners();
  }

  /// Logout
  void logout() {
    _userId = null;
    _userName = null;
    _isAuthenticated = false;
    _apiService.setUserId(null);
    notifyListeners();
  }

  /// Auto-login for development (call in main.dart)
  Future<void> autoLogin() async {
    await mockLogin('Test User');
  }
}
