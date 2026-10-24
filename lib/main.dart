import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'design.dart';
import 'newspaper.dart';
import 'shelf.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LicenseRegistry.addLicense(() async* {
    yield LicenseEntryWithLineBreaks([
      'Noto Sans',
    ], await rootBundle.loadString('assets/fonts/OFL-notosans.txt'));
    yield LicenseEntryWithLineBreaks([
      'Noto Serif',
    ], await rootBundle.loadString('assets/fonts/OFL-notoserif.txt'));
    yield LicenseEntryWithLineBreaks([
      'Noto Sans Bengali',
    ], await rootBundle.loadString('assets/fonts/OFL-sans.txt'));
    yield LicenseEntryWithLineBreaks([
      'Noto Serif Bengali',
    ], await rootBundle.loadString('assets/fonts/OFL.txt'));
  });
  try {
    final papers = await loadPapers();
    final settings = SharedPreferencesAsync();
    Set<String> favourites = {};
    bool bangla = false, dark = false;
    String? lastPaper, warning;
    try {
      favourites = (await settings.getStringList('favourites') ?? []).toSet();
      bangla = await settings.getBool('bangla') ?? false;
      dark = await settings.getBool('darkMode') ?? false;
      lastPaper = await settings.getString('lastPaper');
    } catch (_) {
      warning =
          'Local settings could not be restored. You can still read newspapers.';
    }
    runApp(
      PatagharApp(
        papers: papers,
        settings: settings,
        initialFavourites: favourites,
        initialBangla: bangla,
        initialDark: dark,
        initialLastPaper: lastPaper,
        warning: warning,
      ),
    );
  } catch (_) {
    runApp(
      MaterialApp(
        theme: Newsprint.theme(Brightness.light),
        home: Scaffold(
          body: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.newspaper_outlined, size: 48),
                    const SizedBox(height: 16),
                    const Text('The newspaper catalogue could not load.'),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: main,
                      child: const Text('Try again'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PatagharApp extends StatefulWidget {
  const PatagharApp({
    super.key,
    required this.papers,
    this.settings,
    this.initialFavourites = const {},
    this.initialBangla = false,
    this.initialDark = false,
    this.initialLastPaper,
    this.warning,
  });
  final List<Newspaper> papers;
  final SharedPreferencesAsync? settings;
  final Set<String> initialFavourites;
  final bool initialBangla, initialDark;
  final String? initialLastPaper, warning;
  @override
  State<PatagharApp> createState() => _PatagharAppState();
}

class _PatagharAppState extends State<PatagharApp> {
  late Set<String> favourites;
  late bool bangla, dark;
  String? lastPaper, warning;
  @override
  void initState() {
    super.initState();
    favourites = {...widget.initialFavourites};
    bangla = widget.initialBangla;
    dark = widget.initialDark;
    lastPaper = widget.initialLastPaper;
    warning = widget.warning;
  }

  Future<void> persist(
    Future<void> Function(SharedPreferencesAsync) write,
  ) async {
    if (widget.settings == null) return;
    try {
      await write(widget.settings!);
    } catch (_) {
      if (mounted) {
        setState(
          () => warning = bangla
              ? 'পরিবর্তনটি এই ডিভাইসে সংরক্ষণ করা যায়নি।'
              : 'Your changes could not be saved on this device.',
        );
      }
    }
  }

  void toggleFavourite(String id) {
    setState(() {
      if (!favourites.add(id)) favourites.remove(id);
    });
    final snapshot = favourites.toList();
    unawaited(
      persist((settings) => settings.setStringList('favourites', snapshot)),
    );
  }

  void toggleLanguage() {
    setState(() => bangla = !bangla);
    final value = bangla;
    unawaited(persist((settings) => settings.setBool('bangla', value)));
  }

  void toggleTheme() {
    setState(() => dark = !dark);
    final value = dark;
    unawaited(persist((settings) => settings.setBool('darkMode', value)));
  }

  void recordOpened(String id) {
    setState(() => lastPaper = id);
    unawaited(persist((settings) => settings.setString('lastPaper', id)));
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'পাতাঘর · Pataghar',
    debugShowCheckedModeBanner: false,
    theme: Newsprint.theme(Brightness.light),
    darkTheme: Newsprint.theme(Brightness.dark),
    themeMode: dark ? ThemeMode.dark : ThemeMode.light,
    themeAnimationDuration:
        WidgetsBinding
            .instance
            .platformDispatcher
            .accessibilityFeatures
            .disableAnimations
        ? Duration.zero
        : const Duration(milliseconds: 180),
    home: NewspaperShelf(
      papers: widget.papers,
      bangla: bangla,
      dark: dark,
      favourites: favourites,
      lastPaper: lastPaper,
      warning: warning,
      onToggleFavourite: toggleFavourite,
      onToggleLanguage: toggleLanguage,
      onToggleTheme: toggleTheme,
      onOpened: recordOpened,
    ),
  );
}
