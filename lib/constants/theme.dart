import 'package:flutter/material.dart';

class AppTheme{
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
      scaffoldBackgroundColor: Color(0xFFEAF0F9),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: Colors.black),
        bodyLarge: TextStyle(color: Colors.black),
        bodySmall: TextStyle(color: Colors.black),
      ),
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: Color(0xFFFF4081),
        secondary: Colors.black,
        tertiary: Color(0xFF00B0FF),
        outline: Color(0xFF00344C),
      )
  );

  static ThemeData darkTheme = ThemeData.dark(useMaterial3: false).copyWith(
      scaffoldBackgroundColor: Color(0xFF121212),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
      ),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: Colors.white),
        bodyLarge: TextStyle(color: Colors.white),
        bodySmall: TextStyle(color: Colors.white),
      ),
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: Color(0xFFB80454),
        secondary: Colors.white,
        tertiary: Color(0xFF00B0FF),
        outline: Colors.white,
      )
  );

}