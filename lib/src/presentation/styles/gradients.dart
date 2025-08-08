import 'package:flutter/material.dart';

class AppGradients {
  // Hushh-like pink -> violet brand gradient
  static const Color pink = Color(0xFFFF3CAC);
  static const Color violet = Color(0xFF784BA0);

  static const LinearGradient hushh = LinearGradient(
    colors: [pink, violet],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Softer (translucent) variant for backgrounds
  static LinearGradient hushhSoft = LinearGradient(
    colors: [pink.withAlpha(28), violet.withAlpha(28)], // ~11% opacity
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}


