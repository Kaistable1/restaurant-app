# Copilot Instructions for Restaurant App

## Project Overview

Kaistable is a Flutter-based restaurant discovery and review application with social features. The app allows users to discover restaurants, view details, write reviews, share posts, and interact with a community of food enthusiasts. It integrates Firebase for backend services and Google Maps for location-based features.

## Technology Stack

### Core Framework
- **Flutter SDK**: 3.4.0+
- **Dart**: Latest stable version
- **State Management**: GetX (get: ^4.7.2)

### Firebase Services
- Firebase Core
- Firebase Auth (authentication)
- Cloud Firestore (database)
- Firebase Storage (file storage)
- Firebase Messaging (push notifications)

### Key Dependencies
- `google_maps_flutter`: Map integration
- `geolocator` & `geocoding`: Location services
- `image_picker` & `file_picker`: Media uploads
- `flutter_local_notifications`: Local notifications
- `shared_preferences`: Local data persistence
- `intl`: Internationalization
- `carousel_slider`: Image carousels
- `flutter_rating_bar`: Star ratings
- `url_launcher`: External links

### Platforms Supported
- Android
- iOS
- Web
- Linux
- macOS
- Windows

## Project Structure

```
lib/
├── constants/          # App-wide constants and configurations
├── custom_widget/      # Reusable custom widgets
├── dialoges/          # Dialog components
├── models/            # Data models (UserModel, RestaurantModel, PostModel, etc.)
├── screens/           # UI screens organized by feature
│   ├── auth_screens/      # Login, signup, phone verification
│   ├── home_screen/       # Main home/discover feed
│   ├── nav_bar/          # Bottom navigation and profile
│   ├── detail_screens/   # Restaurant details
│   ├── trending_screen/  # Social feed (trending/recent posts)
│   ├── favorite_screen/  # User favorites
│   ├── moderation_screen/ # Admin moderation
│   ├── monetization_screen/ # Premium features/badges
│   └── user_profile_screen/ # User profiles
├── services/          # Business logic services
├── splash_screen/     # App launch screen
├── utils/            # Utility functions
└── widgets/          # Global shared widgets
```

## Development Setup

### Prerequisites
1. Flutter SDK 3.4.0 or higher
2. Android Studio or Xcode (for mobile development)
3. Firebase project with required services enabled
4. Google Maps API key

### Configuration Files Required
These files must be created locally (NOT committed to git):

1. **Android Google Maps API Key**:
   - `android/app/src/main/res/values/strings.xml`
   - Copy from `strings.xml.example` and add your API key

2. **Firebase Configuration**:
   - `android/app/google-services.json`
   - `ios/Runner/GoogleService-Info.plist`
   - Copy from `.example` files and add your Firebase config

See `SETUP.md` for detailed setup instructions.

### Installation
```bash
flutter pub get
```

## Build and Test Commands

### Analyze Code
```bash
flutter analyze --no-fatal-infos --no-fatal-warnings
```

### Run Tests
```bash
flutter test --no-test-assets
```

### Build for Android
```bash
# Debug build
flutter build apk --debug --no-shrink

# Release build
flutter build apk --release
```

### Build for iOS
```bash
flutter build ios --release
```

### Build for Web
```bash
flutter build web
```

### Run App
```bash
flutter run
```

## Code Style and Conventions

### Dart/Flutter Standards
- Follow Flutter's official style guide
- Use `analysis_options.yaml` for linting rules
- Strict type inference enabled
- All files should be null-safe

### Naming Conventions
- **Files**: `snake_case.dart`
- **Classes**: `PascalCase`
- **Variables/Functions**: `camelCase`
- **Constants**: `camelCase` or `SCREAMING_SNAKE_CASE` for compile-time constants
- **Private members**: Prefix with `_`

### Widget Patterns
- Prefer `StatelessWidget` when state is not needed
- Use `StatefulWidget` for local state
- Use GetX (`Rx`, `Obx`, `.obs`) for reactive state management
- Extract reusable widgets into separate files
- Keep widget build methods concise

### State Management with GetX
```dart
// Controller example
class MyController extends GetxController {
  var count = 0.obs;
  
  void increment() => count++;
}

// Usage in widget
Obx(() => Text('Count: ${controller.count}'))
```

## Architecture Patterns

### Service Layer
All business logic should be in service classes:
- `PostService`: Post CRUD, likes, trending queries
- `ModerationService`: Reports, blocking, admin actions
- `MonetizationService`: Badges, transactions, payments
- `AIModerationService`: Content analysis

