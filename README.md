# flutter-voip-callkit

Flutter POC for a small companion caller app: VoIP push, CallKit, PushKit, APNs, FCM,
full-screen incoming call notifications, deep links after accept.

## Stack

- Flutter + Riverpod
- `flutter_callkit_incoming` (CallKit UI on iOS, full-screen call notification on Android)
- `flutter_voip_pushkit` (PushKit/VoIP token on iOS)
- `firebase_messaging` (FCM data push on Android, background handler)
- Native iOS `AppDelegate` wired to `PKPushRegistry` + `CXProvider`

## What it shows

- Acquire & display FCM token + iOS VoIP/PushKit token (server registers per device)
- Receive VoIP push on iOS, report incoming call to CallKit within the OS deadline
- Receive FCM data message on Android, show full-screen call notification on lockscreen
- Accept / decline flow, missed-call callback, deep link payload pass-through
- Local call/message history
- Online/offline toggle

## Server payload (PushKit / FCM data)

```json
{
  "type": "call.incoming",
  "uuid": "8f5b9...",
  "handle": "+15551234567",
  "name": "Test Partner",
  "deep_link": "https://example.com/calls/8f5b9..."
}
```

## iOS setup

See `ios/Runner/Info.plist.snippet.md`. Background Modes: voip, audio, remote-notification.
APNs auth key (.p8) configured in Firebase console for FCM-on-iOS where needed.

## Android setup

See `android/app/src/main/AndroidManifest.xml.snippet`. Targets Android 13+ runtime
notification permission + `USE_FULL_SCREEN_INTENT` for lockscreen call UI.

## Run

```
flutter pub get
flutter run -d ios    # real device required for PushKit
flutter run -d android
```

## Status

POC scaffold focused on integration patterns: PushKit -> CallKit handoff, FCM data ->
foreground service, deep-link extraction, token registration. Not production-hardened.
