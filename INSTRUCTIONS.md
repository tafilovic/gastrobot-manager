# GastroCrew – Build Instructions

## Prerequisites

- **Flutter SDK** (3.11.1 or compatible). Install from [flutter.dev](https://flutter.dev).
- Run `flutter doctor` and fix any reported issues for the platforms you want to build.

## Privacy policy

Published privacy policy for GastroCrew (app stores, support, and public links):  
[https://cybertechglobal.github.io/privacy_policy/gastrocrew/privacy_policy.html](https://cybertechglobal.github.io/privacy_policy/gastrocrew/privacy_policy.html)

## Environment (API base URL)

The app chooses the API base URL as follows:

| When | API used |
|------|----------|
| **Debug** (e.g. `flutter run`) | **dev** → `https://devapirestobot.brrm.eu` |
| **Release** (e.g. `flutter build apk --release`) | **prod** → `https://apirestobot.brrm.eu` |
| **Override** | Pass **`--dart-define=ENV=dev`** or **`--dart-define=ENV=prod`** to force an environment. |

If you do **not** pass `--dart-define=ENV=...`, debug builds use **dev** and release builds use **prod** automatically.

---

## Run (development)

```bash
# Debug build → uses dev API by default
flutter run

# Force dev or prod API
flutter run --dart-define=ENV=dev
flutter run --dart-define=ENV=prod
```

To run on a specific device:

```bash
flutter run -d <device_id>   # e.g. -d chrome, -d windows
flutter devices               # list available devices
```

---

## Build

Release builds use **prod** API by default. Add **`--dart-define=ENV=dev`** only if you need a release build pointing at the dev API.

### Android

**APK** (installable on devices/sideloading):

```bash
# Debug APK (development, quicker build)
flutter build apk --debug

# Release APK (production, optimized; uses prod API by default)
flutter build apk --release

# Release APK with version (optional)
flutter build apk --release --build-name=1.0.0 --build-number=1
```

Output: `build/app/outputs/flutter-apk/app-release.apk` (or `app-debug.apk`).

**App Bundle** (for Google Play Store):

```bash
# Release App Bundle (required for Play Store; uses prod API by default)
flutter build appbundle --release

# With version (optional)
flutter build appbundle --release --build-name=1.0.0 --build-number=1
```

Output: `build/app/outputs/bundle/release/app-release.aab`.

### iOS

```bash
# Release (requires macOS and Xcode; uses prod API by default)
flutter build ios --release
```

Then open `ios/Runner.xcworkspace` in Xcode to archive and upload to App Store Connect.

### Web

```bash
# Production build (uses prod API by default)
flutter build web --release
```

Output: `build/web/` (deploy contents to your web server).

### Windows

```bash
# Release build (uses prod API by default)
flutter build windows --release
```

Output: `build/windows/x64/runner/Release/` (includes the executable and DLLs).

---

## Launcher icons

The app uses **`flutter_launcher_icons`**. The source image is **`assets/icons/launcher_gastrocrew.png`**, and options (Android adaptive background, iOS alpha removal, etc.) live under **`flutter_launcher_icons:`** in **`pubspec.yaml`**.

**When you change or replace the launcher image**, regenerate icons for all configured platforms:

```bash
dart run flutter_launcher_icons
```

If you edited **`pubspec.yaml`** (paths, colors, or `flutter_launcher_icons` settings), run **`flutter pub get`** first, then **`dart run flutter_launcher_icons`**.

After regenerating, do a clean build if an old icon still appears (e.g. **`flutter clean`** then **`flutter run`** or your release build command).

---

## Quick reference

| Platform   | Run (dev API by default) | Build (prod API by default)                    |
|-----------|---------------------------|------------------------------------------------|
| All       | `flutter run`             | —                                              |
| Android   | `flutter run -d <id>`     | APK: `flutter build apk --release`             |
| Android   | —                         | Bundle: `flutter build appbundle --release`  |
| iOS       | `flutter run -d <id>`     | `flutter build ios --release`                  |
| Web       | `flutter run -d chrome`   | `flutter build web --release`                 |
| Windows   | `flutter run -d windows`  | `flutter build windows --release`             |
