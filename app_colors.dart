import 'package:flutter/material.dart';

/// অ্যাপের পুরো রঙের প্যালেট — এখান থেকেই light/dark দুই থিম তৈরি হয়।
/// UI-এর কোথাও সরাসরি Color(0x...) লেখা উচিত না, সবসময় এই টোকেনগুলো
/// (বা Theme.of(context).colorScheme) ব্যবহার করতে হবে, যাতে ব্র্যান্ড রঙ
/// এক জায়গা থেকে বদলানো যায়।
class AppColors {
  AppColors._();

  // --- ব্র্যান্ড / প্রাইমারি ---
  static const Color primary = Color(0xFF2563EB); // নীল — মূল অ্যাকশন কালার
  static const Color primaryDark = Color(0xFF1D4ED8);
  static const Color secondary = Color(0xFF0EA5A4); // টিল — সেকেন্ডারি অ্যাকসেন্ট

  // --- সিমান্টিক ---
  static const Color success = Color(0xFF16A34A);
  static const Color warning = Color(0xFFD97706);
  static const Color error = Color(0xFFDC2626);
  static const Color info = Color(0xFF2563EB);

  // --- নিউট্রাল (লাইট থিম) ---
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE2E8F0);
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF64748B);

  // --- নিউট্রাল (ডার্ক থিম) ---
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkBorder = Color(0xFF334155);
  static const Color darkTextPrimary = Color(0xFFF1F5F9);
  static const Color darkTextSecondary = Color(0xFF94A3B8);

  // --- ক্যানভাস-নির্দিষ্ট (এডিটরে পেজ, গ্রিড, সিলেকশন) ---
  static const Color canvasPageBackground = Color(0xFFFFFFFF); // A4 পেজের রং — সবসময় সাদা, থিম নির্বিশেষে
  static const Color canvasGridLine = Color(0xFFE5E7EB);
  static const Color canvasSelectionOutline = Color(0xFF2563EB);
  static const Color canvasSelectionHandle = Color(0xFFFFFFFF);
  static const Color canvasSmartGuide = Color(0xFFEC4899);
}
