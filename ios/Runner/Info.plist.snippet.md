## Required iOS entries

Add to `ios/Runner/Info.plist`:

```xml
<key>UIBackgroundModes</key>
<array>
  <string>voip</string>
  <string>audio</string>
  <string>remote-notification</string>
  <string>processing</string>
</array>
```

## Capabilities

Enable in Xcode:
- Push Notifications
- Background Modes: Voice over IP, Audio, AirPlay, Picture in Picture, Remote notifications
- (Optional) App Groups for shared call log
