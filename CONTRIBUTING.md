# Contributing to Pataghar

Thanks for helping improve the reader. Check the open issues before starting a large change, and use an issue to discuss a new feature that would change the catalogue or reading flow.

## Local checks

Use a current stable Flutter SDK. Run these checks before opening a pull request:

```sh
flutter pub get
flutter analyze
flutter test
```

Add a focused test when a change affects search, filtering, favourites, access labels, navigation or layout behaviour. Android builds also need the Android SDK and JDK 17.

## Newspaper entries

Edit `assets/papers.json` for catalogue changes. Use the publisher's official e-paper or print-edition reader URL. Include a source, the date you checked it and an access label backed by what you observed. Do not mark a paper free solely because its landing page loads; verify whether the issue itself needs an account or subscription.

Do not add copied issue files, publisher artwork, access bypasses, or a proxy that removes publisher restrictions. Keep fallback navigation to the official site available when embedding fails.

## Pull requests

Describe the user-visible change, its reason and the checks you ran. Include a phone-sized screenshot for a visible UI change when possible, and say whether it came from a device, emulator or Flutter widget render. Keep unrelated changes in separate pull requests.

The original app code and artwork are MIT licensed. Bundled fonts retain their own SIL Open Font Licenses, and publisher content belongs to its publishers.
