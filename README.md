# পাতাঘর · Pataghar

A Flutter app for Android, iOS and web. All platforms share the newspaper shelf and reader screen. The initial catalogue contains 16 Bangladeshi publications, search in English and Bangla, access labels, a free-options filter, favourites, day/night themes, list/grid layouts, a last-opened shortcut and interface language selection.

## Download for Android

[Download Pataghar 0.3.0 APK](https://github.com/ibrahimhasan0012/pataghar/releases/download/v0.3.0/Pataghar-0.3.0-Android.apk) · [All releases](https://github.com/ibrahimhasan0012/pataghar/releases)

Download the APK on your Android phone, open it, and allow installation from your browser or file manager when Android asks. Android 7.0 or newer is required. This preview is compiled in release mode and signed with a development key; it is not a Google Play release. Publisher subscriptions and login requirements still apply.

![Pataghar phone layout](previews/v03-phone-light.png)

## Reading

On Android and iOS, the shared reader screen embeds the official publisher site with the system WebView. On web it embeds the site in an iframe. Publishers provide their own page layout, page navigation, date selection, zoom, advertising and login. The app does not convert different publications into a uniform page-image format.

Some publishers block embedding in other websites or do not support login in embedded browsers. The reader always offers **Open publisher** to open the official site separately. The app respects browser embedding restrictions; it does not remove response headers or use a proxy to bypass them. A blank iframe cannot reliably be detected across origins.

The app does not require a PDF download. Reading still transfers data and may use browser/WebView caching. Publisher sites may offer downloads. Paid subscriptions, login requirements and publisher restrictions still apply.

## Run

Install a current stable Flutter SDK, then run from this folder:

```sh
flutter pub get
flutter run -d <android-device-id>
flutter run -d <ios-device-id>
flutter run -d chrome
```

For Android, install the SDK components required by the generated Flutter project and use JDK 17 or newer as required by its Gradle version. For iOS, use macOS with full Xcode, its SDKs, CocoaPods if needed, and a development team for signing a physical-device build. iOS source is included; local compilation is not evidence of App Store acceptance.

```sh
flutter analyze
flutter test
flutter build web
flutter build apk --release
flutter build ios --no-codesign
```

## Catalogue

Maintain `assets/papers.json`. Every entry includes its official reader URL, access category, research note, source and review date. Dates refer to link/access research, not verification of that day’s issue. The catalogue is bundled and does not update remotely. Check the issue date inside each publisher reader.

On 24 October 2026, public readers were visible for Ajker Patrika, Ittefaq and Jugantor. Prothom Alo’s FAQ stated that the current edition is free with ads and requires registration; archives and ad-free access are paid. TBS displayed subscription plans. Remaining access labels are explicitly unverified. A blocked automated request does not prove a site is unavailable or paid.

Sources: [Prothom Alo FAQ](https://static.eprothomalo.com/faq.html), [MRDI directory](https://mrdibd.org/paonlmedia/), and the linked publisher sites.

## Privacy

Favourites, language, theme and the last-opened newspaper ID are stored locally using platform preferences or browser storage. The app has no server, account, analytics or advertising SDK. Publisher pages make their own network requests, set cookies and apply their own privacy policies. WebView cookies and browser cookies may be separate. Preferences are not synced between devices.

## Verification

See `VERIFICATION.md` for actual build and test results and device-testing limitations. This repository contains the active Flutter app.

## Design update (0.2.0)

The shelf now uses bundled Noto Serif Bengali and Noto Sans Bengali fonts, more compact cards, accessible access badges and a night theme. The reader includes focus mode and a clearer publisher fallback. Larger system text switches the shelf to a flexible list. Last opened reopens a publisher reader without claiming to restore a particular issue or page position. Night theme changes app controls; publisher pages keep their original colours.

[DESIGN.md](DESIGN.md) documents the applied UI UX Pro Max guidance, Wonderous reference, design decisions and font licences.

## Mobile update (0.3.0)

Phones now start with tappable newspaper rows, a shorter heading and separate favourite/access buttons. Wider screens retain the grid. The app includes a consistent Pataghar launcher and startup mark, Android adaptive/themed icons, and replacement iPhone/iPad and web install icons. English and Bengali headings and controls use four bundled Noto font families. Theme, language and favourite preferences remain compatible with earlier versions.

The release-mode preview APK still uses the development signing certificate so it can update the earlier APK. A production signing setup is required before store distribution. See `VERIFICATION.md` for the current download and device-testing limits.
