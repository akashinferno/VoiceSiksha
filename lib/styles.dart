// styles.dart
import 'package:flutter/material.dart';

// Define your purple color palette.
class AppColors {
  static const Color primaryPurple = Color(0xFF9C27B0);
  static const Color secondaryPurple = Color(0xFF7E57C2);
  static const Color lightPurple = Color(0xFFE91E63);
  static const Color darkPurple = Color(0xFF512DA8);
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color grey = Colors.grey;
  static const Color lightGrey = Colors.grey;
}

// Define your text styles.
class AppTextStyles {
  static const TextStyle headline1 = TextStyle(
    fontSize: 96,
    fontWeight: FontWeight.w300,
    letterSpacing: -1.5,
    color: AppColors.black,
  );
  static const TextStyle headline2 = TextStyle(
    fontSize: 60,
    fontWeight: FontWeight.w300,
    letterSpacing: -0.5,
    color: AppColors.black,
  );
  static const TextStyle headline3 = TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.w400,
    color: AppColors.black,
  );
  static const TextStyle headline4 = TextStyle(
    fontSize: 34,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    color: AppColors.black,
  );
  static const TextStyle headline5 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w400,
    color: AppColors.black,
  );
  static const TextStyle headline6 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.15,
    color: AppColors.black,
  );
  static const TextStyle subtitle1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.15,
    color: AppColors.black,
  );
  static const TextStyle subtitle2 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    color: AppColors.black,
  );
  static const TextStyle bodyText1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    color: AppColors.black,
  );
  static const TextStyle bodyText2 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    color: AppColors.black,
  );
  static const TextStyle button = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.25,
    color: AppColors.white,
  );
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    color: AppColors.grey,
  );
  static const TextStyle overline = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w400,
    letterSpacing: 1.5,
    color: AppColors.black,
  );
}
