import 'package:flutter/material.dart';

class AppGradients {
  // Modern financial app colors - Light Mode
  static const Color primaryOrange = Color(0xFFFF6B35);
  static const Color primaryTeal = Color(0xFF20B2AA);
  static const Color primaryBlue = Color(0xFF4A90E2);
  static const Color primaryGreen = Color(0xFF7ED321);
  static const Color primaryViolet = Color(0xFF9B59B6);
  static const Color lightBackground = Color(0xFFF8F9FA);
  static const Color cardBackground = Color(0xFFFFFFFF);

  // Lighter accents for surfaces and highlights - Light Mode
  static const Color lightOrange = Color(0xFFFFA07A);
  static const Color lightTeal = Color(0xFF66D1C7);
  static const Color lightBlue = Color(0xFF8BBEF1);
  static const Color lightGreen = Color(0xFFA8E6A3);
  static const Color lightViolet = Color(0xFFC39BD3);

  // Dark Mode Colors
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkCardBackground = Color(0xFF1E1E1E);
  static const Color darkSurface = Color(0xFF2D2D2D);
  static const Color darkText = Color(0xFFE0E0E0);
  static const Color darkTextSecondary = Color(0xFFB0B0B0);

  // Darker versions of primary colors for dark mode
  static const Color darkOrange = Color(0xFFE55A2B);
  static const Color darkTeal = Color(0xFF1A8A82);
  static const Color darkBlue = Color(0xFF3A7BC8);
  static const Color darkGreen = Color(0xFF6BB91A);
  static const Color darkViolet = Color(0xFF7B4A96);

  static const LinearGradient primary = LinearGradient(
    colors: [primaryOrange, primaryTeal],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondary = LinearGradient(
    colors: [primaryBlue, primaryViolet],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient success = LinearGradient(
    colors: [primaryGreen, primaryTeal],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Dark mode gradients
  static const LinearGradient darkPrimary = LinearGradient(
    colors: [darkOrange, darkTeal],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkSecondary = LinearGradient(
    colors: [darkBlue, darkViolet],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkSuccess = LinearGradient(
    colors: [darkGreen, darkTeal],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

// Helper to slide a gradient horizontally. Used for animated buttons.
class SlidingGradientTransform extends GradientTransform {
  final double slidePercent; // 0..1 cycles the gradient across its bounds
  const SlidingGradientTransform(this.slidePercent);

  @override
  Matrix4 transform(Rect bounds, {TextDirection? textDirection}) {
    final double dx = bounds.width * slidePercent;
    return Matrix4.identity()..translate(dx);
  }
}


