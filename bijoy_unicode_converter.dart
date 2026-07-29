import 'bengali_encoding.dart';
import 'bijoy_unicode_map.dart';

/// DOC/DOCX/TXT ইম্পোর্ট করা টেক্সট Unicode বাংলা নাকি Bijoy Classic/SutonnyMJ
/// (legacy ANSI) এনকোডিং-এ লেখা তা শনাক্ত করে, এবং প্রয়োজনে Unicode-এ রূপান্তর করে।
///
/// ব্যবহার (features/*/data লেয়ারে DOC/DOCX ইম্পোর্টের সময়):
/// ```dart
/// final encoding = BijoyUnicodeConverter.detect(rawParagraphText);
/// final displayText = encoding == BengaliEncoding.legacyAnsiBijoy
///     ? BijoyUnicodeConverter.convertToUnicode(rawParagraphText)
///     : rawParagraphText;
/// ```
class BijoyUnicodeConverter {
  BijoyUnicodeConverter._();

  /// U+0980–U+09FF — Unicode বাংলা ব্লক।
  static final RegExp _unicodeBengaliBlock = RegExp(r'[\u0980-\u09FF]');

  /// টেক্সটের এনকোডিং শনাক্ত করে।
  ///
  /// পদ্ধতি: টেক্সটে Unicode বাংলা ক্যারেক্টারের অনুপাত হিসাব করা হয়। অনুপাত
  /// যথেষ্ট বেশি হলে [BengaliEncoding.unicode]। টেক্সটে বর্ণমালা-জাতীয়
  /// ক্যারেক্টার আছে কিন্তু Unicode বাংলা প্রায় নেই — এমন হলে এবং পরিচিত Bijoy
  /// telltale প্যাটার্ন মিললে [BengaliEncoding.legacyAnsiBijoy]। অন্যথায়
  /// [BengaliEncoding.notBengaliOrUnknown]।
  static BengaliEncoding detect(String text) {
    if (text.trim().isEmpty) return BengaliEncoding.notBengaliOrUnknown;

    final letters = text.replaceAll(RegExp(r'\s'), '');
    if (letters.isEmpty) return BengaliEncoding.notBengaliOrUnknown;

    final unicodeBengaliCount =
        _unicodeBengaliBlock.allMatches(letters).length;
    final unicodeRatio = unicodeBengaliCount / letters.length;

    // যথেষ্ট Unicode বাংলা ক্যারেক্টার পাওয়া গেলে সরাসরি Unicode ধরে নেওয়া হচ্ছে।
    if (unicodeRatio > 0.3) {
      return BengaliEncoding.unicode;
    }

    // Unicode বাংলা প্রায় নেই — পরিচিত Bijoy telltale প্যাটার্ন খোঁজা হচ্ছে।
    final hasTelltale =
        bijoyTelltaleSequences.any((pattern) => text.contains(pattern));
    final hasMappedAsciiChars = bijoyAsciiToUnicodeMap.keys
        .where((k) => k.length == 1)
        .any((k) => text.contains(k));

    if (hasTelltale || hasMappedAsciiChars) {
      return BengaliEncoding.legacyAnsiBijoy;
    }

    return BengaliEncoding.notBengaliOrUnknown;
  }

  /// Bijoy Classic/SutonnyMJ টেক্সটকে Unicode বাংলায় রূপান্তর করে।
  ///
  /// ধাপ:
  /// ১. মাল্টি-ক্যারেক্টার সিকোয়েন্স (যেমন 'Av') আগে ম্যাচ করা হয়, তারপর একক ক্যারেক্টার।
  /// ২. প্রি-বেস vowel sign (ি-জাতীয়) রিঅর্ডার করা হয় Unicode নিয়ম অনুযায়ী।
  static String convertToUnicode(String bijoyText) {
    final glyphMapped = _mapGlyphs(bijoyText);
    return _reorderVowelSigns(glyphMapped);
  }

  static String _mapGlyphs(String input) {
    final buffer = StringBuffer();
    var i = 0;

    // দৈর্ঘ্য অনুযায়ী বড় থেকে ছোট চেষ্টা করা হচ্ছে, যাতে multi-char key
    // (যেমন 'Av') এক-ক্যারেক্টার ম্যাচের আগেই ধরা পড়ে।
    final sortedKeys = bijoyAsciiToUnicodeMap.keys.toList()
      ..sort((a, b) => b.length.compareTo(a.length));

    while (i < input.length) {
      String? matchedValue;
      var matchedLength = 0;

      for (final key in sortedKeys) {
        if (key.length <= input.length - i &&
            input.substring(i, i + key.length) == key) {
          matchedValue = bijoyAsciiToUnicodeMap[key];
          matchedLength = key.length;
          break;
        }
      }

      if (matchedValue != null) {
        buffer.write(matchedValue);
        i += matchedLength;
      } else {
        // ম্যাপে নেই এমন ক্যারেক্টার (স্পেস, ইংরেজি অক্ষর ইত্যাদি) অপরিবর্তিত রাখা হয়।
        buffer.write(input[i]);
        i += 1;
      }
    }

    return buffer.toString();
  }

  /// Bijoy-তে ি (i-kar)-এর মতো প্রি-বেস vowel sign কনসোনেন্টের *আগে* টাইপ হয়,
  /// কিন্তু Unicode-এ ওই vowel sign কনসোনেন্টের *পরে* বসতে হয়। এই ফাংশন
  /// "ি" + consonant প্যাটার্ন খুঁজে consonant + "ি"-তে সোয়াপ করে।
  ///
  /// এটা একটা সরলীকৃত সংস্করণ — যুক্তাক্ষর (conjuncts, যেমন ক্ + ষ = ক্ষ) এর
  /// সাথে মিলিত হলে এই লজিক আরও জটিল হয় এবং বাস্তব ডকুমেন্ট দিয়ে
  /// অতিরিক্ত টেস্ট/সম্প্রসারণ দরকার।
  static String _reorderVowelSigns(String input) {
    const preBaseVowelSign = 'ি';
    final buffer = StringBuffer();
    var i = 0;

    while (i < input.length) {
      if (input[i] == preBaseVowelSign && i + 1 < input.length) {
        // পরের ক্যারেক্টার (consonant) কে আগে বসিয়ে, তারপর vowel sign।
        buffer.write(input[i + 1]);
        buffer.write(preBaseVowelSign);
        i += 2;
      } else {
        buffer.write(input[i]);
        i += 1;
      }
    }

    return buffer.toString();
  }
}
