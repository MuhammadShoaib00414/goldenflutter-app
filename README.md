# GoldenFlutter App

A Flutter mobile app (Android, iOS, web) for managing trade signals, subscriptions, uploads, videos and user profiles.

**Status:** Active development

**Tech stack:** Flutter (Dart), Firebase (Auth, Firestore/Storage), platform-specific configs for Android and iOS.

**Quick Links**
- **App entry:** [lib/main.dart](lib/main.dart#L1)
- **Providers:** [lib/providers](lib/providers)
- **Services:** [lib/services](lib/services)
- **Models:** [lib/models](lib/models)

**Prerequisites**
- Install Flutter SDK: https://flutter.dev/docs/get-started/install
- Ensure Android Studio / Xcode (macOS) or appropriate toolchain is installed
- Java / Android SDK for Android builds

Getting started
1. Clone the repo

```bash
git clone <your-repo-url>
cd goldenflutter-app
flutter pub get
```

2. Add Firebase config (if you will run with Firebase)
- Android: place `google-services.json` under `android/app/` (a placeholder is already present in the repo)
- iOS: place `GoogleService-Info.plist` under `ios/Runner/`

3. Build & run
- Run on connected Android device or emulator:

```bash
flutter run -d emulator-5554
```

- Run on web (Chrome):

```bash
flutter run -d chrome
```

- Build release APK:

```bash
flutter build apk --release
```

Project structure (high level)
- **lib/**: main app code
  - **models/**: data models
  - **providers/**: state management providers
  - **repositories/**: data access layer
  - **services/**: core services and utilities
  - **views/** and **widgets/**: UI screens and components
- **android/**, **ios/**, **web/**, **windows/**, **macos/**, **linux/**: platform folders
- **assets/**: images and other static assets

Environment & config
- `lib/firebase_options.dart`: generated Firebase options (ensure it's set for your Firebase project if used)
- Keep API keys and secrets out of source control. Use platform-specific secure storage or CI secrets for production builds.

Common tasks
- Format code:

```bash
flutter format .
```
- Run analyzer:

```bash
flutter analyze
```
- Run tests:

```bash
flutter test
```

Contributing
- Create issues and feature branches. Open a PR with clear description and testing steps.

Notes
- The project already contains Firebase config placeholders (`android/app/google-services.json` and `ios/Runner/GoogleService-Info.plist`). Replace them with your project's credentials.
- If you add or regenerate `lib/firebase_options.dart`, run `flutter pub get` and rebuild.

License
- Check repository root for license information, or add one if missing.

If you'd like, I can also:
- run `flutter analyze` and fix minor lint issues
- run app locally and verify a debug build

---
Generated README for the GoldenFlutter app.
