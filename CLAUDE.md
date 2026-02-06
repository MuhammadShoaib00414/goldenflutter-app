# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Goldexia FX** is a Flutter mobile application for a financial trading platform. It provides trade signals and subscription management, with support for both regular users and trader/admin roles. The app communicates with a REST API backend at `admin.dracademy.pk/api` and uses Firebase for push notifications.

**Supported Platforms:** iOS, Android, Web, Windows, Linux, macOS

---

## Common Development Commands

### Setup & Dependencies
```bash
# Get all dependencies
flutter pub get

# Upgrade dependencies
flutter pub upgrade

# Clean build artifacts
flutter clean
```

### Running the App
```bash
# Run debug build
flutter run

# Run debug build on specific device
flutter run -d <device-id>

# List available devices
flutter devices
```

### Building for Release
```bash
# Build APK (Android)
flutter build apk --release

# Build iOS app
flutter build ios --release

# Build web version
flutter build web --release

# Build Windows app
flutter build windows --release

# Build macOS app
flutter build macos --release

# Build Linux app
flutter build linux --release
```

### Code Quality & Analysis
```bash
# Run static analyzer (linter)
flutter analyze

# Run tests
flutter test

# Run a specific test file
flutter test test/path/to/test_file.dart

# Run tests with coverage (requires lcov)
flutter test --coverage
```

### Formatting & Linting
```bash
# Check code formatting
dart format --set-exit-if-changed lib/

# Format all Dart files
dart format lib/

# Run Flutter lints
flutter analyze

# Fix common issues
dart fix --apply lib/
```

### Debugging
```bash
# Run with verbose logging
flutter run -v

# Run with VM service enabled
flutter run --vm-service

# Connect to existing app with debugger
flutter attach
```

---

## Architecture & Code Organization

### Layered Architecture
The project follows **Clean Architecture** with four distinct layers:

```
PRESENTATION LAYER (Views)
    ├── screens/         # Full-page UI components
    └── widgets/         # Reusable UI components
            ↓
STATE MANAGEMENT LAYER (Providers)
    └── providers/       # Provider-based state management with ChangeNotifier
            ↓
BUSINESS LOGIC LAYER (Repositories)
    └── repositories/    # Data access abstraction layer
            ↓
SERVICE LAYER (Services)
    ├── base_service.dart        # HTTP client base class
    ├── base_controller.dart     # Error handling utilities
    ├── app_exceptions.dart      # Custom exceptions
    └── local_db/                # Local storage & persistence
```

### Data Flow
1. **UI Screen** calls provider method
2. **Provider** processes state & calls repository
3. **Repository** extends BaseService, calls API endpoint
4. **BaseService** handles HTTP request with auth headers
5. **API Response** wrapped in `ApiResponse<T>` model
6. **Data** stored in local secure storage (UserSession)
7. **UI** updates via provider notification

### Key Directories

| Directory | Purpose |
|-----------|---------|
| `lib/models/` | Data model definitions (65+ files) - all responses are serialized with `toMap()`, `fromMap()`, `toJson()`, `fromJson()` |
| `lib/views/screens/` | Full-page screens; auth screens in `auth/` subdirectory |
| `lib/views/widgets/` | Reusable UI components (buttons, text fields, dropdowns, list tiles, image containers) |
| `lib/providers/` | State management using Provider package; handles login, signals, uploads, etc. |
| `lib/repositories/` | API call abstractions; includes `auth_repo.dart`, `image_repo.dart`, `subsciptions_repo.dart` |
| `lib/services/` | HTTP operations (`base_service.dart`), error handling, local storage, Firebase integration |
| `lib/utils/` | Utilities (navigation, logging, validation), colors, strings, typography, dimensions |
| `lib/utils/res/` | Resource constants: URLs, colors, text styles, dimensions, images |
| `assets/images/` | Static image assets |

### Navigation Flow

**Authentication Flow:**
```
SplashScreen (checks onboarding flag)
    ├─→ First-time: OnBoardingScreen → WelcomeScreen → SignupScreen
    └─→ Returning: LoginScreen
         → DashboardScreen (regular users)
         → SignalListScreen (traders/admins)
```

Use `Nav.to()`, `Nav.off()`, `Nav.offAll()`, `Nav.back()` for navigation (see `lib/utils/nav.dart`).

---

## Key Technical Patterns & Practices

