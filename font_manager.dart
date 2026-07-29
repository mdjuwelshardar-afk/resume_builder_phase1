import 'dart:convert';
import 'dart:typed_data' show ByteData;

import 'package:flutter/services.dart' show rootBundle, FontLoader;

import 'bangla_font_definition.dart';

/// `assets/fonts/` ফোল্ডারে থাকা সব ফন্ট ফাইল রানটাইমে খুঁজে বের করে এবং
/// Flutter-এর `FontLoader` দিয়ে রেজিস্টার করে — pubspec.yaml-এ প্রতিটা ফন্ট
/// আলাদা করে `fonts:` এন্ট্রি হিসেবে ঘোষণা না করেই।
///
/// ফলাফল: নতুন একটা `.ttf`/`.otf` ফাইল `assets/fonts/`-এ রাখলেই (আর
/// pubspec.yaml-এর `assets:` তালিকায় ফোল্ডারটা যোগ করা থাকলে, যা একবারই
/// করতে হয়) সেটা স্বয়ংক্রিয়ভাবে অ্যাপের ফন্ট তালিকায় চলে আসবে — কোনো কোড
/// পরিবর্তন ছাড়াই। এটাই PROJECT-এ চাওয়া "সম্পূর্ণ ডাইনামিক Font Manager"।
class FontManager {
  FontManager._();
  static final FontManager instance = FontManager._();

  final List<BanglaFontDefinition> _discoveredFonts = [];
  bool _initialized = false;

  List<BanglaFontDefinition> get fonts => List.unmodifiable(_discoveredFonts);
  bool get isInitialized => _initialized;

  /// পরিচিত জনপ্রিয় বাংলা ফন্টের সুন্দর প্রদর্শন-নাম। এই তালিকায় না থাকলে
  /// ফাইলনেম থেকেই একটা পড়ার-উপযোগী নাম বানানো হয় ([_humanizeFileName])।
  static const Map<String, String> _knownDisplayNames = {
    'NotoSansBengali': 'Noto Sans Bengali',
    'NotoSerifBengali': 'Noto Serif Bengali',
    'SolaimanLipi': 'SolaimanLipi',
    'Kalpurush': 'Kalpurush',
    'SiyamRupali': 'Siyam Rupali',
    'AponaLohit': 'AponaLohit',
    'Rupali': 'Rupali',
    'Nikosh': 'Nikosh',
    'AdorshoLipi': 'AdorshoLipi',
  };

  /// অ্যাপ চালু হওয়ার সময় (main.dart-এ, runApp()-এর আগে) একবার কল করতে হবে।
  Future<void> initialize({String fontsAssetFolder = 'assets/fonts/'}) async {
    if (_initialized) return;

    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap =
        json.decode(manifestContent) as Map<String, dynamic>;

    final fontAssetPaths = manifestMap.keys
        .where((path) =>
            path.startsWith(fontsAssetFolder) &&
            (path.endsWith('.ttf') || path.endsWith('.otf')))
        .toList()
      ..sort();

    for (final assetPath in fontAssetPaths) {
      final fileName = assetPath.split('/').last;
      final nameWithoutExt = fileName.replaceAll(RegExp(r'\.(ttf|otf)$'), '');
      // "NotoSansBengali-Bold" থেকে বেস অংশ "NotoSansBengali" বের করা হচ্ছে,
      // যাতে পরিচিত-ফন্ট তালিকায় মিলিয়ে সুন্দর ডিসপ্লে-নাম দেওয়া যায়।
      final baseName = nameWithoutExt.split('-').first;

      // pubspec.yaml-এ family ঘোষণা ছাড়া লোড করছি বলে প্রতিটা ফাইলকে
      // (Regular/Bold আলাদা) আলাদা family হিসেবে রেজিস্টার করা হচ্ছে।
      final familyName = nameWithoutExt;
      final displayName =
          _knownDisplayNames[baseName] ?? _humanizeFileName(baseName);

      final loader = FontLoader(familyName);
      loader.addFont(rootBundle.load(assetPath));
      await loader.load();

      _discoveredFonts.add(
        BanglaFontDefinition(
          familyName: familyName,
          displayName: displayName,
          assetPath: assetPath,
        ),
      );
    }

    _initialized = true;
  }

  /// ইউজার নিজের ডিভাইস থেকে একটা লাইসেন্সড ফন্ট (যেমন নিজস্ব SutonnyMJ ফাইল)
  /// ইম্পোর্ট করলে সেটা রানটাইমে রেজিস্টার করার জন্য — কোনো raw font bytes
  /// সোর্স থেকে (ফাইল পিকার দিয়ে বেছে নেওয়া ফাইল ইত্যাদি)।
  Future<BanglaFontDefinition> registerUserImportedFont({
    required String familyName,
    required String displayName,
    required Future<ByteData> Function() loadFontBytes,
  }) async {
    final loader = FontLoader(familyName);
    loader.addFont(loadFontBytes());
    await loader.load();

    final definition = BanglaFontDefinition(
      familyName: familyName,
      displayName: displayName,
      assetPath: '(user-imported)',
      isBundled: false,
    );
    _discoveredFonts.add(definition);
    return definition;
  }

  String _humanizeFileName(String baseName) {
    // "SomeFontName" -> "Some Font Name"
    return baseName.replaceAllMapped(
      RegExp(r'(?<=[a-z0-9])(?=[A-Z])'),
      (m) => ' ',
    );
  }
}
