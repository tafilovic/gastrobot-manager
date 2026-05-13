# NotificationService (iOS NSE)

iOS **Notification Service Extension** that intercepts every push and replaces
the system-displayed title/body with localized text from this extension's own
`Localizable.strings` resources.

Logic mirrors the Flutter `NotificationLocalizer`
(`lib/features/notifications/data/notification_localizer.dart`) so banners look
the same in foreground (Dart-rendered) and background/killed (NSE-rendered).

## Files

- `NotificationService.swift` — entry point (`UNNotificationServiceExtension`).
- `PayloadLocalizer.swift` — translation logic (mirror of Dart `NotificationLocalizer`).
- `<locale>.lproj/Localizable.strings` — translations per language.
- `Info.plist` — `NSExtension` config + supported locales.

The target uses `PBXFileSystemSynchronizedRootGroup`, so adding new files or
`*.lproj` folders here is picked up by Xcode automatically — no manual
"Add Files…" step required.

## What the backend must send

For NSE to run, the APNs payload **must** include `mutable-content: 1`.
A complete example (Firebase Admin SDK / FCM HTTP v1):

```json
{
  "message": {
    "apns": {
      "payload": {
        "aps": {
          "mutable-content": 1,
          "alert": {
            "title": "order.for_table",
            "body": ""
          },
          "sound": "default"
        }
      }
    },
    "data": {
      "title": "order.for_table",
      "body": "{\"table\":\"5\",\"items\":[{\"productName\":\"Burger\",\"quantity\":2}]}",
      "type": "order",
      "entityId": "order-uuid",
      "locale": "sr"
    }
  }
}
```

Notes:

- `aps.mutable-content` is **required**. Without it iOS never starts NSE and
  shows whatever is in `aps.alert` verbatim (the raw keys).
- `data.title` is the translation key (mirrors `NotificationPayload.titleKey`).
- `data.body` is a **JSON string** containing the interpolation values. The
  same shape as `body` in `push-messaging-and-notifications-guide.md`.
- `data.locale` is **optional**. When present, NSE forces that language
  regardless of the iOS system language. Recommended so banners match the
  user's chosen app locale (the user may run the app in Serbian while their
  iOS Settings are in English).

## Locale resolution order

1. `data["locale"]` if provided by the backend.
2. iOS preferred languages matched against `CFBundleLocalizations` in `Info.plist`.
3. English fallback.

## Adding a new translation

1. Add the key to `lib/l10n/app_*.arb` and update Dart code if needed.
2. Add the same key to **all** `<locale>.lproj/Localizable.strings` here using
   `%@` (single arg) or `%1$@`, `%2$@`, … (multiple positional args) — the
   order **must** match `PayloadLocalizer`.
3. Extend `PayloadLocalizer.resolveTitle` / `resolveMessage` /
   `resolveFallbackBody` switch statements for the new key.

## Adding a new language

1. Add an entry to `supportedLocales` in `LocaleProvider` (Dart) and create
   the matching `lib/l10n/app_<code>.arb`.
2. Add `ios/NotificationService/<code>.lproj/Localizable.strings`.
3. Add `<code>` to `Self.supportedLocales` in `PayloadLocalizer.swift`.
4. Add `<code>` to `CFBundleLocalizations` in `Info.plist`.

## Capabilities & signing

- Bundle ID: `com.brrm.eu.gastro-app-dashboard.NotificationService` (must be prefixed with the host app’s bundle ID).
- Same Apple Team as `Runner`; separate provisioning profile / App ID is
  required for App Store distribution.
- NSE does **not** need `Background Modes`; iOS launches it from APNs.

## Foreground behavior

The Flutter foreground path (`PushNotificationService._showForegroundNotification`)
still uses `flutter_local_notifications` + the Dart `NotificationLocalizer`. NSE
is only relevant when the OS shows the system banner (background/killed). Both
paths must stay in sync — keep ARB and `Localizable.strings` aligned when
strings change.
