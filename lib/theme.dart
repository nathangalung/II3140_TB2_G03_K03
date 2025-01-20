import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    primaryColor: const Color(0xFFE9E9E9),
    unselectedWidgetColor: const Color(0xFF003343), // Warna checkbox sebelum dicentang
    checkboxTheme: CheckboxThemeData(
      side: MaterialStateBorderSide.resolveWith(
        (states) => BorderSide(
          color: states.contains(MaterialState.selected)
              ? const Color.fromARGB(255, 163, 205, 182) // Warna saat dicentang
              : const Color(0xFF003343), // Warna sebelum dicentang
        ),
      ),
    ),
    colorScheme: ColorScheme.light(
      primary: const Color.fromARGB(255, 163, 205, 182),
      secondary: const Color(0xFF003343),
      surface: const Color(0xFF131927),
    ),
    textTheme: GoogleFonts.josefinSansTextTheme(
      const TextTheme(
        headlineLarge: TextStyle(color: Color(0xFF131927)),
        bodyLarge: TextStyle(color: Color(0xFF003343)),
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    primaryColor: const Color(0xFF003343),
    unselectedWidgetColor: const Color(0xFFADD0BD), // Warna checkbox sebelum dicentang
    checkboxTheme: CheckboxThemeData(
      side: MaterialStateBorderSide.resolveWith(
        (states) => BorderSide(
          color: states.contains(MaterialState.selected)
              ? const Color(0xFF003343) // Warna saat dicentang
              : const Color(0xFF003343), // Warna sebelum dicentang
        ),
      ),
    ),
    colorScheme: ColorScheme.dark(
      primary: const Color(0xFF003343),
      secondary: const Color(0xFFADD0BD),
      surface: const Color(0xFFFFFFFF),
    ),
    textTheme: GoogleFonts.josefinSansTextTheme(
      const TextTheme(
        headlineLarge: TextStyle(color: Color(0xFFFFFFFF)),
        bodyLarge: TextStyle(color: Color(0xFFADD0BD)),
      ),
    ),
  );
}
