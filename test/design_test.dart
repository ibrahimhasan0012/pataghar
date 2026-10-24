import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pataghar/design.dart';
import 'package:pataghar/main.dart';
import 'package:pataghar/newspaper.dart';
import 'package:pataghar/reader_screen.dart';
import 'package:pataghar/paper_widgets.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late List<Newspaper> papers;
  setUpAll(() async {
    papers = await loadPapers();
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
  });

  testWidgets('phone starts with touch rows and desktop starts with a grid', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    tester.view.physicalSize = const Size(375, 812);
    await tester.pumpWidget(PatagharApp(papers: papers));
    await tester.pumpAndSettle();
    expect(find.byType(MobilePaperTile), findsWidgets);
    expect(find.byType(PaperCard), findsNothing);
    await tester.tap(find.byTooltip('Show grid view'));
    await tester.pumpAndSettle();
    expect(find.byType(PaperCard), findsWidgets);
    expect(tester.takeException(), isNull);
    tester.view.physicalSize = const Size(1200, 900);
    await tester.pumpWidget(
      PatagharApp(key: const ValueKey('desktop'), papers: papers),
    );
    await tester.pumpAndSettle();
    expect(find.byType(MobilePaperTile), findsNothing);
    expect(find.byType(PaperCard), findsWidgets);
  });

  testWidgets('phone row separates reading, favourite and access actions', (
    tester,
  ) async {
    var read = 0, saved = 0, details = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: Newsprint.theme(Brightness.light),
        home: Scaffold(
          body: SizedBox(
            width: 375,
            child: MobilePaperTile(
              paper: papers.first,
              bangla: false,
              saved: false,
              onRead: () => read++,
              onSave: () => saved++,
              onDetails: () => details++,
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.byTooltip('Add favourite'));
    await tester.tap(find.byTooltip('Access details'));
    expect(read, 0);
    expect(saved, 1);
    expect(details, 1);
    await tester.tap(find.text(papers.first.title(false)));
    expect(read, 1);
  });

  test('text and status colours meet 4.5:1 in both themes', () {
    double ratio(Color a, Color b) {
      final l1 = a.computeLuminance();
      final l2 = b.computeLuminance();
      return (l1 > l2 ? l1 + .05 : l2 + .05) / (l1 > l2 ? l2 + .05 : l1 + .05);
    }

    for (final brightness in Brightness.values) {
      final c = Newsprint.theme(brightness).colorScheme;
      for (final pair in [
        (c.onSurface, c.surface),
        (c.onSurfaceVariant, c.surfaceContainerLow),
        (c.onSurfaceVariant, c.surfaceContainer),
        (c.onPrimary, c.primary),
        (c.onPrimaryContainer, c.primaryContainer),
        (c.onSecondaryContainer, c.secondaryContainer),
      ]) {
        expect(
          ratio(pair.$1, pair.$2),
          greaterThanOrEqualTo(4.5),
          reason: '$brightness: ${pair.$1} / ${pair.$2}',
        );
      }
    }
  });

  testWidgets('night theme and last opened newspaper are available', (
    tester,
  ) async {
    await tester.pumpWidget(
      PatagharApp(papers: papers, initialLastPaper: 'ajker-patrika'),
    );
    await tester.pumpAndSettle();
    expect(find.text('LAST OPENED'), findsOneWidget);
    await tester.tap(find.byTooltip('Switch to night theme'));
    await tester.pumpAndSettle();
    expect(
      Theme.of(tester.element(find.byType(Scaffold).first)).brightness,
      Brightness.dark,
    );
    expect(find.byTooltip('Switch to day theme'), findsOneWidget);
  });

  testWidgets('catalogue fits a small phone, landscape and large system text', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    for (final size in [
      const Size(375, 812),
      const Size(812, 375),
      const Size(320, 640),
      const Size(1440, 1000),
    ]) {
      tester.view.physicalSize = size;
      await tester.pumpWidget(
        PatagharApp(
          key: ValueKey(size),
          papers: papers,
          initialDark: size.width > 1000,
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: '$size');
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -450));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: 'scrolling $size');
    }
    tester.view.physicalSize = const Size(375, 812);
    tester.platformDispatcher.textScaleFactorTestValue = 3;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await tester.pumpWidget(
      PatagharApp(
        key: const ValueKey('large-fonts'),
        papers: papers,
        initialBangla: true,
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.drag(find.byType(CustomScrollView), const Offset(0, -600));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('reduced animation setting changes theme without a transition', (
    tester,
  ) async {
    tester.platformDispatcher.accessibilityFeaturesTestValue =
        const FakeAccessibilityFeatures(
          disableAnimations: true,
          reduceMotion: true,
        );
    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
    await tester.pumpWidget(PatagharApp(papers: papers));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Switch to night theme'));
    await tester.pump();
    final actual = Theme.of(
      tester.element(find.byType(Scaffold).first),
    ).colorScheme.surface;
    expect(actual, Newsprint.theme(Brightness.dark).colorScheme.surface);
    await tester.pumpAndSettle();
  });

  testWidgets('shared reader can enter and leave focus mode', (tester) async {
    final paper = papers.singleWhere((p) => p.id == 'ajker-patrika');
    await tester.pumpWidget(
      MaterialApp(
        theme: Newsprint.theme(Brightness.light),
        home: ReaderScreen(
          paper: paper,
          bangla: false,
          readerBuilder: (focus) => Center(
            child: Text(focus ? 'Focused publisher' : 'Publisher contents'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Public reader'), findsOneWidget);
    await tester.tap(find.byTooltip('Focus mode'));
    await tester.pumpAndSettle();
    expect(find.text('Exit focus'), findsOneWidget);
    expect(find.text('Public reader'), findsNothing);
    expect(find.text('Focused publisher'), findsOneWidget);
    await tester.tap(find.text('Exit focus'));
    await tester.pumpAndSettle();
    expect(find.text('Public reader'), findsOneWidget);
  });
}
