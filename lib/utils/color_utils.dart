import 'package:flutter/material.dart';

class ColorUtils {
  /// Lightens a color by [percent] amount (0.0 to 1.0)
  static Color lightenColor(Color color, double percent) {
    assert(percent >= 0.0 && percent <= 1.0);
    
    final hslColor = HSLColor.fromColor(color);
    final lightness = (hslColor.lightness + percent).clamp(0.0, 1.0);
    
    return hslColor.withLightness(lightness).toColor();
  }
  
  /// Darkens a color by [percent] amount (0.0 to 1.0)
  static Color darkenColor(Color color, double percent) {
    assert(percent >= 0.0 && percent <= 1.0);
    
    final hslColor = HSLColor.fromColor(color);
    final lightness = (hslColor.lightness - percent).clamp(0.0, 1.0);
    
    return hslColor.withLightness(lightness).toColor();
  }
  
  /// Increases color saturation by [percent] amount (0.0 to 1.0)
  static Color saturateColor(Color color, double percent) {
    assert(percent >= 0.0 && percent <= 1.0);
    
    final hslColor = HSLColor.fromColor(color);
    final saturation = (hslColor.saturation + percent).clamp(0.0, 1.0);
    
    return hslColor.withSaturation(saturation).toColor();
  }
  
  /// Creates a gradient list of colors between [start] and [end]
  static List<Color> createGradient(Color start, Color end, int steps) {
    final result = <Color>[];
    
    for (int i = 0; i <= steps; i++) {
      final t = i / steps;
      result.add(Color.lerp(start, end, t)!);
    }
    
    return result;
  }
  
  /// Calculates if a color is dark (to determine text color)
  static bool isDarkColor(Color color) {
    // Calculate the perceived brightness using the W3C formula
    final luminance = color.computeLuminance();
    return luminance < 0.5;
  }
  
  /// Returns either black or white depending on the background color
  static Color getContrastingTextColor(Color backgroundColor) {
    return isDarkColor(backgroundColor) ? Colors.white : Colors.black;
  }
} 