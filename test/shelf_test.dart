import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pataghar/main.dart';
import 'package:pataghar/newspaper.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late List<Newspaper> papers;
  setUpAll(() async {
    papers = await loadPapers();
  });
  testWidgets('search, save a paper, revisit favourites and switch language', (
    tester,
  ) async {
    await tester.pumpWidget(PatagharApp(papers: papers));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Prothom');
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.byTooltip('Add favourite'),
      180,
      scrollable: find
          .descendant(
            of: find.byType(CustomScrollView),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    await tester.tap(find.byTooltip('Add favourite'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Favourites'));
    await tester.pumpAndSettle();
    expect(find.text('Prothom Alo'), findsOneWidget);
    expect(find.byTooltip('Remove favourite'), findsOneWidget);
    await tester.tap(
      find.descendant(of: find.byType(AppBar), matching: find.text('বাংলা')),
    );
    await tester.pumpAndSettle();
    expect(find.text('আপনার পছন্দের পত্রিকা।'), findsOneWidget);
    expect(find.text('ই-পেপার পড়ুন'), findsOneWidget);
  });

  testWidgets(
    'empty search recovers and free filter shows sign-in requirements',
    (tester) async {
      await tester.pumpWidget(PatagharApp(papers: papers));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'missing-newspaper');
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.text('Nothing on this shelf yet.'),
        180,
        scrollable: find
            .descendant(
              of: find.byType(CustomScrollView),
              matching: find.byType(Scrollable),
            )
            .first,
      );
      expect(find.text('Nothing on this shelf yet.'), findsOneWidget);
      await tester.ensureVisible(find.byType(TextField));
      await tester.enterText(find.byType(TextField), 'Prothom');
      await tester.tap(find.text('Free options'));
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.text('Free today · Sign-in required'),
        180,
        scrollable: find
            .descendant(
              of: find.byType(CustomScrollView),
              matching: find.byType(Scrollable),
            )
            .first,
      );
      expect(find.text('Free today · Sign-in required'), findsOneWidget);
    },
  );
}
