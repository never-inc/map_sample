# map_sample

This is map sample code.

## Getting Started

```sh
% flutter doctor
Doctor summary (to see all details, run flutter doctor -v):
[[✓] Flutter (Channel stable, 3.27.1, on macOS 14.6.1 23G93 darwin-arm64, locale ja-JP)
[✓] Android toolchain - develop for Android devices (Android SDK version 34.0.0)
[✓] Xcode - develop for iOS and macOS (Xcode 16.2)
[✓] Chrome - develop for the web
[✓] Android Studio (version 2024.2)
[✓] VS Code (version 1.96.0)
```

### 環境変数

```sh
cp sample.env .env
```

`.env`にマップ利用に必要な情報を設定してください。

```dotenv
GOOGLE_MAP_API_KEY=
MAPBOX_ACCESS_TOKEN=
```

### 実行

```sh
flutter pub get
flutter run
```