### Data Models
- All models in `lib/models/`
- Use proper typing and null safety
- Include `toJson()` and `fromJson()` methods for Firestore serialization
- Example models: `UserModel`, `RestaurantModel`, `PostModel`, `ReportModel`

### Screen Organization
- Each feature has its own screen directory
- Complex screens should have a `widgets/` subdirectory for screen-specific widgets
- Use GetX for navigation: `Get.to()`, `Get.back()`, etc.

## Firebase Integration

### Firestore Collections
- `users`: User profiles and data
- `restaurants`: Restaurant information
- `posts`: Social feed posts
- `reviews`: Restaurant reviews
- `reports`: Content moderation reports
- `blockedUsers`: User blocking relationships
- `badges`: Premium badge catalog
- `transactions`: Purchase history
- `favorites`: User-saved restaurants

### Authentication
- Uses Firebase Auth with phone number verification
- Current user accessible via `auth.currentUser`
- Global `currentUserDataModel` for user data

### Real-time Updates
- Use `StreamBuilder` for real-time Firestore data
- Handle loading, error, and empty states properly

## Platform-Specific Code

### Web vs Mobile
Always check platform before using mobile-only features:
```dart
import 'package:flutter/foundation.dart' show kIsWeb;

if (!kIsWeb) {
  // Mobile-only code (notifications, permissions, etc.)
}
```

### Mobile-Only Features
- Local notifications
- Firebase Cloud Messaging
- Location permissions
- Camera/gallery access
- Device orientation locks

## Security Considerations

### API Keys and Secrets
- NEVER commit API keys or Firebase config files
- Use `.gitignore` to exclude sensitive files
- Store secrets in CI/CD environment variables

### User Data
- Validate user authentication before operations
- Check user ownership before allowing edits/deletes
- Sanitize user inputs
- Follow Firebase Security Rules best practices

### Production Requirements
- Implement rate limiting
- Add input validation and sanitization
- Secure all API endpoints
- Use HTTPS only

## Common Patterns

### Loading States
```dart
StreamBuilder<QuerySnapshot>(
  stream: firestore.collection('posts').snapshots(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return CircularProgressIndicator();
    }
    if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    }
    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
      return Text('No data available');
    }
    // Build UI with data
  },
)
```

### Error Handling
```dart
try {
  // Firebase operation
  await FirebaseFirestore.instance.collection('posts').add(data);
} on FirebaseException catch (e) {
  debugPrint('Firebase Error: ${e.code} - ${e.message}');
  // Show user-friendly error message
} catch (e) {
  debugPrint('Error: $e');
  // Handle general errors
}
```

### Navigation with GetX
```dart
// Navigate to screen
Get.to(() => DetailScreen(id: restaurantId));

// Navigate and remove all previous routes
Get.offAll(() => HomeScreen());

// Go back
Get.back();

// Pass data
Get.to(() => ProfileScreen(), arguments: userData);
```

## Testing

### Widget Tests
- Located in `test/` directory
- Use `flutter_test` package
- Test file naming: `*_test.dart`

### Running Tests
```bash
flutter test
```

### CI/CD
- Automated tests run on PRs and pushes to main
- Build verification included in CI pipeline
- See `.github/workflows/flutter-ci.yml`

## Important Notes

### Multi-Platform Development
- Test on all target platforms when making UI changes
- Use responsive design principles
- Handle platform-specific UI/UX differences

### Performance
- Optimize image loading (use caching)
- Implement pagination for large lists
- Avoid unnecessary rebuilds (use `const` constructors)
- Profile app performance regularly

### Notifications
- Local notifications only work on mobile platforms
- FCM setup required for push notifications
- Handle notification permissions properly

## Documentation

- `README.md`: Basic project information
- `SETUP.md`: Detailed configuration setup
- `API_KEYS_SETUP.md`: API key configuration guide
- `IMPLEMENTATION_SUMMARY.md`: Feature implementation details
- `INTEGRATION_GUIDE.md`: Backend integration guide
- `NEW_FEATURES.md`: Recent features and changes

## Getting Help

When contributing or asking Copilot for assistance:
1. Specify which platform (Android/iOS/Web/Desktop) you're targeting
2. Mention if the change affects Firebase or requires new permissions
3. Follow existing patterns and conventions in the codebase
4. Test thoroughly on target platforms
5. Update documentation when adding new features

## Current Features

- Restaurant discovery with Google Maps integration
- User authentication (phone number + OTP)
- Restaurant reviews and ratings
- Social feed with trending/recent posts
- Like/unlike functionality
- User profiles and favorites
- Content moderation system (report/block)
- Admin moderation dashboard
- Premium badges and monetization
- Push notifications
- Multi-platform support
