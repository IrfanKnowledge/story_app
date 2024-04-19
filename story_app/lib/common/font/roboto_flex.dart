import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RobotoFlex {
  static final textTheme = TextTheme(
    // height: 64.0 -> 1.122 (1.122 * 57 = 63.384, mendekati angka 64.0)
    displayLarge: GoogleFonts.robotoFlex(
      fontSize: 57.0,
      height: 1.122,
      letterSpacing: -0.25,
    ),
    // height: 52.0 -> 1.155,
    displayMedium: GoogleFonts.robotoFlex(
      fontSize: 45.0,
      height: 1.155,
      letterSpacing: 0.0,
    ),
    // height: 44.0,
    displaySmall: GoogleFonts.robotoFlex(
      fontSize: 36.0,
      height: 1.222,
      letterSpacing: 0.0,
    ),
    // height: 40.0,
    headlineLarge: GoogleFonts.robotoFlex(
      fontSize: 32.0,
      height: 1.25,
      letterSpacing: 0.0,
    ),
    // height: 36,
    headlineMedium: GoogleFonts.robotoFlex(
      fontSize: 28.0,
      height: 1.285,
      letterSpacing: 0.0,
    ),
    // height: 32,
    headlineSmall: GoogleFonts.robotoFlex(
      fontSize: 24.0,
      height: 1.333,
      letterSpacing: 0.0,
    ),
    // height: 28,
    titleLarge: GoogleFonts.robotoFlex(
      fontSize: 22.0,
      height: 1.27,
      letterSpacing: 0.0,
    ),
    // height: 24,
    titleMedium: GoogleFonts.robotoFlex(
      fontSize: 16.0,
      height: 1.5,
      letterSpacing: 0.15,
    ),
    // height: 20.0,
    titleSmall: GoogleFonts.robotoFlex(
      fontSize: 14.0,
      height: 1.43,
      letterSpacing: 0.1,
    ),
    // height: 20.0,
    labelLarge: GoogleFonts.robotoFlex(
      fontSize: 14.0,
      height: 1.43,
      letterSpacing: 0.1,
    ),
    // height: 16.0,
    labelMedium: GoogleFonts.robotoFlex(
      fontSize: 12.0,
      height: 1.33,
      letterSpacing: 0.5,
    ),
    // height: 16.0,
    labelSmall: GoogleFonts.robotoFlex(
      fontSize: 11.0,
      height: 1.45,
      letterSpacing: 0.5,
    ),
    // height: 24.0,
    bodyLarge: GoogleFonts.robotoFlex(
      fontSize: 16.0,
      height: 1.5,
      letterSpacing: 0.5,
    ),
    // height: 20.0,
    bodyMedium: GoogleFonts.robotoFlex(
      fontSize: 14.0,
      height: 1.43,
      letterSpacing: 0.25,
    ),
    // height: 16.0,
    bodySmall: GoogleFonts.robotoFlex(
      fontSize: 12.0,
      height: 1.33,
      letterSpacing: 0.4,
    ),
  );
}
