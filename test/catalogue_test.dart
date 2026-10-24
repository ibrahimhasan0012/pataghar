import 'package:flutter_test/flutter_test.dart';
import 'package:pataghar/newspaper.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test(
    'catalogue destinations are safe and paid or unknown readers stay out of free filter',
    () async {
      final papers = await loadPapers();
      expect(papers.map((p) => p.id).toSet().length, papers.length);
      for (final p in papers) {
        expect(safeWebUrl(p.uri), isTrue, reason: p.name);
        expect(safeWebUrl(Uri.parse(p.source)), isTrue, reason: p.name);
      }
      final free = papers.where((p) => p.matches('', 'free', {}, false));
      expect(free.map((p) => p.id), contains('prothom-alo'));
      expect(
        free.any((p) => p.access == 'SUBSCRIPTION' || p.access == 'UNKNOWN'),
        isFalse,
      );
      expect(papers.singleWhere((p) => p.id == 'tbs').access, 'SUBSCRIPTION');
    },
  );
  test(
    'reader navigation rejects script, unencrypted and credential-bearing URLs',
    () {
      for (final url in [
        'javascript:alert(1)',
        'http://example.com',
        'https://user:password@example.com',
        'file:///tmp/document',
        'intent://example',
      ]) {
        expect(safeWebUrl(Uri.parse(url)), isFalse);
      }
      expect(safeWebUrl(Uri.parse('https://epaper.ittefaq.com.bd/')), isTrue);
    },
  );
  test('Bangla search and favourites combine with language filters', () async {
    final papers = await loadPapers();
    final found = papers.where(
      (p) => p.matches('প্রথম', 'Bangla', {'prothom-alo'}, true),
    );
    expect(found.single.id, 'prothom-alo');
    expect(
      papers.where((p) => p.matches('প্রথম', 'English', {'prothom-alo'}, true)),
      isEmpty,
    );
  });
}
