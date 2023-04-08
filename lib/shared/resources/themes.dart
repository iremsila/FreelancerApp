import 'package:flutter/material.dart';

import 'colors.dart';

class AppThemes {
  static ThemeData lightTheme() {
    return ThemeData(
        scaffoldBackgroundColor: AppColors.second,
        errorColor: Colors.red,

        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.transparent,
        ));
  }
}