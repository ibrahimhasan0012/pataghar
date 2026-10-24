import 'package:flutter/material.dart';

/// App colours and typography. Publisher pages retain their own appearance.
abstract final class Newsprint {
  static const radius = 16.0;
  static const gutter = 16.0;
  static const font = 'Newsprint';
  static const brand = Color(0xFF175440);
  static const accents = [
    Color(0xFF9D4328),
    Color(0xFF175440),
    Color(0xFF365778),
    Color(0xFF78513C),
  ];

  static Color accent(String id, BuildContext context) {
    final index =
        id.codeUnits.fold(0, (a, b) => (a * 31 + b) & 0x7fffffff) %
        accents.length;
    final base = accents[index];
    return Theme.of(context).brightness == Brightness.dark
        ? Color.lerp(base, const Color(0xFFFFF0D8), .55)!
        : base;
  }

  static ThemeData theme(Brightness brightness) {
    final dark = brightness == Brightness.dark;
    final scheme =
        ColorScheme.fromSeed(seedColor: brand, brightness: brightness).copyWith(
          primary: dark ? const Color(0xFFAEDBC1) : brand,
          onPrimary: dark ? const Color(0xFF123F2C) : Colors.white,
          primaryContainer: dark
              ? const Color(0xFF294F3B)
              : const Color(0xFFE0EBE3),
          onPrimaryContainer: dark
              ? const Color(0xFFD7EBDD)
              : const Color(0xFF183E2C),
          secondary: dark ? const Color(0xFFEBA386) : const Color(0xFF9D4328),
          secondaryContainer: dark
              ? const Color(0xFF50352C)
              : const Color(0xFFF7E4DA),
          onSecondaryContainer: dark
              ? const Color(0xFFFFDCCB)
              : const Color(0xFF66301E),
          surface: dark ? const Color(0xFF141E1A) : const Color(0xFFF6F3EC),
          surfaceContainerLow: dark
              ? const Color(0xFF1D2923)
              : const Color(0xFFFFFCF7),
          surfaceContainer: dark
              ? const Color(0xFF25332B)
              : const Color(0xFFEDEDE4),
          onSurface: dark ? const Color(0xFFF4F1E8) : const Color(0xFF1D2C27),
          onSurfaceVariant: dark
              ? const Color(0xFFBCC8BE)
              : const Color(0xFF58655F),
          outline: dark ? const Color(0xFF899C8E) : const Color(0xFF7B8B80),
          outlineVariant: dark
              ? const Color(0xFF3D5144)
              : const Color(0xFFDADDD4),
        );
    final base = ThemeData(
      brightness: brightness,
      fontFamily: 'ReaderSans',
      fontFamilyFallback: const ['ReaderBengali', 'NewsprintBengali'],
      useMaterial3: true,
      colorScheme: scheme,
    );
    final type = base.textTheme.copyWith(
      headlineLarge: TextStyle(
        fontFamily: font,
        fontFamilyFallback: const ['NewsprintBengali'],
        fontSize: 30,
        height: 1.35,
        fontWeight: FontWeight.w700,
        color: scheme.onSurface,
      ),
      headlineSmall: TextStyle(
        fontFamily: font,
        fontFamilyFallback: const ['NewsprintBengali'],
        fontSize: 23,
        height: 1.35,
        fontWeight: FontWeight.w700,
        color: scheme.onSurface,
      ),
      titleLarge: TextStyle(
        fontFamily: font,
        fontFamilyFallback: const ['NewsprintBengali'],
        fontSize: 21,
        height: 1.4,
        fontWeight: FontWeight.w700,
        color: scheme.onSurface,
      ),
      bodyLarge: TextStyle(
        fontFamily: 'ReaderSans',
        fontFamilyFallback: const ['ReaderBengali'],
        fontSize: 16,
        height: 1.5,
        color: scheme.onSurface,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'ReaderSans',
        fontFamilyFallback: const ['ReaderBengali'],
        fontSize: 16,
        height: 1.45,
        color: scheme.onSurface,
      ),
      bodySmall: TextStyle(
        fontFamily: 'ReaderSans',
        fontFamilyFallback: const ['ReaderBengali'],
        fontSize: 12,
        height: 1.4,
        color: scheme.onSurfaceVariant,
      ),
      labelLarge: TextStyle(
        fontFamily: 'ReaderSans',
        fontFamilyFallback: const ['ReaderBengali'],
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    );
    return base.copyWith(
      scaffoldBackgroundColor: scheme.surface,
      textTheme: type,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        titleTextStyle: type.titleLarge,
      ),
      cardTheme: CardThemeData(
        color: scheme.surfaceContainerLow,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
          side: BorderSide(color: scheme.outlineVariant),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerLow,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(48, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(minimumSize: const Size(48, 48)),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 72,
        backgroundColor: scheme.surfaceContainerLow,
        indicatorColor: scheme.primaryContainer,
        surfaceTintColor: Colors.transparent,
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant,
        thickness: 1,
        space: 1,
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: scheme.surfaceContainerLow,
        selectedColor: scheme.primaryContainer,
        side: BorderSide(color: scheme.outlineVariant),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        labelStyle: TextStyle(
          fontFamily: 'ReaderSans',
          fontFamilyFallback: const ['ReaderBengali'],
          fontSize: 13,
          color: scheme.onSurface,
        ),
      ),
    );
  }
}
