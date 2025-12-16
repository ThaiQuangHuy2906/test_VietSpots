# VietSpots

A modern Flutter application for discovering and exploring tourist spots in Vietnam, powered by AI chat assistance and real-time backend integration. Built with Material Design 3 principles and a comprehensive design system.

## ✨ Features

### 🤖 AI-Powered Experience
- **Intelligent Travel Assistant**: Chat with Gemini AI for personalized travel recommendations
- **Markdown Formatting**: Beautiful formatted responses with headers, lists, and bold text
- **Context-Aware Responses**: AI understands your location, preferences, and travel history
- **Weather Integration**: Real-time weather data for better trip planning
- **Semantic Search**: Find places using natural language queries
- **Extended Timeout**: 90-second timeout for AI processing to handle complex queries

### 🎨 Professional UI/UX Design
- **Modern Design System**: Comprehensive typography tokens, 8px spacing grid, and color system
- **WCAG AA Compliant**: Accessible contrast ratios for dark and light modes
- **Visual Hierarchy**: Clear section headers, improved readability, consistent styling
- **Smooth Animations**: Pull-to-refresh, transitions, and micro-interactions
- **Enhanced Empty States**: Helpful illustrations and actionable CTAs

### 🌟 Core Features
- **Place Discovery**: Browse real tourist destinations from Supabase database
- **Smart Search & Filters**: Find places by name, category, location, and more
- **Reviews & Ratings**: Read and write authentic reviews for visited places
- **Image Gallery**: View and upload photos for places and reviews
- **Favorites Management**: Save and sync your favorite places across devices
- **User Authentication**: Secure Supabase authentication with JWT tokens
- **Real-time Notifications**: Stay updated with place recommendations and activity
- **Dark/Light Theme**: Seamless theme switching with proper contrast
- **Multi-language Support**: English/Vietnamese/Russian/Chinese
- **User Profile & Settings**:
   - Upload avatar images to cloud storage
   - Manage profile information and preferences
   - Secure password management

## 🔧 Backend Integration

VietSpots connects to a FastAPI backend (see `VietSpot_backend` folder) that provides:

- **Supabase Database**: PostgreSQL with real-time capabilities
- **Authentication**: JWT-based user authentication
- **Place Management**: CRUD operations for places, reviews, and images
- **AI Services**:
  - Gemini AI for conversational travel assistance
  - Semantic search using embeddings
  - Intelligent scoring and recommendations
  - Weather API integration
- **Cloud Storage**: Image uploads to Supabase Storage

### Backend Setup

1. Navigate to backend folder:
   ```bash
   cd VietSpot_backend
   ```

2. Install Python dependencies:
   ```bash
   pip install -r requirements.txt
   ```

3. Configure environment variables in `.env`:
   ```env
   SUPABASE_URL=your_supabase_url
   SUPABASE_KEY=your_supabase_key
   GEMINI_API_KEY=your_gemini_key
   WEATHER_API_KEY=your_weather_key
   ```

4. Run the backend:
   ```bash
   uvicorn main:app --reload
   ```

### API Configuration

Update the API base URL in Flutter app:
- Development: `http://localhost:8000/api`
- Production: Your deployed backend URL

## Screenshots

*(Add screenshots here when available)*

## 📋 Requirements

- **Flutter**: 3.38.5 or higher
- **Dart**: 3.10.4 or higher
- **Python**: 3.9+ (for backend)
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

## 📁 Project Structure

