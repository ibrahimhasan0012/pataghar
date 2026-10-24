import 'dart:convert';
import 'package:flutter/services.dart';

class Newspaper {
  const Newspaper({
    required this.id,
    required this.name,
    required this.bangla,
    required this.language,
    required this.url,
    required this.access,
    required this.note,
    required this.source,
    required this.checkedOn,
  });
  final String id, name, bangla, language, url, access, note, source, checkedOn;
  bool get freeOption => access == 'PUBLIC_READER' || access == 'FREE_SIGN_IN';
  String title(bool bn) => bn ? bangla : name;
  Uri get uri => Uri.parse(url);
  String accessLabel(bool bn) => switch (access) {
    'PUBLIC_READER' => bn ? 'সরাসরি রিডার' : 'Public reader',
    'FREE_SIGN_IN' =>
      bn ? 'আজকের সংখ্যা ফ্রি · লগইন' : 'Free today · Sign-in required',
    'SUBSCRIPTION' => bn ? 'সাবস্ক্রিপশন' : 'Publisher subscription',
    _ => bn ? 'পড়ার শর্ত যাচাই হয়নি' : 'Access not verified',
  };
  bool matches(
    String query,
    String filter,
    Set<String> favourites,
    bool savedOnly,
  ) {
    if (savedOnly && !favourites.contains(id)) return false;
    if (filter == 'free' && !freeOption) return false;
    if ((filter == 'Bangla' || filter == 'English') && language != filter) {
      return false;
    }
    return '$name $bangla $language'.toLowerCase().contains(
      query.trim().toLowerCase(),
    );
  }

  factory Newspaper.fromJson(Map<String, dynamic> j) {
    final url = j['url'] as String;
    if (!safeWebUrl(Uri.parse(url))) {
      throw FormatException('Invalid publisher URL: $url');
    }
    return Newspaper(
      id: j['id'],
      name: j['name'],
      bangla: j['bangla'],
      language: j['language'],
      url: url,
      access: j['access'],
      note: j['note'],
      source: j['source'],
      checkedOn: j['checkedOn'],
    );
  }
}

bool safeWebUrl(Uri uri) =>
    uri.scheme == 'https' && uri.host.isNotEmpty && uri.userInfo.isEmpty;

Future<List<Newspaper>> loadPapers() async {
  final raw =
      jsonDecode(await rootBundle.loadString('assets/papers.json')) as List;
  return raw.map((j) => Newspaper.fromJson(j as Map<String, dynamic>)).toList();
}
