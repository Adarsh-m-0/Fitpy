import 'package:flutter/material.dart';

/// App theme configuration with consistent styles across all screens
class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  // Light theme definition
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: _lightColorScheme,
      
      // Text themes
      textTheme: _buildTextTheme(),
      
      // Card themes
      cardTheme: _cardTheme,
      
      // Button themes
      filledButtonTheme: _filledButtonTheme,
      outlinedButtonTheme: _outlinedButtonTheme,
      textButtonTheme: _textButtonTheme,
      
      // Icon themes
      iconTheme: _buildLightIconTheme(),
      
      // Divider theme
      dividerTheme: _lightDividerTheme,
      
      // AppBar theme
      appBarTheme: _appBarTheme,
    );
  }
  
  // Dark theme definition
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: _darkColorScheme,
      
      // Text themes
      textTheme: _buildTextTheme(),
      
      // Card themes
      cardTheme: _cardTheme,
      
      // Button themes
      filledButtonTheme: _filledButtonTheme,
      outlinedButtonTheme: _outlinedButtonTheme,
      textButtonTheme: _textButtonTheme,
      
      // Icon themes
      iconTheme: _buildDarkIconTheme(),
      
      // Divider theme
      dividerTheme: _darkDividerTheme,
      
      // AppBar theme
      appBarTheme: _darkAppBarTheme,
    );
  }
  
  // Light color scheme
  static const ColorScheme _lightColorScheme = ColorScheme.light(
    primary: Color(0xFF1565C0),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFD6E4FF),
    onPrimaryContainer: Color(0xFF001E42),
    secondary: Color(0xFFE65100),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFFFDDC1),
    onSecondaryContainer: Color(0xFF331200),
    tertiary: Color(0xFF4CAF50),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFB8F5B9),
    onTertiaryContainer: Color(0xFF002204),
    error: Color(0xFFBA1A1A),
    errorContainer: Color(0xFFFFDAD6),
    onError: Color(0xFFFFFFFF),
    onErrorContainer: Color(0xFF410002),
    surface: Color(0xFFF8F9FF),
    onSurface: Color(0xFF1B1B1F),
    surfaceContainerHighest: Color(0xFFE1E2EC),
    onSurfaceVariant: Color(0xFF44474F),
    outline: Color(0xFF74777F),
    outlineVariant: Color(0xFFC4C6D0),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    inverseSurface: Color(0xFF303034),
    inversePrimary: Color(0xFFADC7FF),
    surfaceContainerHigh: Color(0xFFEAECF6),
    surfaceContainerLow: Color(0xFFF0F2FC),
    surfaceContainerLowest: Color(0xFFF8F9FF),
  );
  
  // Dark color scheme
  static const ColorScheme _darkColorScheme = ColorScheme.dark(
    primary: Color(0xFF8BB5FF),
    onPrimary: Color(0xFF00316F),
    primaryContainer: Color(0xFF004699),
    onPrimaryContainer: Color(0xFFD6E4FF),
    secondary: Color(0xFFFFB77C),
    onSecondary: Color(0xFF552100),
    secondaryContainer: Color(0xFF783100),
    onSecondaryContainer: Color(0xFFFFDBC7),
    tertiary: Color(0xFF9BDC9E),
    onTertiary: Color(0xFF003A0A),
    tertiaryContainer: Color(0xFF195420),
    onTertiaryContainer: Color(0xFFB5F7B8),
    error: Color(0xFFFFB4AB),
    errorContainer: Color(0xFF93000A),
    onError: Color(0xFF690005),
    onErrorContainer: Color(0xFFFFDAD6),
    surface: Color(0xFF1B1B1F),
    onSurface: Color(0xFFE3E2E6),
    surfaceContainerHighest: Color(0xFF44474F),
    onSurfaceVariant: Color(0xFFC4C6D0),
    outline: Color(0xFF8E9099),
    outlineVariant: Color(0xFF44474F),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    inverseSurface: Color(0xFFE3E2E6),
    inversePrimary: Color(0xFF0058CA),
    surfaceContainerHigh: Color(0xFF2A2A2E),
    surfaceContainerLow: Color(0xFF1F1F23),
    surfaceContainerLowest: Color(0xFF1B1B1F),
  );
  
  // Build consistent text theme
  static TextTheme _buildTextTheme() {
    return const TextTheme(
      displayLarge: TextStyle(
        fontSize: 57,
        fontWeight: FontWeight.w400,
      ),
      displayMedium: TextStyle(
        fontSize: 45,
        fontWeight: FontWeight.w400,
      ),
      displaySmall: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.w400,
      ),
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w700,
      ),
      headlineMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w600,
      ),
      headlineSmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      labelSmall: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w500,
      ),
    );
  }
  
  // Card theme
  static final CardTheme _cardTheme = CardTheme(
    elevation: 1,
    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
  );
  
  // Filled button theme
  static final FilledButtonThemeData _filledButtonTheme = FilledButtonThemeData(
    style: FilledButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );
  
  // Outlined button theme
  static final OutlinedButtonThemeData _outlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );
  
  // Text button theme
  static final TextButtonThemeData _textButtonTheme = TextButtonThemeData(
    style: TextButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    ),
  );
  
  // Icon themes
  static IconThemeData _buildLightIconTheme() {
    return const IconThemeData(
      size: 24,
      color: Color(0xFF1B1B1F),
    );
  }
  
  static IconThemeData _buildDarkIconTheme() {
    return const IconThemeData(
      size: 24,
      color: Color(0xFFE3E2E6),
    );
  }
  
  // Light divider theme
  static const DividerThemeData _lightDividerTheme = DividerThemeData(
    space: 1,
    thickness: 1,
    color: Color(0xFFC4C6D0),
  );
  
  // Dark divider theme
  static const DividerThemeData _darkDividerTheme = DividerThemeData(
    space: 1,
    thickness: 1,
    color: Color(0xFF44474F),
  );
  
  // AppBar theme
  static final AppBarTheme _appBarTheme = AppBarTheme(
    centerTitle: false,
    elevation: 0,
    backgroundColor: _lightColorScheme.surface,
    foregroundColor: _lightColorScheme.onSurface,
    titleTextStyle: _buildTextTheme().titleLarge,
    iconTheme: IconThemeData(
      color: _lightColorScheme.onSurface,
      size: 24,
    ),
  );
  
  // Dark AppBar theme
  static final AppBarTheme _darkAppBarTheme = AppBarTheme(
    centerTitle: false,
    elevation: 0,
    backgroundColor: _darkColorScheme.surface,
    foregroundColor: _darkColorScheme.onSurface,
    titleTextStyle: _buildTextTheme().titleLarge,
    iconTheme: IconThemeData(
      color: _darkColorScheme.onSurface,
      size: 24,
    ),
  );
  
  // Common spacing values
  static const double smallSpacing = 4.0;
  static const double mediumSpacing = 8.0;
  static const double largeSpacing = 16.0;
  static const double extraLargeSpacing = 24.0;
  
  // Common padding values
  static const EdgeInsets smallPadding = EdgeInsets.all(8.0);
  static const EdgeInsets mediumPadding = EdgeInsets.all(16.0);
  static const EdgeInsets largePadding = EdgeInsets.all(24.0);
  
  // Card padding
  static const EdgeInsets cardPadding = EdgeInsets.all(16.0);
  
  // Helper methods for responsive sizing
  static double getResponsiveSize({
    required double small,
    required double regular,
    required BuildContext context,
  }) {
    final width = MediaQuery.of(context).size.width;
    return width < 360 ? small : regular;
  }
  
  // Common border radius values
  static final BorderRadius smallBorderRadius = BorderRadius.circular(8.0);
  static final BorderRadius mediumBorderRadius = BorderRadius.circular(12.0);
  static final BorderRadius largeBorderRadius = BorderRadius.circular(16.0);
} 