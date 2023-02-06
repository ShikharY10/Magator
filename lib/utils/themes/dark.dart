import 'package:flutter/material.dart';
import 'package:magator/utils/themes/colors.dart';

ThemeData dartThemeData(BuildContext context) {
  return ThemeData.dark().copyWith(
    useMaterial3: true,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: secondaryColor,
    iconTheme: const IconThemeData(color: primaryColor),
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      error: Colors.red,
    ),
  );
}