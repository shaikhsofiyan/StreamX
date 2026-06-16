import 'package:flutter/material.dart';

class AppSpacing {
  static const double xs   = 4.0;
  static const double sm   = 8.0;
  static const double md   = 16.0;
  static const double lg   = 24.0;
  static const double xl   = 32.0;
  static const double xxl  = 48.0;

  // Page horizontal padding
  static const double pagePadding = 16.0;
}

class AppRadius {
  static const double sm   = 4.0;
  static const double md   = 8.0;
  static const double lg   = 12.0;
  static const double xl   = 16.0;
  static const double pill = 100.0; // Fully rounded buttons/badges
}

class AppEffects {
  // Red glow for featured content / active elements
  static List<BoxShadow> brandGlow = [
    BoxShadow(
      color: Color(0x33E50914), // brandGlow from AppColors
      blurRadius: 24,
      spreadRadius: 4,
    ),
  ];

  // Card shadow
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Color(0x66000000),
      blurRadius: 12,
      offset: Offset(0, 4),
    ),
  ];
}
