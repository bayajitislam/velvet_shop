import 'package:flutter/material.dart';

class AppPallete {
  // ── Core Brand ──────────────────────────────────────────
  static const Color primary       = Color(0xFFE91E63); // pink accent / CTA
  static const Color primaryLight  = Color(0xFFF4A7B9); // soft pink
  static const Color primaryDark   = Color(0xFFAD1457); // deep rose
  static const Color background    = Color(0xFFFCE4EC); // light pink bg

  // ── Surface & Scaffold ──────────────────────────────────
  static const Color scaffold      = Color(0xFFFFF8FA); // near-white with pink tint
  static const Color surface       = Color(0xFFFFFFFF); // card white
  static const Color secondary     = Color(0xFFFCE4EC); // light pink surface

  // ── Text ────────────────────────────────────────────────
  static const Color bodyText      = Color(0xFF212121); // near black
  static const Color subTextColor  = Color(0xFF757575); // medium grey
  static const Color extraAsh      = Color(0xFF9E9E9E); // light grey hint
  static const Color indigoNavy    = Color(0xFF1A1A2E); // kept for headings

  // ── Semantic ────────────────────────────────────────────
  static const Color accent        = Color(0xFFE91E63); // same as primary
  static const Color error         = Color(0xFFEA2A2A);
  static const Color danger        = Color(0xFFE30000);
  static const Color success       = Color(0xFF2E7D32);
  static const Color star          = Color(0xFFFFC107); // rating star

  // ── Utility ─────────────────────────────────────────────
  static const Color border        = Color(0xFFF8BBD0); // pink-tinted border
  static const Color stroke        = Color(0xFFFCE4EC); // divider
  static const Color dropShadow    = Color(0x26E91E63); // pink shadow
  static const Color black         = Color(0xFF212121);
  static const Color black75       = Color(0xBF000000);
  static const Color white         = Color(0xFFFFFFFF);
  static const Color white30       = Color(0x4DFFFFFF);
  static const Color lighBlueGray  = Color(0xFFBDBDBD);
  static const Color accent10      = Color(0xFFFCE4EC); // was light blue → now light pink
  static const Color accentFB      = Color(0xFFFFF0F5); // was light blue → now blush
  static const Color whiteD5       = Color(0xFFFFEDD5); // warm cream (kept)
  static const Color transparent   = Colors.transparent;
}