```
lib/
├── main.dart                 # Application entry point
├── models/                   # Data models
│   ├── chat_model.dart       # Chat message and history
│   ├── place_model.dart      # Place/location with reviews
│   └── user_model.dart       # User profile and auth
├── providers/                # State management (Provider pattern)
│   ├── auth_provider.dart    # Authentication state with backend
│   ├── chat_provider.dart    # Chat with Gemini AI
│   ├── localization_provider.dart  # Multi-language support
│   ├── place_provider.dart   # Places, favorites, reviews
│   └── theme_provider.dart   # Theme switching
├── screens/                  # UI screens
│   ├── auth/                 # Login and registration
│   ├── detail/               # Place detail with reviews
│   ├── main/                 # Main app screens
│   │   ├── home_screen.dart  # Discover places
│   │   ├── search_screen.dart # Search with filters
│   │   ├── chat_screen.dart  # AI travel assistant
│   │   ├── notification_screen.dart # Notifications
│   │   ├── favorites_screen.dart # Saved places
│   │   └── settings_screen.dart # User settings
│   └── splash_screen.dart    # App launch screen
├── services/                 # Backend integration
│   ├── api_client.dart       # HTTP client wrapper
│   ├── auth_service.dart     # Authentication API
│   ├── place_service.dart    # Places API
│   ├── comment_service.dart  # Reviews API
│   ├── user_service.dart     # User profile API
│   ├── image_service.dart    # Image upload API
│   └── chat_service.dart     # AI chat API
├── utils/                    # Utilities and design system
│   ├── theme.dart            # Theme configuration
│   └── typography.dart       # Design tokens
└── widgets/                  # Reusable widgets
    └── place_card.dart       # Place card component
```

## 🎨 Design System

VietSpots follows a comprehensive design system ensuring consistency and accessibility across the app.

### Typography Tokens

Standardized text styles defined in `lib/utils/typography.dart`:

```dart
// Headings
heading1: 24px, w700    // Major sections
heading2: 20px, w700    // Page titles
heading3: 18px, w600    // Subsections

// Section Headers
sectionHeader: 16px, w600, letter-spacing: 0.15

// Body Text
bodyLarge: 16px, w400
bodyMedium: 14px, w400

// Labels & Captions
labelLarge: 14px, w600
labelMedium: 12px, w500
caption: 12px, w400
```

### Spacing System (8px Grid)

```dart
xs: 4px   // Minimal spacing
sm: 8px   // Small gaps
md: 16px  // Standard padding
lg: 24px  // Section spacing
xl: 32px  // Large sections
xxl: 48px // Extra large
```

### Color System (WCAG AA Compliant)

**Light Mode:**
- Primary Text: `#212121` (grey[900])
- Secondary Text: `#616161` (grey[700]) - 4.5:1 contrast
- Tertiary Text: `#9E9E9E` (grey[500])

**Dark Mode:**
- Primary Text: `#FFFFFF` (white)
- Secondary Text: `#B0B0B0` - Improved contrast
- Tertiary Text: `#808080`
- Card Background: `#252525` - Enhanced from #1E1E1E
- Scaffold Background: `#121212`

**Brand Colors:**
- Primary Red: `#D32F2F`
- Accent Yellow: `#FFC107`

### UI Components

- **Border Radius**: 12px (cards), 20-30px (search bars), circle (avatars)
- **Elevation**: Minimal shadows (2-4dp) for subtle depth
- **Transitions**: Smooth 200-400ms animations

## 📦 Dependencies

Key packages used in this project:

**State Management & Navigation:**
- **provider** (^6.1.2): State management pattern

**Backend Integration:**
- **http** (^0.13.6): API requests to FastAPI backend
- **shared_preferences** (^2.3.2): Local data persistence

**UI & Media:**
- **flutter_markdown** (^0.7.4+1): Render markdown in chat responses
- **cached_network_image** (^3.3.1): Image loading with caching (mobile)
- **google_fonts** (^4.0.4): Typography (Noto Sans)
- **flutter_svg** (^1.1.6): SVG icon support
- **image_picker** (^1.1.2): Camera and gallery access
- **permission_handler** (^11.3.0): Runtime permissions
- **url_launcher** (^6.2.5): External URLs and maps

**Mapping & Location:**
- **flutter_map** (^4.0.0): Interactive maps
- **latlong2** (^0.8.1): Lat/long calculations
- **geolocator** (^9.0.2): Location services

**Utilities:**
- **intl** (^0.19.0): Internationalization and formatting
- **uuid** (^4.4.2): Unique ID generation
- **path_provider** (^2.1.5): File system paths
- **crop_your_image** (^2.0.0): Image cropping

See `pubspec.yaml` for the complete dependency list.

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
   <string>We need your location for personalized travel recommendations</string>
   <key>NSPhotoLibraryUsageDescription</key>
   <string>We need access to your photos to upload images</string>
   <key>NSCameraUsageDescription</key>
   <string>We need camera access to take photos</string>
   ```

### Backend URL Configuration

Update the API base URL in `lib/services/api_client.dart`:
```dart
static const String baseUrl = 'http://localhost:8000/api'; // Development
// static const String baseUrl = 'https://your-backend.com/api'; // Production
```

## 🔐 Environment Variables

Create a `.env` file in the backend folder:

```env
# Supabase
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_KEY=your-supabase-anon-key

