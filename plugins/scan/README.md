# scan

Local copy of scan 1.6.0. The Android implementation omits Huawei Scan Kit,
whose prebuilt native libraries triggered the Google Play 16 KB page-size
warning. The live `ScanView` camera path remains ZXing-based; image decoding
through `Scan.parse` uses the plugin's existing ZXing fallback.

[![scan](https://img.shields.io/badge/pub-1.6.0-orange)](https://pub.dev/packages/scan)

scan qrcode & barcode in widget tree.

decode qrcode & barcode image from path.

> if you want to generate qrcode image, you should use [qr_flutter](https://pub.dev/packages/qr_flutter)

### Features

- use `ScanView` in widget tree to show scan view.
- custom identifiable area.
- decode qrcode from image path by `Scan.parse`.

### prepare

##### ios
info.list
```
<key>NSCameraUsageDescription</key>
<string>Your Description</string>

<key>io.flutter.embedded_views_preview</key>
<string>YES</string>
```
##### android
```xml
<uses-permission android:name="android.permission.CAMERA" />

<application>
  <meta-data
    android:name="flutterEmbedding"
    android:value="2" />
</application>
```

```yaml
scan:
  path: plugins/scan
```
```dart
import 'package:scan/scan.dart';
```

### Usage

- show scan view in widget tree
```dart
ScanController controller = ScanController();
String qrcode = 'Unknown';

Container(
  width: 250, // custom wrap size
  height: 250,
  child: ScanView(
    controller: controller,
// custom scan area, if set to 1.0, will scan full area
    scanAreaScale: .7,
    scanLineColor: Colors.green.shade400,
    onCapture: (data) {
      // do something
    },
  ),
),
```
- you can use `controller.resume()` and `controller.pause()` resume/pause camera

```dart
controller.resume();
controller.pause();
```
- get qrcode string from image path
```dart
String result = await Scan.parse(imagePath);
```
- toggle flash light
```dart
controller.toggleTorchMode();
```
### Android shrinker rules

This local version has no Huawei Scan Kit dependency or Huawei-specific
shrinker rules.

# License
MIT License


