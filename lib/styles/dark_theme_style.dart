import 'package:Cliamizer/res/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../res/setting.dart';

class DarkStyle {
  static ThemeData darkTheme(BuildContext context) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: MColors.page_dark_background,
      primaryColor: MColors.text2_dark_color,
      dividerColor: MColors.page_dark_background,
      shadowColor: MColors.primary_color.withOpacity(0.5),
      indicatorColor: MColors.white,
      hintColor: MColors.gray_ce,
      highlightColor: MColors.text2_dark_color.withOpacity(0.4),
      focusColor: MColors.text2_dark_color.withOpacity(0.3),
      disabledColor: Colors.grey,
      canvasColor: MColors.second_dark_color,

      colorScheme: ColorScheme.dark(
        primary: MColors.page_dark_background,
        onPrimary: MColors.white,
        secondary: MColors.page_dark_background,
        onSecondary: MColors.loginColor1.withOpacity(0.5),
        error: MColors.page_dark_background,
        onError: MColors.page_dark_background,
        background: MColors.page_dark_background,
        onBackground: MColors.page_dark_background,
        surface: MColors.text_dark_color,
        onSurface: MColors.white,
        surfaceTint: MColors.primary_color,
        onPrimaryContainer: MColors.page_dark_background,
        onSecondaryContainer: MColors.loginColor1,
        outline: MColors.white,
        secondaryContainer: MColors.gray_66,
        tertiaryContainer: MColors.text_dark_color.withOpacity(0.2),
        shadow: MColors.text2_dark_color,
      ),

      // 🔹 Text Theme (No `inherit` Errors)
      textTheme: TextTheme(
        headlineLarge: GoogleFonts.montserrat(
          fontSize: 27.sp,
          fontWeight: FontWeight.w700,
          color: MColors.text_dark_color,
        ),
        bodyLarge: GoogleFonts.montserrat(
          fontSize: 19.sp,
          fontWeight: FontWeight.w700,
          color: MColors.text_dark_color,
        ),
        bodyMedium: GoogleFonts.montserrat(
          fontSize: 15.sp,
          fontWeight: FontWeight.w500,
          color: MColors.light_text_color,
        ),
        bodySmall: GoogleFonts.montserrat(
          fontSize: 14.sp,
          color: MColors.text_dark_color,
        ),
        labelLarge: GoogleFonts.montserrat(
          fontSize: 21.sp,
          color: MColors.text_dark_color,
        ),
        displayLarge: GoogleFonts.montserrat(fontSize: 14.sp),
        displayMedium: GoogleFonts.montserrat(
          fontSize: 17.sp,
          fontWeight: FontWeight.w600,
          color: MColors.white,
        ),
        displaySmall: GoogleFonts.montserrat(
          fontSize: 15.sp,
          color: MColors.light_text_color,
        ),
        headlineMedium: GoogleFonts.montserrat(fontSize: 17.sp),
        headlineSmall: GoogleFonts.montserrat(fontSize: 17.sp),
        titleLarge: GoogleFonts.montserrat(fontSize: 17.sp),
        titleMedium: GoogleFonts.montserrat(
          fontSize: 14.sp,
          color: MColors.hint_color,
        ),
        titleSmall: GoogleFonts.montserrat(
          fontSize: 14.sp,
          color: MColors.primary_light_color,
        ),
        labelSmall: GoogleFonts.montserrat(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          color: MColors.text_button_color,
        ),
        labelMedium: GoogleFonts.montserrat(
          fontSize: 17.sp,
          fontWeight: FontWeight.w600,
          color: MColors.text_dark_color,
        ),
      ),

      // 🔹 App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: MColors.second_dark_color,
        titleTextStyle: GoogleFonts.montserrat(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: MColors.white,
        ),
        elevation: 0.0,
      ),

      // 🔹 Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: MColors.page_dark_background,
        selectedItemColor: MColors.white,
        unselectedItemColor: MColors.gray_66,
      ),

      // 🔹 Button Theme
      buttonTheme: ButtonThemeData(
        colorScheme: ColorScheme.dark(background: MColors.second_dark_color),
      ),

      // 🔹 Card Theme
      cardTheme: CardTheme(
        color: MColors.lightBlack,
      ),

      // 🔹 Dialog Theme
      dialogTheme: DialogTheme(
        backgroundColor: MColors.lightBlack,
      ),

      // 🔹 Checkbox Theme
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

      // 🔹 Font Family
      fontFamily: Setting.mobileLanguage.value == Locale("en") ? "PFBagueRoundPro" : "Tajawal",
    );
  }
}