### 1. Provider State Management
All providers extend `ChangeNotifier` and are registered in `lib/providers/app_providers.dart`:
```dart
// In app_providers.dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => AuthProvider()),
    ChangeNotifierProvider(create: (_) => ProfileProvider()),
    // ... etc
  ],
  child: const MyApp(),
)
```

Use `Provider.of<ProviderClass>().method()` or `context.read<ProviderClass>().method()` to access providers.

### 2. HTTP Requests via BaseService
All API calls go through `BaseService` (lib/services/base_service.dart):
- Automatic Bearer token injection from `UserSession`
- Request/response logging via `Log` utility
- 25-second timeout for all requests
- Socket exception handling (no internet scenarios)
- Standardized JSON serialization

**Typical repository method:**
```dart
Future<ApiResponse<User>> login(String email, String password) async {
  final response = await post(
    AppUrls.login,
    {'email': email, 'password': password},
  );
  return ApiResponse<User>.fromMap(response);
}
```

### 3. Secure Token Storage
User session and tokens are stored securely via `UserSession` (lib/services/local_db/user_session.dart):
- Uses `FlutterSecureStorage` for sensitive data
- Persists authentication tokens
- Singleton pattern for current user access
- `saveUser()` called after successful authentication

### 4. API Response Wrapper
All API responses wrapped in `ApiResponse<T>`:
```dart
class ApiResponse<T> {
  bool success;
  String message;
  T data;

  factory ApiResponse<T>.fromMap(Map<String, dynamic> map) { ... }
}
```

### 5. Model Serialization
All models in `lib/models/` include serialization methods:
- `toMap()` - Convert to Map for JSON encoding
- `fromMap(Map)` - Factory to deserialize from API response
- `toJson()` - Convert to JSON string
- `fromJson(String)` - Factory to deserialize from JSON string

### 6. Error Handling
- Custom exceptions in `app_exceptions.dart`
- `BaseController` provides error handling utilities
- HTTP errors caught in `BaseService.post/get/put/delete`
- User-friendly error messages via Fluttertoast

### 7. Logging
Use `Log` utility from `lib/utils/logs.dart`:
```dart
Log.d('debug message');
Log.e('error message');
Log.w('warning message');
```

All HTTP requests/responses automatically logged.

### 8. Authentication & Role-Based Access
- User roles: regular user vs. trader/admin
- `User` model contains `role` field
- Navigation determined by role after login
- Authorization headers (Bearer token) injected automatically

---

## Key Features & Implementation Notes

### Authentication System
- Email/Password registration and login
- Email verification via OTP
- Password reset with OTP verification
- Token-based authentication (Bearer tokens)
- Session persistence via UserSession

**Files:** `lib/providers/auth_provider.dart`, `lib/repositories/auth_repo.dart`

### Signal Management (Trading Signals)
- Traders/admins can create and manage trade signals
- Signal creation form with entry, stop loss, take profit levels
- Signal list display for traders
- Role-based visibility (signals only for traders)

**Files:** `lib/providers/signal_list_provider.dart`, `lib/providers/create_signal_provider.dart`

### Image Upload
- Upload images from device via image picker
- Profile picture and proof uploads supported
- Upload progress tracking

**Files:** `lib/providers/upload_image_provider.dart`, `lib/repositories/image_repo.dart`

### Subscriptions
- Display available subscription plans
- Subscription data management

**Files:** `lib/repositories/subsciptions_repo.dart`, `lib/models/subscription.dart`

### Push Notifications
- Firebase Cloud Messaging (FCM) integration
- Local notifications support
- Configured in Firebase constants

### Onboarding
- First-time user flow
- Onboarding completion flag stored in SharedPreferences
- SplashScreen checks flag to determine navigation

**Files:** `lib/providers/on_boarding_provider.dart`, `lib/views/screens/on_boarding_screen.dart`

### Referral Links
- Link/sharing management for user referrals
- Link creation and retrieval

**Files:** `lib/providers/links_provider.dart`, `lib/repositories/subsciptions_repo.dart`, `lib/models/link.dart`

---

## Dependencies & Libraries

| Package | Version | Purpose |
|---------|---------|---------|
| `provider` | ^6.1.5 | State management |
| `http` | ^1.6.0 | HTTP client |
| `firebase_messaging` | ^16.1.0 | Push notifications |
| `firebase_core` | ^4.3.0 | Firebase initialization |
| `flutter_secure_storage` | ^10.0.0 | Secure token/session storage |
| `shared_preferences` | ^2.5.4 | Key-value local storage |
| `image_picker` | ^1.2.1 | Device image selection |
| `url_launcher` | ^6.3.2 | Open URLs and links |
| `flutter_local_notifications` | ^19.5.0 | Local notifications |
| `fluttertoast` | ^9.0.0 | Toast notifications |
| `intl` | ^0.20.2 | Internationalization |
| `fpdart` | ^1.2.0 | Functional programming utilities |

