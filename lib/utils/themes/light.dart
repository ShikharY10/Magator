import 'package:flutter/material.dart';
import 'package:magator/utils/themes/colors.dart';

ThemeData lightThemeData(BuildContext context) {
  return ThemeData.light().copyWith(
    useMaterial3: true,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: Colors.white,
    iconTheme: const IconThemeData(color: Colors.black),
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: Colors.white,
      error: Colors.red,
    ),
  );
}