import 'package:flutter/material.dart';

class AppGradients {
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [startColor,midColor, endColor],
     stops: [0.0, 0.5, 1.0],
  );

  // Optional utility for quick access to individual colors
  static const Color startColor = Color(0xFF0F2027); // Deep Charcoal
  static const Color midColor = Color(0xFF203A43); // Dark Teal
  static const Color endColor = Color(0xFF2C5364); // Ocean Blue
}
