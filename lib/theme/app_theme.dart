import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF007D88);
  static const Color accentColor = Color(0xFFFF5A5A);
  static const Color cancelButtonColor = Color(0xFFADB3BC);
  static const Color textColor = Color(0xFF111111);
  static const Color cardTextColor = Color(0xFF50555C);
  static const Color buttonTextColor = Color(0xFFF9FAFA);
  static const Color whiteColor = Color(0xFFFFFFFF);

  static TextTheme textTheme = TextTheme(
    bodyLarge: GoogleFonts.manrope(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: textColor,
    ),
  );

  static ButtonThemeData buttonTheme = ButtonThemeData(
    buttonColor: primaryColor,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    padding: const EdgeInsets.symmetric(vertical: 12),
  );

  static ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: primaryColor,
    foregroundColor: buttonTextColor,
    minimumSize: const Size(double.infinity, 40),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    textStyle: GoogleFonts.manrope(fontWeight: FontWeight.w500, fontSize: 16),
  );

  static ButtonStyle cancelButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: cancelButtonColor,
    foregroundColor: textColor,
    minimumSize: const Size(double.infinity, 40),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    textStyle: GoogleFonts.manrope(fontWeight: FontWeight.w500, fontSize: 16),
  );

  static ThemeData get themeData {
    return ThemeData(
      useMaterial3: true,
      primaryColor: primaryColor,
      textTheme: textTheme,
      buttonTheme: buttonTheme,
      scaffoldBackgroundColor: whiteColor,
      appBarTheme: AppBarTheme(
        backgroundColor: whiteColor,
        surfaceTintColor: Colors.transparent,
      ),
    );
  }
}
