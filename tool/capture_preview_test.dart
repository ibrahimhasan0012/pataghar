// Render Flutter widgets at phone dimensions; these are not device screenshots.
// flutter test tool/capture_preview_test.dart --update-goldens
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pataghar/main.dart';
import 'package:pataghar/newspaper.dart';

void main() {
  testWidgets('export phone layout previews with bundled fonts', (
    tester,
  ) async {
    for (final entry in {
      'Newsprint': 'NotoSerif',
      'NewsprintBengali': 'NotoSerifBengali',
      'ReaderSans': 'NotoSans',
      'ReaderBengali': 'NotoSansBengali',
    }.entries) {
      await (FontLoader(
        entry.key,
      )..addFont(rootBundle.load('assets/fonts/${entry.value}.ttf'))).load();
    }
    await (FontLoader(
      'MaterialIcons',
    )..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'))).load();
    final papers = await loadPapers();
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    for (final dark in [false, true]) {
      await tester.pumpWidget(
        PatagharApp(
          key: ValueKey(dark),
          papers: papers,
          initialDark: dark,
          initialBangla: dark,
        ),
      );
      await tester.runAsync(
        () => precacheImage(
          const AssetImage('assets/brand/pataghar.png'),
          tester.element(find.byType(PatagharApp)),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await expectLater(
        find.byType(PatagharApp),
        matchesGoldenFile(
          '../previews/v03-phone-${dark ? "dark-bangla" : "light"}.png',
        ),
      );
    }
  });
}
