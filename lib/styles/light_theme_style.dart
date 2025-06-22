import 'package:Cliamizer/res/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../res/setting.dart';

class LightStyles {
  static ThemeData lightTheme(BuildContext context) {
    return ThemeData(
      useMaterial3: true,
      // Colors
      dividerColor: MColors.gray_ce,
      shadowColor: MColors.black,
      scaffoldBackgroundColor: MColors.white,
      primaryColor: MColors.primary_color,
      primaryColorLight: MColors.white,
      primaryColorDark: MColors.primary_color,
      indicatorColor: MColors.second_dark_color,
      hintColor: MColors.gray_ef,
      highlightColor: MColors.mainColor70,
      hoverColor: MColors.primary_color,
      focusColor: MColors.hint_color.withOpacity(0.6),
      disabledColor: Colors.grey,
      canvasColor: Colors.grey[50],
      brightness: Brightness.light,

      colorScheme: ColorScheme.light(
        primary: MColors.primary_color,
        onPrimary: MColors.white,
        secondary: MColors.secondary_text_color,
        onSecondary: MColors.primary_text_color, // Ensure visibility
        error: MColors.loginColor2,
        onError: MColors.white, // Keep error text visible
        background: MColors.white,
        onBackground: MColors.primary_text_color, // Adjust for readability
        surface: MColors.white,
        onSurface: MColors.primary_text_color, // Ensuring contrast
        surfaceTint: MColors.primary_color,
        onPrimaryContainer: MColors.primary_text_color, // Ensure visibility
        onSecondaryContainer: MColors.gray.withOpacity(0.5),
        outline: MColors.second_dark_color,
        secondaryContainer: MColors.gray_9a,
        tertiaryContainer: MColors.white,
        shadow: MColors.black,
      ),

      // Text Theme
      textTheme: TextTheme(
        headlineLarge: GoogleFonts.montserrat(
            fontSize: 25.sp, fontWeight: FontWeight.w700, color: MColors.primary_text_color),
        bodyLarge: GoogleFonts.montserrat(
            fontSize: 19.sp, fontWeight: FontWeight.w700, color: MColors.primary_text_color),
        bodyMedium: GoogleFonts.montserrat(
            fontSize: 15.sp, color: MColors.darkGrey, fontWeight: FontWeight.w500),
        bodySmall: GoogleFonts.montserrat(
            fontSize: 14.sp, color: MColors.primary_text_color),
        labelLarge: GoogleFonts.montserrat(
            fontSize: 21.sp, color: MColors.primary_text_color),
        displayLarge: GoogleFonts.montserrat(
            fontSize: 19.sp, color: MColors.primary_text_color), // Adjusted color
        displayMedium: GoogleFonts.montserrat(
            fontSize: 17.sp, fontWeight: FontWeight.w600, color: MColors.primary_text_color),
        displaySmall: GoogleFonts.montserrat(
            fontSize: 15.sp, color: MColors.primary_text_color),
        headlineMedium: GoogleFonts.montserrat(
            fontSize: 17.sp, color: MColors.primary_text_color),
        headlineSmall: GoogleFonts.montserrat(
            fontSize: 17.sp, color: MColors.primary_text_color),
        titleLarge: GoogleFonts.montserrat(
            fontSize: 17.sp, color: MColors.primary_text_color),
        titleMedium: GoogleFonts.montserrat(
            fontSize: 17.sp, color: MColors.hint_color),
        titleSmall: GoogleFonts.montserrat(
            fontSize: 14.sp, color: MColors.primary_text_color),
        labelSmall: GoogleFonts.montserrat(
            fontSize: 17.sp, color: MColors.text_button_color, fontWeight: FontWeight.w500),
        labelMedium: GoogleFonts.montserrat(
            fontSize: 17.sp, fontWeight: FontWeight.w600, color: MColors.primary_text_color),
      ),

      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: MColors.primary_color,
        titleTextStyle: GoogleFonts.montserrat(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          color: MColors.black,
        ),
        elevation: 0.0,
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: MColors.page_background,
      ),

      buttonTheme: Theme.of(context).buttonTheme.copyWith(
        colorScheme: ColorScheme.light(background: MColors.primary_color),
      ),

      cardTheme: CardTheme(
        color: MColors.white,
      ),

      dialogTheme: DialogTheme(
        backgroundColor: MColors.white,
      ),

      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(3.sp),
          side: BorderSide(
            color: MColors.darkGrey,
          ),
        ),
        fillColor: MaterialStateProperty.all(MColors.darkGrey),
        checkColor: MaterialStateProperty.all(MColors.white),
      ),

      fontFamily: Setting.mobileLanguage.value == Locale("en") ? "PFBagueRoundPro" : "Tajawal",
    );
  }
}
