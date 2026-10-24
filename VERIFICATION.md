# Verification: Pataghar 0.3.0

Verified on 24 October 2026 with Flutter 3.47.8 stable and Dart 3.13.7.

- `flutter analyze`: passed with no issues.
- `flutter test`: all 12 tests passed. Checks cover search, favourites, access filters, safe URLs, language and theme switching, last-opened display, contrast, flexible layouts, reduced animation, reader focus mode, phone/desktop defaults, and separation of row reading/favourite/access actions.
- Responsive widget checks used all four bundled font families at 320 x 640, 375 x 812, 812 x 375 and 1440 x 1000. Bangla at 3x system text scaling passed without layout exceptions.
- Normal text and status badge colour pairs passed the 4.5:1 contrast checks in both themes.
- `flutter build apk --release`: passed. Package `bd.pataghar.pataghar`, version `0.3.0` (3), minimum API 24 (Android 7.0), target API 36. Includes arm64-v8a, armeabi-v7a and x86_64 libraries.
- APK v2 signature and ZIP integrity checks passed. Its signing certificate matches the previous 0.2.0 APK. The packaged APK contains the four fonts, new app mark and 16-publication catalogue.
- Installable file: `Pataghar-0.3.0-Android.apk` in [GitHub Releases](https://github.com/ibrahimhasan0012/pataghar/releases/tag/v0.3.0) (56,013,083 bytes). Its SHA-256 checksum is alongside it.
- Android resource XML parsed successfully. The manifest references the new launcher icons. Adaptive and monochrome icon sources and density-specific fallback images are included.
- Every iPhone/iPad icon entry has its expected dimensions and an opaque RGB background. Web manifest icon sizes match the generated images. The iOS launch storyboard parses successfully.
- `flutter test tool/capture_preview_test.dart --update-goldens`: passed and exported light/English and dark/Bangla phone previews at 390 x 844. These are Flutter widget renders, not physical-device or emulator screenshots. The icon font and all four text fonts are loaded for these renders.
- `flutter build web`: passed, including its WebAssembly compatibility dry run. Flutter emitted a nonfatal notice about an unused Cupertino icon font; app icons use Material icons.

The APK uses release compilation with the existing development signing certificate. It is a preview build, not a store-signed production release. No Android emulator or physical-phone UI test was performed here. Matching package ID and certificate, together with the higher version code, support updating the earlier APK; the preference keys are retained.

The iOS project, launcher artwork and launch screen are updated in source. iOS has not been compiled or tested because this machine lacks full Xcode. Signing and device verification remain necessary.

Publisher login, payments and archives were not exercised. Embedding compatibility varies by publisher. Open publisher remains available. No access-control or frame-header bypass is implemented. Publisher content retains its own typography, controls and colours.

See `DESIGN.md` for the design references and `tool/generate_brand.py` for reproducible icon generation.
