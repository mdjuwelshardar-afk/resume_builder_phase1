import 'package:flutter/material.dart';

/// অ্যাপের UI (ক্যানভাসের ভেতরের টেক্সট অবজেক্ট না — সেটা ইউজার নিজের ফন্ট
/// বেছে নেয়, দেখো [FontManager]) এর জন্য টাইপোগ্রাফি স্কেল।
///
/// এখানে বেস ফন্ট ইংরেজি রাখা হয়েছে (সিস্টেম ডিফল্ট); UI-এর কোনো লেবেল যদি
/// বাংলায় দেখাতে হয় (যেমন হোম স্ক্রিনের মেনু), সেই জায়গায় `.copyWith(fontFamily: ...)`
/// দিয়ে একটা বাংলা UI ফন্ট (যেমন NotoSansBengali) বসিয়ে নেওয়া যাবে।
class AppTypography {
  AppTypography._();

  static const String _defaultFontFamily = 'Roboto';

  static TextTheme textTheme({String fontFamily = _defaultFontFamily}) {
    return TextTheme(
      displayLarge: TextStyle(
          fontFamily: fontFamily, fontSize: 57, fontWeight: FontWeight.w400),
      displayMedium: TextStyle(
          fontFamily: fontFamily, fontSize: 45, fontWeight: FontWeight.w400),
      headlineLarge: TextStyle(
          fontFamily: fontFamily, fontSize: 32, fontWeight: FontWeight.w600),
      headlineMedium: TextStyle(
          fontFamily: fontFamily, fontSize: 28, fontWeight: FontWeight.w600),
      titleLarge: TextStyle(
          fontFamily: fontFamily, fontSize: 22, fontWeight: FontWeight.w600),
      titleMedium: TextStyle(
          fontFamily: fontFamily, fontSize: 16, fontWeight: FontWeight.w500),
      titleSmall: TextStyle(
          fontFamily: fontFamily, fontSize: 14, fontWeight: FontWeight.w500),
      bodyLarge: TextStyle(
          fontFamily: fontFamily, fontSize: 16, fontWeight: FontWeight.w400),
      bodyMedium: TextStyle(
          fontFamily: fontFamily, fontSize: 14, fontWeight: FontWeight.w400),
      bodySmall: TextStyle(
          fontFamily: fontFamily, fontSize: 12, fontWeight: FontWeight.w400),
      labelLarge: TextStyle(
          fontFamily: fontFamily, fontSize: 14, fontWeight: FontWeight.w600),
      labelMedium: TextStyle(
          fontFamily: fontFamily, fontSize: 12, fontWeight: FontWeight.w600),
      labelSmall: TextStyle(
          fontFamily: fontFamily, fontSize: 11, fontWeight: FontWeight.w600),
    );
  }
}
