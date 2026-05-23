import 'package:flutter/material.dart';
import 'package:velvet/core/theme/app_pallete.dart';

class AppTheme {
  //border
  static OutlineInputBorder _border([
    Color borderColor = AppPallete.border,
  ]) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(6),
    borderSide: BorderSide(color: borderColor),
  );

  static final ThemeData lightTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: AppPallete.primary,
    appBarTheme: const AppBarTheme(backgroundColor: AppPallete.transparent),

    //Text Field Theme
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: EdgeInsets.symmetric(horizontal: 16),
      enabledBorder: _border(),
      focusedBorder: _border(AppPallete.accent),
      errorBorder: _border(AppPallete.error),
    ),
  );
}
