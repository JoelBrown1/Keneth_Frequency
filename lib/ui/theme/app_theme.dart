import 'package:flutter/material.dart';

/// Dark measurement-tool aesthetic for Keneth Frequency.
///
/// Palette:
///   background  #0D0D0D — near-black, keeps focus on readings
///   surface     #1A1A1A — card / sheet surfaces
///   primary     #4DD0E1 — cyan — active controls and highlights
///   secondary   #FFC107 — amber — warnings and caution indicators
///   error       #E53935 — red — clip warnings and validation errors
///   onSurface   #E0E0E0 — light grey body text
///   mono        RobotoMono — measurement value rows
class AppTheme {
  AppTheme._();

  // ── Colour tokens ──────────────────────────────────────────────────────────

  static const Color background = Color(0xFF0D0D0D);
  static const Color surface = Color(0xFF1A1A1A);
  static const Color surfaceVariant = Color(0xFF242424);
  static const Color primary = Color(0xFF4DD0E1);
  static const Color onPrimary = Color(0xFF003740);
  static const Color secondary = Color(0xFFFFC107);
  static const Color onSecondary = Color(0xFF3F2C00);
  static const Color error = Color(0xFFE53935);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color onSurface = Color(0xFFE0E0E0);
  static const Color onSurfaceDim = Color(0xFF9E9E9E);

  // Level meter colour stops (green → yellow → red).
  static const Color levelGreen = Color(0xFF66BB6A);
  static const Color levelYellow = Color(0xFFFFEE58);
  static const Color levelRed = Color(0xFFE53935);

  // ── TextStyles ─────────────────────────────────────────────────────────────

  /// Large, monospaced — resonant frequency display.
  static const TextStyle measurementLarge = TextStyle(
    fontFamily: 'RobotoMono',
    fontSize: 36,
    fontWeight: FontWeight.w600,
    color: primary,
    letterSpacing: 1,
  );

  /// Medium monospaced — secondary measurement values.
  static const TextStyle measurementMedium = TextStyle(
    fontFamily: 'RobotoMono',
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: onSurface,
  );

  /// Small monospaced — table value cells.
  static const TextStyle measurementSmall = TextStyle(
    fontFamily: 'RobotoMono',
    fontSize: 14,
    color: onSurface,
  );

  /// Warning / caution label.
  static const TextStyle warningText = TextStyle(
    fontSize: 13,
    color: secondary,
    fontWeight: FontWeight.w500,
  );

  /// Error / clip label.
  static const TextStyle errorText = TextStyle(
    fontSize: 13,
    color: error,
    fontWeight: FontWeight.w600,
  );

  // ── ThemeData ──────────────────────────────────────────────────────────────

  static ThemeData get dark {
    const scheme = ColorScheme(
      brightness: Brightness.dark,
      primary: primary,
      onPrimary: onPrimary,
      secondary: secondary,
      onSecondary: onSecondary,
      error: error,
      onError: onError,
      surface: surface,
      onSurface: onSurface,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: background,
      cardColor: surface,
      dividerColor: surfaceVariant,
      appBarTheme: const AppBarTheme(
        backgroundColor: surface,
        foregroundColor: onSurface,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: onSurface,
          letterSpacing: 0.5,
        ),
      ),
      cardTheme: const CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          side: BorderSide(color: surfaceVariant),
        ),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: onPrimary,
          minimumSize: const Size(120, 44),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(6))),
          textStyle: const TextStyle(
              fontSize: 15, fontWeight: FontWeight.w600, letterSpacing: 0.5),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          side: const BorderSide(color: primary),
          minimumSize: const Size(120, 44),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(6))),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: surfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(6)),
          borderSide: BorderSide(color: surfaceVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(6)),
          borderSide: BorderSide(color: surfaceVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(6)),
          borderSide: BorderSide(color: primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(6)),
          borderSide: BorderSide(color: error),
        ),
        labelStyle: TextStyle(color: onSurfaceDim),
        hintStyle: TextStyle(color: onSurfaceDim),
      ),
      listTileTheme: const ListTileThemeData(
        tileColor: surface,
        textColor: onSurface,
        iconColor: onSurfaceDim,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: primary,
        linearTrackColor: surfaceVariant,
      ),
      chipTheme: const ChipThemeData(
        backgroundColor: surfaceVariant,
        labelStyle: TextStyle(color: onSurface, fontSize: 13),
        side: BorderSide.none,
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
            fontSize: 24, fontWeight: FontWeight.w600, color: onSurface),
        titleMedium: TextStyle(
            fontSize: 16, fontWeight: FontWeight.w500, color: onSurface),
        bodyMedium: TextStyle(fontSize: 14, color: onSurface),
        bodySmall: TextStyle(fontSize: 12, color: onSurfaceDim),
        labelMedium: TextStyle(fontSize: 13, color: onSurfaceDim),
      ),
    );
  }
}
