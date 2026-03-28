import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shipyard_planking_tally/utils/const.dart';

final appTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: kAccent,
  scaffoldBackgroundColor: kBackground,
  colorScheme: const ColorScheme.dark(
    primary: kAccent,
    secondary: kSecondaryText,
    surface: kPanelBg,
    onSurface: kPrimaryText,
    onPrimary: kPrimaryText,
    error: kError,
    outline: kOutline,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: kBackground,
    elevation: 0,
    scrolledUnderElevation: 0,
    centerTitle: false,
    systemOverlayStyle: SystemUiOverlayStyle.light,
    titleTextStyle: GoogleFonts.inter(
      fontSize: 16.sp,
      fontWeight: FontWeight.w700,
      color: kPrimaryText,
      letterSpacing: 0.2,
    ),
    iconTheme: const IconThemeData(color: kPrimaryText),
  ),
  textTheme: TextTheme(
    displayLarge: GoogleFonts.inter(
      fontSize: 32.sp,
      fontWeight: FontWeight.w800,
      color: kPrimaryText,
      letterSpacing: -1.0,
    ),
    displayMedium: GoogleFonts.inter(
      fontSize: 26.sp,
      fontWeight: FontWeight.w700,
      color: kPrimaryText,
      letterSpacing: -0.5,
    ),
    displaySmall: GoogleFonts.inter(
      fontSize: 20.sp,
      fontWeight: FontWeight.w700,
      color: kPrimaryText,
    ),
    headlineLarge: GoogleFonts.inter(
      fontSize: 18.sp,
      fontWeight: FontWeight.w700,
      color: kPrimaryText,
      letterSpacing: 0.1,
    ),
    headlineMedium: GoogleFonts.inter(
      fontSize: 16.sp,
      fontWeight: FontWeight.w600,
      color: kPrimaryText,
    ),
    headlineSmall: GoogleFonts.inter(
      fontSize: 14.sp,
      fontWeight: FontWeight.w600,
      color: kPrimaryText,
    ),
    titleLarge: GoogleFonts.inter(
      fontSize: 15.sp,
      fontWeight: FontWeight.w600,
      color: kPrimaryText,
    ),
    titleMedium: GoogleFonts.inter(
      fontSize: 13.sp,
      fontWeight: FontWeight.w500,
      color: kPrimaryText,
    ),
    titleSmall: GoogleFonts.inter(
      fontSize: 12.sp,
      fontWeight: FontWeight.w400,
      color: kSecondaryText,
    ),
    bodyLarge: GoogleFonts.inter(
      fontSize: 14.sp,
      fontWeight: FontWeight.w400,
      color: kPrimaryText,
    ),
    bodyMedium: GoogleFonts.inter(
      fontSize: 13.sp,
      fontWeight: FontWeight.w400,
      color: kSecondaryText,
    ),
    bodySmall: GoogleFonts.inter(
      fontSize: 11.sp,
      fontWeight: FontWeight.w400,
      color: kSecondaryText,
    ),
    labelLarge: GoogleFonts.inter(
      fontSize: 11.sp,
      fontWeight: FontWeight.w700,
      color: kPrimaryText,
      letterSpacing: 0.8,
    ),
    labelMedium: GoogleFonts.inter(
      fontSize: 10.sp,
      fontWeight: FontWeight.w600,
      color: kSecondaryText,
      letterSpacing: 1.0,
    ),
    labelSmall: GoogleFonts.inter(
      fontSize: 9.sp,
      fontWeight: FontWeight.w700,
      color: kSecondaryText,
      letterSpacing: 1.2,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: kPanelBg,
    contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(kRadiusPill),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(kRadiusPill),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(kRadiusPill),
      borderSide: const BorderSide(color: kAccent, width: 2.0),
    ),
    hintStyle: GoogleFonts.inter(
      color: kSecondaryText,
      fontSize: 11.sp,
      fontWeight: FontWeight.w400,
    ),
    labelStyle: GoogleFonts.inter(
      color: kSecondaryText,
      fontSize: 12.sp,
      fontWeight: FontWeight.w500,
    ),
    floatingLabelStyle: GoogleFonts.inter(
      color: kAccent,
      fontSize: 11.sp,
      fontWeight: FontWeight.w600,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: kAccent,
      foregroundColor: kPrimaryText,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kRadiusPill),
      ),
      textStyle: GoogleFonts.inter(
        fontWeight: FontWeight.w700,
        fontSize: 13.sp,
        letterSpacing: 0.5,
      ),
    ),
  ),
  cardTheme: CardThemeData(
    color: kPanelBg,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(kRadiusXLarge),
      side: BorderSide.none,
    ),
    margin: EdgeInsets.zero,
  ),
  dividerTheme: const DividerThemeData(
    color: kOutline,
    thickness: kStrokeWeight,
    space: 0,
  ),
  useMaterial3: true,
);
