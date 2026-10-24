# Pataghar 0.3 design

The app uses a newspaper-inspired shelf: warm paper surfaces, forest-green controls, restrained rust and blue accents, serif mastheads, and compact access badges. The mastheads are text treatments; the app does not bundle publisher logos or fabricate front-page previews.

## Sources applied

- [UI UX Pro Max](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill), reviewed at commit `d14efff8ed1faa4187f004f79926f428c8074ec7`. Read its skill and app quality rules, then ran the local design-system, Flutter adaptive-layout, and dark-mode contrast searches. Relevant recommendations were editorial typography, readable colour pairs, semantic theme tokens, TextScaler-aware layouts, standard controls, and accessible touch targets. Its generated marketing-page layouts were unsuitable for the reader catalogue and were not adopted. Colour and layout choices here are app-specific decisions. The skill was used locally for this task, not installed as a global agent skill. Its MIT notice is retained in `design-sources/`.
- [Wonderous](https://github.com/gskinnerTeam/flutter-wonderous-app), by gskinner and the Flutter team, was reviewed as a Flutter visual reference. No Wonderous code, illustrations, photographs or other assets were copied.
- [Noto Serif Bengali](https://github.com/google/fonts/tree/main/ofl/notoserifbengali) and [Noto Sans Bengali](https://github.com/google/fonts/tree/main/ofl/notosansbengali), bundled for headings and body text. Both are distributed under the SIL Open Font License, included with the font assets and shown through the app’s licence screen. No runtime font service is required for these fonts.

## Implemented behaviour

- A responsive shelf with grid/list switching, labelled search and a clear-search action.
- Day and night palettes, with the selected theme saved locally.
- Favourites and language settings retained across this update.
- A last-opened shortcut saved locally. This reopens the publisher reader, not a saved issue or page position.
- A shared reader with focus mode, reading help and a direct publisher fallback.
- Night theme affects app controls. The original publisher pages retain their own colours and controls. A white reader canvas preserves legibility when a publisher leaves its page background transparent.
- Text contrast and status badges tested in both themes. Larger system text switches the shelf to a flexible list instead of shrinking the text.
- Standard touch controls, labelled icons and a semantic action for each read button. Decorative newspaper symbols are excluded from screen-reader output.

Publisher access requirements, the 16-publication catalogue and the evidence dates are unchanged. No subscription or embedding restrictions are bypassed.

## Phone layout and install identity (0.3.0)

Phones below 600 logical pixels start with a single column of newspaper rows. Tapping the newspaper area opens its reader; the favourite and access-detail actions have separate touch targets. The shorter heading puts search, filters and newspapers nearer the top. Dragging the shelf dismisses the keyboard. Grid/list switching remains available, and wider screens start with the grid. Large system text keeps rows flexible and hides the decorative paper thumbnail to leave room for text.

The original Pataghar mark now appears in the app header, Android launcher, Android startup screen, iPhone/iPad icons and launch screen, and web install icons. Android includes adaptive icons, a monochrome themed icon for Android 13+, and density-specific legacy icons. iOS icons have an opaque background. `tool/generate_brand.py` reproduces these geometric assets with Pillow; no publisher logos are used.

English headings use bundled Noto Serif, with Noto Serif Bengali for Bengali glyphs. Controls and body text use Noto Sans and Noto Sans Bengali. All four font families are bundled under their included SIL Open Font Licenses, registered in the licence screen. Fonts do not depend on a runtime network request. The official Latin font sources are [Noto Sans](https://github.com/google/fonts/tree/main/ofl/notosans) and [Noto Serif](https://github.com/google/fonts/tree/main/ofl/notoserif).

The previews in `previews/v03-phone-*.png` are Flutter widget renders at 390 x 844 logical pixels, not Android device screenshots. To regenerate them, run `flutter test tool/capture_preview_test.dart --update-goldens`.
