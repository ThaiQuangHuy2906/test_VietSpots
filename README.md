# VietSpots

A modern Flutter application for discovering and exploring tourist spots in Vietnam, powered by AI chat assistance.

## Features

- **AI-Powered Travel Assistant**: Chat with VietSpots AI for personalized travel recommendations
- **Place Discovery**: Browse and explore tourist destinations across Vietnam
- **User Authentication**: Secure login and registration system
- **Location-Based Services**: Permission-based location access for better recommendations
- **Dark/Light Theme**: Customizable UI themes
- **Multi-language Support**: Localization support (English/Vietnamese)
- **Offline Support**: Mock data for demonstration purposes

## Screenshots

*(Add screenshots here when available)*

## Requirements

- **Flutter**: >= 3.10.3
- **Dart**: >= 3.10.3
- **Android Studio** or **Visual Studio Code** with Flutter extension
- **Android SDK** (for Android development)
- **Xcode** (for iOS development on macOS)

## Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/your-username/vietspots.git
   cd vietspots
   ```

2. **Install Flutter dependencies**:
   ```bash
   flutter pub get
   ```

3. **Set up your development environment**:
   - For Android: Ensure Android SDK is installed and configured
   - For iOS: Ensure Xcode is installed (macOS only)
   - For Web: No additional setup required

## Running the Application

### Development Mode

1. **Check connected devices**:
   ```bash
   flutter devices
   ```

2. **Run on specific platform**:
   ```bash
   # Android
   flutter run -d android

   # iOS (macOS only)
   flutter run -d ios

   # Web
   flutter run -d chrome

   # Windows (requires Visual Studio)
   flutter run -d windows

   # Linux
   flutter run -d linux

   # macOS
   flutter run -d macos
   ```

3. **Run tests**:
   ```bash
   flutter test
   ```

### Building for Production

1. **Build APK (Android)**:
   ```bash
   flutter build apk --release
   ```

2. **Build iOS (macOS only)**:
   ```bash
   flutter build ios --release
   ```

3. **Build Web**:
   ```bash
   flutter build web --release
   ```

## Project Structure

```
lib/
├── main.dart                 # Application entry point
├── models/                   # Data models
│   ├── chat_model.dart
│   ├── place_model.dart
│   └── user_model.dart
├── providers/                # State management
│   ├── auth_provider.dart
│   ├── chat_provider.dart
│   ├── localization_provider.dart
│   ├── place_provider.dart
│   └── theme_provider.dart
├── screens/                  # UI screens
│   ├── auth/                 # Authentication screens
│   ├── detail/               # Detail screens
│   ├── main/                 # Main app screens
│   ├── settings/             # Settings screens
│   └── splash_screen.dart
├── utils/                    # Utilities
│   ├── mock_data.dart
│   └── theme.dart
└── widgets/                  # Reusable widgets
    └── place_card.dart
```

## Dependencies

Key packages used in this project:

- **provider**: State management
- **cached_network_image**: Image caching
- **permission_handler**: Permission management
- **url_launcher**: URL launching
- **intl**: Internationalization
- **google_fonts**: Custom fonts

See `pubspec.yaml` for complete list of dependencies.

## Configuration

### Environment Setup

1. **Android**: Add to `android/app/build.gradle`:
   ```gradle
   android {
       defaultConfig {
           minSdkVersion 21
           targetSdkVersion 34
       }
   }
   ```

2. **iOS**: Add to `ios/Runner/Info.plist`:
   ```xml
   <key>NSLocationWhenInUseUsageDescription</key>
   <string>This app needs location access for travel recommendations</string>
   ```

### API Keys

*(Add instructions for any required API keys)*

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Troubleshooting

### Common Issues

1. **Flutter SDK version mismatch**:
   ```bash
   flutter upgrade
   flutter pub get
   ```

2. **Permission issues**:
   - Ensure location permissions are granted
   - Check app permissions in device settings

3. **Build failures**:
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

### Getting Help

- [Flutter Documentation](https://docs.flutter.dev/)
- [Flutter Community](https://flutter.dev/community)
- [Stack Overflow](https://stackoverflow.com/questions/tagged/flutter)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Flutter team for the amazing framework
- Open source community for the packages used
- Vietnamese tourism industry for inspiration
