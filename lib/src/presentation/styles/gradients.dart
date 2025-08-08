import 'package:flutter/material.dart';

class AppGradients {
  // Modern financial app colors
  static const Color primaryOrange = Color(0xFFFF6B35);
  static const Color primaryTeal = Color(0xFF20B2AA);
  static const Color primaryBlue = Color(0xFF4A90E2);
  static const Color primaryGreen = Color(0xFF7ED321);
  static const Color primaryViolet = Color(0xFF9B59B6);
  static const Color lightBackground = Color(0xFFF8F9FA);
  static const Color cardBackground = Color(0xFFFFFFFF);

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
}


