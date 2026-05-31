import 'package:flutter/material.dart';

/// Bedrock global color palette — dark retro-futuristic aesthetic.
class AppColors {
  AppColors._();

  // ── Backgrounds ──────────────────────────────────────────────
  static const Color scaffoldBg = Color(0xFF121212);
  static const Color cardBg = Color(0xFF1E1E1E);
  static const Color cardBorder = Color(0xFF2A2A2A);
  static const Color inputBg = Color(0xFF252525);
  static const Color navBarBg = Color(0xFF141414);

  // ── Dot grid overlay ────────────────────────────────────────
  static const Color dotGrid = Color(0xFF1C1C1C);

  // ── Primary accent ──────────────────────────────────────────
  static const Color primaryGreen = Color(0xFF4ADE80);
  static const Color primaryGreenDark = Color(0xFF22C55E);
  static const Color primaryGreenBg = Color(0xFF16A34A);

  // ── Text ─────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF9CA3AF);
  static const Color textMuted = Color(0xFF6B7280);
  static const Color textDisabled = Color(0xFF4B5563);

  // ── Category tags ────────────────────────────────────────────
  static const Color tagWork = Color(0xFF3B82F6);
  static const Color tagUrgent = Color(0xFFEF4444);
  static const Color tagCreative = Color(0xFFD4A574);

  // ── Priority ─────────────────────────────────────────────────
  static const Color priorityHigh = Color(0xFFEF4444);
  static const Color priorityRoutine = Color(0xFF6B7280);

  // ── Color seed palette (Settings) ───────────────────────────
  static const List<Color> colorSeeds = [
    Color(0xFF4ADE80), // Green (default)
    Color(0xFF93C5FD), // Lavender
    Color(0xFFD4A574), // Rose
    Color(0xFFA78BFA), // Purple
    Color(0xFFEC4899), // Pink
    Color(0xFF06B6D4), // Teal
    Color(0xFFFBBF24), // Amber
  ];
}