# AI Services
GEMINI_API_KEY=your-gemini-api-key

# Weather
WEATHER_API_KEY=your-openweather-api-key
```

## 🏗️ Architecture & Best Practices

### State Management
- **Provider Pattern**: Clean separation of business logic from UI
- **Service Layer**: Backend API integration with proper error handling
- **Consumer Widgets**: Efficient rebuilds for specific state changes
- **ChangeNotifier**: Reactive state updates across the app

### Backend Architecture
- **FastAPI**: High-performance Python backend
- **Supabase**: PostgreSQL database with Row Level Security
- **Microservices**: Modular services for places, auth, AI, storage
- **REST API**: Well-documented endpoints with proper status codes

### Code Quality
- **Type Safety**: Strict null safety enabled
- **Linting**: Flutter recommended lints
- **Error Handling**: Comprehensive try-catch with user-friendly messages
- **API Clients**: Reusable service classes for backend communication

### Accessibility
- **WCAG AA Compliance**: All text meets 4.5:1 contrast ratio
- **Touch Targets**: Minimum 48dp for interactive elements
- **Screen Reader Support**: Semantic labels for assistive technologies

### Performance
- **Lazy Loading**: ListView.builder for efficient rendering
- **Image Caching**: CachedNetworkImage reduces network calls
- **Pagination**: Load places and reviews in chunks
- **Debouncing**: Smart search with input debouncing
- **Build Optimization**: Const constructors where possible

### UI/UX Patterns
- **Pull-to-Refresh**: RefreshIndicator on all list screens
- **Loading States**: Shimmer effects and progress indicators
- **Error Handling**: Retry actions with clear error messages
- **Empty States**: Helpful illustrations with actionable CTAs
- **Optimistic Updates**: Instant UI feedback for better UX

### Web Compatibility
- **Image Loading**: Platform-specific handling (Image.network for web, CachedNetworkImage for mobile)
- **CORS Handling**: Graceful fallback for Google Photos URLs that fail CORS on web
- **Responsive Design**: Adaptive layouts for different screen sizes
- **Hot Reload**: Full support for Flutter hot reload during development

## 🤝 Contributing

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

2. **Backend connection failed**:
   - Ensure backend is running on `http://localhost:8000`
   - Check API base URL in `api_client.dart`
   - Verify `.env` file has correct credentials

3. **Permission issues**:
   - Grant location and storage permissions in device settings
   - For iOS, check Info.plist has required keys

4. **Build failures**:
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

5. **Image upload not working**:
   - Verify Supabase Storage bucket is public
   - Check image picker permissions
   - Ensure backend storage service is configured

6. **Images not loading on web**:
   - Google Photos URLs may be blocked by CORS policy
   - App shows placeholder icons when images fail to load
   - Solution: Backend should save images to Supabase Storage

7. **Chat timeout errors**:
   - Chat API now has 90-second timeout (increased from 30s)
   - Backend needs time for Gemini AI + semantic search
   - If still timing out, check backend performance

### Recent Fixes

- ✅ **Fixed review count bug**: Cards now always show total review count instead of loaded page size
- ✅ **Fixed chat timeout**: Increased timeout from 30s to 90s for AI processing
- ✅ **Added markdown rendering**: Chat responses now beautifully formatted with headers, lists, bold text
- ✅ **Fixed web image loading**: Platform-specific image handling for better web compatibility
- ✅ **Improved error messages**: Better debugging with timeout-specific error messages

### Getting Help

- [Flutter Documentation](https://docs.flutter.dev/)
- [Supabase Documentation](https://supabase.com/docs)
- [FastAPI Documentation](https://fastapi.tiangolo.com/)
- [Stack Overflow](https://stackoverflow.com/questions/tagged/flutter)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Flutter team for the amazing framework
- Supabase for backend infrastructure
- Google Gemini AI for intelligent assistance
- Open source community for the packages used
- Vietnamese tourism industry for inspiration

---

**Note**: This app connects to a real backend. Ensure the backend server is running and properly configured before using the app.
