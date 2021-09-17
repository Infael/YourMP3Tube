# YourMP3Tube

This is an app made in Flutter to extract and download mp3 stream from Youtube video.

![Effective Dart](https://img.shields.io/badge/style-effective_dart-40c4ff.svg)

---

The app is mainly for Android, it was never tried on iOS!

It is using [youtube_explode_dart](https://pub.dev/packages/youtube_explode_dart) to find and download video stream, [pemission_handler](https://pub.dev/packages/permission_handler), [path_provider](https://pub.dev/packages/path_provider) and [flutter_ffmpeg](https://pub.dev/packages/flutter_ffmpeg) to convert .webm file to .mp3. 

## Usage
Clone and run 
```shell
flutter pub get
flutter run
```

## Create apk and install
--no-shrink in first command is important, without it [flutter_ffmpeg](https://pub.dev/packages/flutter_ffmpeg) doesn't work
```shell
flutter build apk --split-per-abi --no-shrink
flutter install
flutter clean
```

## Created & Maintained By

[Michal Štefaňák](https://github.com/Infael)

## Getting Started

For help getting started with Flutter, view our online
[documentation](http://flutter.io/).

For help on editing plugin code, view the [documentation](https://flutter.io/platform-plugins/#edit-code).
