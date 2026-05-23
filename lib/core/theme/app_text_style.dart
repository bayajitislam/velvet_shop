import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velvet/core/theme/app_pallete.dart';

class AppTextStyle {
  // ── Display ─────────────────────────────────────────────

  // Size 32 Weight 700 Poppins — hero headings
  static TextStyle s32w7({
    Color? color,
    double fontSize = 32.0,
    FontWeight fontWeight = FontWeight.w700,
  }) {
    return GoogleFonts.poppins(
      color: color ?? AppPallete.bodyText,
      fontSize: fontSize,
      fontWeight: fontWeight,
    );
  }

  // Size 24 Weight 700 Poppins — screen titles
  static TextStyle s24w7({
    Color? color,
    double fontSize = 24.0,
    FontWeight fontWeight = FontWeight.w700,
  }) {
    return GoogleFonts.poppins(
      color: color ?? AppPallete.bodyText,
      fontSize: fontSize,
      fontWeight: fontWeight,
    );
  }

  // Size 20 Weight 600 Poppins — section headings
  static TextStyle s20w6({
    Color? color,
    double fontSize = 20.0,
    FontWeight fontWeight = FontWeight.w600,
  }) {
    return GoogleFonts.poppins(
      color: color ?? AppPallete.bodyText,
      fontSize: fontSize,
      fontWeight: fontWeight,
    );
  }

  // ── Body ────────────────────────────────────────────────

  // Size 16 Weight 600 Poppins — product name, card title
  static TextStyle s16w6({
    Color? color,
    double fontSize = 16.0,
    FontWeight fontWeight = FontWeight.w600,
  }) {
    return GoogleFonts.poppins(
      color: color ?? AppPallete.bodyText,
      fontSize: fontSize,
      fontWeight: fontWeight,
    );
  }

  // Size 16 Weight 400 Poppins — body text
  static TextStyle s16w4({
    Color? color,
    double fontSize = 16.0,
    FontWeight fontWeight = FontWeight.w400,
  }) {
    return GoogleFonts.poppins(
      color: color ?? AppPallete.subTextColor,
      fontSize: fontSize,
      fontWeight: fontWeight,
    );
  }

  // Size 14 Weight 600 Poppins — price, badge label
  static TextStyle s14w6({
    Color? color,
    double fontSize = 14.0,
    FontWeight fontWeight = FontWeight.w600,
  }) {
    return GoogleFonts.poppins(
      color: color ?? AppPallete.primary,
      fontSize: fontSize,
      fontWeight: fontWeight,
    );
  }

  // Size 14 Weight 400 Poppins — description, sub-label
  static TextStyle s14w4({
    Color? color,
    double fontSize = 14.0,
    FontWeight fontWeight = FontWeight.w400,
  }) {
    return GoogleFonts.poppins(
      color: color ?? AppPallete.extraAsh,
      fontSize: fontSize,
      fontWeight: fontWeight,
    );
  }

  // ── Caption ─────────────────────────────────────────────

  // Size 12 Weight 500 Poppins — tag, chip text
  static TextStyle s12w5({
    Color? color,
    double fontSize = 12.0,
    FontWeight fontWeight = FontWeight.w500,
  }) {
    return GoogleFonts.poppins(
      color: color ?? AppPallete.primary,
      fontSize: fontSize,
      fontWeight: fontWeight,
    );
  }

  // Size 12 Weight 400 Poppins — hint, timestamp
  static TextStyle s12w4({
    Color? color,
    double fontSize = 12.0,
    FontWeight fontWeight = FontWeight.w400,
  }) {
    return GoogleFonts.poppins(
      color: color ?? AppPallete.extraAsh,
      fontSize: fontSize,
      fontWeight: fontWeight,
    );
  }

  // Size 10 Weight 400 Poppins — fine print, nav label
  static TextStyle s10w4({
    Color? color,
    double fontSize = 10.0,
    FontWeight fontWeight = FontWeight.w400,
  }) {
    return GoogleFonts.poppins(
      color: color ?? AppPallete.extraAsh,
      fontSize: fontSize,
      fontWeight: fontWeight,
    );
  }

  // ── Special ─────────────────────────────────────────────

  // Strikethrough — original price
  static TextStyle strikethrough({
    Color? color,
    double fontSize = 14.0,
  }) {
    return GoogleFonts.poppins(
      color: color ?? AppPallete.extraAsh,
      fontSize: fontSize,
      fontWeight: FontWeight.w400,
      decoration: TextDecoration.lineThrough,
      decorationColor: color ?? AppPallete.extraAsh,
    );
  }

  // Button text
  static TextStyle button({
    Color? color,
    double fontSize = 15.0,
  }) {
    return GoogleFonts.poppins(
      color: color ?? AppPallete.white,
      fontSize: fontSize,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.3,
    );
  }
}