---

## Important Constants & Configuration

### API Endpoints
Defined in `lib/utils/res/app_urls.dart`:
```dart
const String baseUrl = 'https://admin.dracademy.pk/api';
String login = '$baseUrl/auth/login';
String register = '$baseUrl/auth/register';
// ... other endpoints
```

**HTTP Timeout:** 25 seconds (BaseService)

### Theme & Design
- **Theme:** Dark theme only (Material Design)
- **Colors:** `lib/utils/res/app_colors.dart`
- **Typography:** `lib/utils/res/app_text_styles.dart`
- **Dimensions:** `lib/utils/res/app_dimensions.dart`
- **Gradients:** `lib/utils/app_gradient.dart`

### Firebase Configuration
- **Messaging:** Firebase Cloud Messaging for push notifications
- **Constants:** `lib/utils/res/fb_constants.dart`

---

## Adding New Features: Step-by-Step

### 1. New API Endpoint
1. Add endpoint URL to `lib/utils/res/app_urls.dart`
2. Create model class in `lib/models/` with serialization methods
3. Add repository method in appropriate repo file
4. Create/update provider in `lib/providers/`
5. Create/update screen UI in `lib/views/screens/`

### 2. New Screen
1. Create screen file in `lib/views/screens/`
2. Create/use provider for state management
3. Add navigation route (use `Nav.to()`)
4. Add any new widgets to `lib/views/widgets/`

### 3. New Provider
1. Create file in `lib/providers/` extending `ChangeNotifier`
2. Add methods and state variables
3. Call `notifyListeners()` after state changes
4. Register in `lib/providers/app_providers.dart`

### 4. New Model
1. Create file in `lib/models/`
2. Implement all serialization methods: `toMap()`, `fromMap()`, `toJson()`, `fromJson()`
3. Import in repositories/providers as needed

---

## Code Quality Standards

### Analysis & Linting
- Project uses `flutter_lints` (recommended lint set)
- Run `flutter analyze` before committing
- Lint configuration in `analysis_options.yaml`
- Most lints are enabled by default; customization available

### Testing
- Tests located in `test/` directory
- Uses `flutter_test` package
- Run tests with `flutter test`

### Formatting
- Use `dart format` for consistent formatting
- Line length: standard Dart convention (80-100 chars)
- Use `dart fix --apply` to auto-fix common issues

---

## Recent Development Status

**Latest Changes:**
- Admin dashboard screen implementation
- Admin screen UI and logic
- Dialog and username UI components
- Response handling implementation
- Admin ID and secret management

**Untracked/Modified Files:**
- `lib/providers/app_providers.dart` - Provider registration
- `lib/utils/app_strings.dart` - String constants and endpoints
- `lib/utils/logs.dart` - Logging utility
- `lib/utils/res/app_urls.dart` - API endpoints
- `lib/views/screens/links_screen.dart` - Links/referral UI
- `lib/models/subscription.dart` - New subscription model
- `lib/providers/links_provider.dart` - New links state management
- `lib/repositories/subsciptions_repo.dart` - New subscriptions repository

---

## Debugging Tips

1. **Check HTTP Requests:** All requests logged automatically via `BaseService`. Look at console output.
2. **Authentication Issues:** Verify token in `UserSession` using secure storage inspection.
3. **Provider Not Updating:** Ensure `notifyListeners()` is called after state changes.
4. **Navigation Issues:** Verify `Navigator` key in `main.dart` and route names are correct.
5. **API Response Errors:** Check `ApiResponse.success` flag and `message` field for error details.
6. **Build Issues:** Run `flutter clean && flutter pub get` to reset build artifacts.

---

## Environment & Requirements

- **Dart SDK:** ^3.9.2
- **Flutter:** Latest stable version
- **Platforms:** Supports iOS, Android, Web, Windows, Linux, macOS
- **Material Design:** Yes
- **Null Safety:** Enabled

---

## Useful References

- **API Base URL:** `https://admin.dracademy.pk/api`
- **Flutter Documentation:** https://docs.flutter.dev
- **Provider Package:** https://pub.dev/packages/provider
- **Firebase Documentation:** https://firebase.google.com/docs
- **Dart Language:** https://dart.dev/guides
