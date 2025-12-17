import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vietspots/providers/auth_provider.dart';
import 'package:vietspots/providers/chat_provider.dart';
import 'package:vietspots/providers/localization_provider.dart';
import 'package:vietspots/providers/place_provider.dart';
import 'package:vietspots/providers/theme_provider.dart';
import 'package:vietspots/services/api_service.dart';
import 'package:vietspots/services/chat_service.dart';
import 'package:vietspots/services/place_service.dart';
import 'package:vietspots/utils/theme.dart';

Widget buildTestApp(Widget child) {
  // Create test API service
  final apiService = ApiService();
  final chatService = ChatService(apiService);
  final placeService = PlaceService(apiService);

  return MultiProvider(
    providers: [
      Provider<ApiService>.value(value: apiService),
      Provider<ChatService>.value(value: chatService),
      Provider<PlaceService>.value(value: placeService),
      ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ChangeNotifierProvider(create: (_) => AuthProvider(apiService)),
      ChangeNotifierProvider(
        create: (_) => ChatProvider(chatService, placeService),
      ),
      ChangeNotifierProvider(create: (_) => PlaceProvider(placeService)),
      ChangeNotifierProvider(create: (_) => LocalizationProvider()),
    ],
    child: Consumer2<ThemeProvider, LocalizationProvider>(
      builder: (context, themeProvider, locProvider, _) {
        return MaterialApp(
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          locale: locProvider.locale,
          home: child,
        );
      },
    ),
  );
}
