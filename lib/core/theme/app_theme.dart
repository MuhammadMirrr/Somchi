import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  // ───── LIGHT THEME ─────
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: Colors.white,
      primaryContainer: AppColors.primarySurface,
      secondary: AppColors.accent,
      surface: AppColors.surfaceLight,
      onSurface: AppColors.textPrimaryLight,
      surfaceContainerHighest: AppColors.surfaceVariantLight,
      error: AppColors.negative,
      onError: Colors.white,
      outline: AppColors.borderLight,
      outlineVariant: AppColors.dividerLight,
    ),
    scaffoldBackgroundColor: AppColors.backgroundLight,
    textTheme: _buildTextTheme(Brightness.light),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: AppColors.textPrimaryLight,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      titleTextStyle: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimaryLight,
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.cardLight,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.dividerLight, width: 1),
      ),
      margin: EdgeInsets.zero,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.surfaceLight,
      indicatorColor: AppColors.primarySurface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      height: 64,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          );
        }
        return GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: AppColors.textTertiaryLight,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: AppColors.primary, size: 22);
        }
        return const IconThemeData(
            color: AppColors.textTertiaryLight, size: 22);
      }),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.dividerLight,
      thickness: 1,
      space: 0,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceVariantLight,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.negative, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.negative, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      hintStyle: GoogleFonts.inter(
        fontSize: 14,
        color: AppColors.textTertiaryLight,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.surfaceLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      elevation: 0,
      surfaceTintColor: Colors.transparent,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.textPrimaryLight,
      contentTextStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Colors.white,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      behavior: SnackBarBehavior.floating,
      elevation: 0,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.surfaceLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimaryLight,
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.surfaceVariantLight,
      selectedColor: AppColors.primarySurface,
      labelStyle: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      side: BorderSide.none,
    ),
  );

  // ───── DARK THEME ─────
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primaryLightDark,
      onPrimary: AppColors.backgroundDark,
      primaryContainer: AppColors.primarySurfaceDark,
      secondary: AppColors.accent,
      surface: AppColors.surfaceDark,
      onSurface: AppColors.textPrimaryDark,
      surfaceContainerHighest: AppColors.surfaceVariantDark,
      error: AppColors.negative,
      onError: Colors.white,
      outline: AppColors.borderDark,
      outlineVariant: AppColors.dividerDark,
    ),
    scaffoldBackgroundColor: AppColors.backgroundDark,
    textTheme: _buildTextTheme(Brightness.dark),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: AppColors.textPrimaryDark,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      titleTextStyle: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimaryDark,
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.cardDark,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.dividerDark, width: 1),
      ),
      margin: EdgeInsets.zero,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.surfaceDark,
      indicatorColor: AppColors.primarySurfaceDark,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      height: 64,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryLightDark,
          );
        }
        return GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: AppColors.textTertiaryDark,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(
              color: AppColors.primaryLightDark, size: 22);
        }
        return const IconThemeData(
            color: AppColors.textTertiaryDark, size: 22);
      }),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.dividerDark,
      thickness: 1,
      space: 0,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceVariantDark,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide:
            const BorderSide(color: AppColors.primaryLightDark, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.negative, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.negative, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      hintStyle: GoogleFonts.inter(
        fontSize: 14,
        color: AppColors.textTertiaryDark,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryLightDark,
        foregroundColor: AppColors.backgroundDark,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryLightDark,
        side: const BorderSide(color: AppColors.primaryLightDark),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primaryLightDark,
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.surfaceDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      elevation: 0,
      surfaceTintColor: Colors.transparent,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.surfaceVariantDark,
      contentTextStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimaryDark,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      behavior: SnackBarBehavior.floating,
      elevation: 0,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.surfaceDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimaryDark,
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.surfaceVariantDark,
      selectedColor: AppColors.primarySurfaceDark,
      labelStyle: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      side: BorderSide.none,
    ),
  );

  // ───── TEXT THEME ─────
  static TextTheme _buildTextTheme(Brightness brightness) {
    final color = brightness == Brightness.light
        ? AppColors.textPrimaryLight
        : AppColors.textPrimaryDark;

    final secondaryColor = brightness == Brightness.light
        ? AppColors.textSecondaryLight
        : AppColors.textSecondaryDark;

    return TextTheme(
      displayLarge: GoogleFonts.inter(
        fontSize: 40,
        fontWeight: FontWeight.w600,
        color: color,
        height: 1.1,
      ),
      displayMedium: GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: color,
        height: 1.2,
      ),
      headlineLarge: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: color,
        height: 1.25,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: color,
        height: 1.3,
      ),
      titleLarge: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: color,
        height: 1.4,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: color,
        height: 1.4,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: color,
        height: 1.4,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: color,
        height: 1.5,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: color,
        height: 1.5,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: secondaryColor,
        height: 1.5,
      ),
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: color,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: secondaryColor,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: secondaryColor,
      ),
    );
  }
}
