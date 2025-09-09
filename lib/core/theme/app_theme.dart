import 'package:flutter/material.dart';
import 'package:lotus_news/core/theme/app_color.dart';

class AppTheme extends ChangeNotifier{

  static final TextStyle _textStyle = TextStyle(
    color: AppColor.black,
    fontSize: 14,
  );

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColor.white,
    cardColor: AppColor.black,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColor.white,
      titleTextStyle: _textStyle.copyWith(color: AppColor.black, fontSize: 20, fontWeight: FontWeight.bold)
    ),
    iconTheme: IconThemeData(
      color: AppColor.lightText,
    ),
    cardTheme: CardThemeData(
      color: AppColor.white
    ),
    primaryColor: AppColor.black,
    textTheme: TextTheme(
      displayLarge: _textStyle.copyWith(color: AppColor.lightText, fontSize: 20, fontWeight: FontWeight.w600),
      displayMedium: _textStyle.copyWith(color: AppColor.lightText, fontSize: 18, fontWeight: FontWeight.w500),
      displaySmall: _textStyle.copyWith(color: AppColor.lightText, fontSize: 16, fontWeight: FontWeight.w400),
      headlineLarge: _textStyle.copyWith(color: AppColor.lightText, fontSize: 20, fontWeight: FontWeight.bold),
      headlineMedium: _textStyle.copyWith(color: AppColor.lightText, fontSize: 18, fontWeight: FontWeight.bold),
      headlineSmall: _textStyle.copyWith(color: AppColor.lightText, fontSize: 16, fontWeight: FontWeight.bold),
      titleLarge: _textStyle.copyWith(color: AppColor.lightText, fontSize: 20, fontWeight: FontWeight.bold),
      titleMedium: _textStyle.copyWith(color: AppColor.lightText, fontSize: 18, fontWeight: FontWeight.bold),
      titleSmall: _textStyle.copyWith(color: AppColor.lightText, fontSize: 16, fontWeight: FontWeight.bold),
      bodyLarge: _textStyle.copyWith(color: AppColor.lightText, fontSize: 18, fontWeight: FontWeight.bold),
      bodyMedium: _textStyle.copyWith(color: AppColor.lightText, fontSize: 16, fontWeight: FontWeight.w600),
      bodySmall: _textStyle.copyWith(color: AppColor.lightText, fontSize: 14, fontWeight: FontWeight.w400),
      labelLarge: _textStyle.copyWith(color: AppColor.lightText, fontSize: 18, fontWeight: FontWeight.bold),
      labelMedium: _textStyle.copyWith(color: AppColor.lightText, fontSize: 16, fontWeight: FontWeight.bold),
      labelSmall: _textStyle.copyWith(color: AppColor.lightText, fontSize: 14, fontWeight: FontWeight.bold),
    )
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColor.black,
    cardColor: AppColor.white,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColor.black,
      titleTextStyle: _textStyle.copyWith(color: AppColor.white, fontSize: 20, fontWeight: FontWeight.bold)
    ),
    iconTheme: IconThemeData(
      color: AppColor.darkText,
    ),
    cardTheme: CardThemeData(
      color: AppColor.black
    ),
    primaryColor: AppColor.white,
    textTheme: TextTheme(
      displayLarge: _textStyle.copyWith(color: AppColor.darkText, fontSize: 20, fontWeight: FontWeight.w600),
      displayMedium: _textStyle.copyWith(color: AppColor.darkText, fontSize: 18, fontWeight: FontWeight.w500),
      displaySmall: _textStyle.copyWith(color: AppColor.darkText, fontSize: 16, fontWeight: FontWeight.w400),
      headlineLarge: _textStyle.copyWith(color: AppColor.darkText, fontSize: 20, fontWeight: FontWeight.bold),
      headlineMedium: _textStyle.copyWith(color: AppColor.darkText, fontSize: 18, fontWeight: FontWeight.bold),
      headlineSmall: _textStyle.copyWith(color: AppColor.darkText, fontSize: 16, fontWeight: FontWeight.bold),
      titleLarge: _textStyle.copyWith(color: AppColor.darkText, fontSize: 20, fontWeight: FontWeight.bold),
      titleMedium: _textStyle.copyWith(color: AppColor.darkText, fontSize: 18, fontWeight: FontWeight.bold),
      titleSmall: _textStyle.copyWith(color: AppColor.darkText, fontSize: 16, fontWeight: FontWeight.bold),
      bodyLarge: _textStyle.copyWith(color: AppColor.darkText, fontSize: 18, fontWeight: FontWeight.bold),
      bodyMedium: _textStyle.copyWith(color: AppColor.darkText, fontSize: 16, fontWeight: FontWeight.w600),
      bodySmall: _textStyle.copyWith(color: AppColor.darkText, fontSize: 14, fontWeight: FontWeight.w400),
      labelLarge: _textStyle.copyWith(color: AppColor.darkText, fontSize: 18, fontWeight: FontWeight.bold),
      labelMedium: _textStyle.copyWith(color: AppColor.darkText, fontSize: 16, fontWeight: FontWeight.bold),
      labelSmall: _textStyle.copyWith(color: AppColor.darkText, fontSize: 14, fontWeight: FontWeight.bold),
    )
  );
}