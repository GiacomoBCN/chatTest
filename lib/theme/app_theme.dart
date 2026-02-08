import 'package:flutter/material.dart';

class AppTheme {
  // Primary Colors - Commercial Bank Qatar
  static const Color primaryBurgundy = Color(0xFF8B1538);
  static const Color primaryBurgundyLight = Color(0xFFA91D4D);
  static const Color primaryBurgundyDark = Color(0xFF6B0F2A);

  // Status Colors
  static const Color success = Color(0xFF28a745);
  static const Color warning = Color(0xFFffc107);
  static const Color danger = Color(0xFFdc3545);
  static const Color info = Color(0xFF0d6efd);

  // Confidence Colors
  static const Color confidenceHigh = Color(0xFF28a745);
  static const Color confidenceMedium = Color(0xFFffc107);
  static const Color confidenceLow = Color(0xFFdc3545);

  // Confidence Background Colors (softer)
  static const Color confidenceHighBg = Color(0xFFd1e7dd);
  static const Color confidenceMediumBg = Color(0xFFfff3cd);
  static const Color confidenceLowBg = Color(0xFFf8d7da);

  // Tier Badge Colors (pastel style like HTML)
  static const Color tier1Bg = Color(0xFFd1e7dd);
  static const Color tier1Text = Color(0xFF0f5132);
  static const Color tier2Bg = Color(0xFFcfe2ff);
  static const Color tier2Text = Color(0xFF084298);
  static const Color tier3Bg = Color(0xFFf8d7da);
  static const Color tier3Text = Color(0xFF721c24);

  // UI Colors
  static const Color backgroundLight = Color(0xFFF8F9FA);
  static const Color cardBackground = Colors.white;
  static const Color sourceBackground = Color(0xFFE7F3FF);
  static const Color infoBannerBg = Color(0xFFE7F3FF);
  static const Color infoBannerBorder = Color(0xFF084298);
  static const Color checkpointBackground = Color(0xFFFFF3CD);
  static const Color handoffGradientStart = Color(0xFFE7F3FF);
  static const Color handoffGradientEnd = Color(0xFFCFE2FF);

  // Text Colors (WCAG AA compliant)
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF595959); // Improved contrast ratio
  static const Color textLight = Colors.white;
  static const Color infoText = Color(0xFF084298);

  // Styling Constants
  static const double borderRadiusLarge = 20.0;
  static const double borderRadiusMedium = 16.0;
  static const double borderRadiusSmall = 8.0;
  static const double borderRadiusPill = 20.0;
  static const double paddingLarge = 25.0;
  static const double paddingMedium = 16.0;
  static const double paddingSmall = 12.0;
  static const double paddingXSmall = 8.0;

  // Font Sizes (WCAG compliant - minimum 12px)
  static const double fontSizeTitle = 18.0;
  static const double fontSizeBody = 14.0;
  static const double fontSizeSmall = 13.0;
  static const double fontSizeXSmall = 12.0;
  static const double fontSizeTiny = 12.0; // Increased from 11 for accessibility

  // Animation Durations
  static const Duration animationFast = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 800);
  static const Duration streamingDelay = Duration(milliseconds: 800);

  // Shadows
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> get containerShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.3),
      blurRadius: 60,
      offset: const Offset(0, 20),
    ),
  ];

  // Gradients
  static LinearGradient get headerGradient => const LinearGradient(
    colors: [primaryBurgundy, primaryBurgundyLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient get backgroundGradient => const LinearGradient(
    colors: [primaryBurgundy, primaryBurgundyLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryBurgundy,
      primary: primaryBurgundy,
      secondary: primaryBurgundyLight,
    ),
    scaffoldBackgroundColor: backgroundLight,
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryBurgundy,
      foregroundColor: textLight,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryBurgundy,
        foregroundColor: textLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusSmall),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryBurgundy,
        side: const BorderSide(color: primaryBurgundy),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusSmall),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: cardBackground,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: const BorderSide(color: Color(0xFFdee2e6)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: const BorderSide(color: Color(0xFFdee2e6)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: const BorderSide(color: primaryBurgundy),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: paddingMedium,
        vertical: paddingSmall,
      ),
    ),
  );
}
