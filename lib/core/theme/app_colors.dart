import 'package:flutter/material.dart';

class AppColors {
  // --- Backgrounds ---
  static const Color background       = Color(0xFF0A0A0A); // Near-black — primary bg
  static const Color surfaceCard      = Color(0xFF141414); // Slightly lifted card bg (Netflix-exact)
  static const Color surfaceElevated  = Color(0xFF1F1F1F); // Modal, sheet, input bg
  static const Color surfaceBorder    = Color(0xFF2A2A2A); // Dividers, borders

  // --- Brand / Accent ---
  static const Color brand            = Color(0xFFE50914); // Netflix red — primary CTA
  static const Color brandDark        = Color(0xFFB20710); // Pressed / darker red
  static const Color brandGlow        = Color(0x33E50914); // Red glow shadow (20% opacity)

  // --- Text ---
  static const Color textPrimary      = Color(0xFFFFFFFF); // Main text
  static const Color textSecondary    = Color(0xFFB3B3B3); // Subtitles, metadata
  static const Color textMuted        = Color(0xFF666666); // Placeholders, disabled
  static const Color textOnBrand      = Color(0xFFFFFFFF); // Text on red buttons

  // --- UI States ---
  static const Color success          = Color(0xFF46D369); // Green — downloaded, saved
  static const Color warning          = Color(0xFFFFA500); // Orange — age rating badge
  static const Color error            = Color(0xFFE50914); // Same red for errors
  static const Color info             = Color(0xFF0080FF); // Blue — info toasts

  // --- Overlays ---
  static const Color overlayDark      = Color(0xCC000000); // 80% black — video overlay
  static const Color overlayGradient  = Color(0x00000000); // Transparent end of gradient
  static const Color shimmerBase      = Color(0xFF1A1A1A);
  static const Color shimmerHighlight = Color(0xFF2D2D2D);

  // --- Rating Colors ---
  static const Color ratingGold       = Color(0xFFFFD700); // Star rating
}
