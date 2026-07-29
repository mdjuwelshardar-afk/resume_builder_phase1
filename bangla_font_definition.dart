/// একটা ফন্ট সম্পর্কে অ্যাপের যা জানা দরকার — pubspec.yaml-এ ঘোষণা করা family
/// name, ইউজারকে দেখানোর নাম, আর এটা বাংলা স্ক্রিপ্টের জন্য উপযুক্ত কিনা।
class BanglaFontDefinition {
  /// pubspec.yaml-এর `fonts:` সেকশনে যে family নামে ঘোষণা করা আছে —
  /// এটাই Flutter TextStyle(fontFamily: ...) এ ব্যবহার হবে।
  final String familyName;

  /// ইউজারকে ফন্ট পিকারে দেখানোর নাম (বাংলায়, ইউজার-ফ্রেন্ডলি)
  final String displayName;

  /// assets/fonts/ এর ভেতরে ফন্ট ফাইলের পাথ (ডিবাগ/যাচাইয়ের জন্য রাখা)
  final String assetPath;

  /// সাধারণ Unicode বাংলা ফন্ট (SolaimanLipi, Kalpurush, Noto Sans Bengali ইত্যাদি)।
  final bool isBanglaScript;

  /// এই ফন্ট ফ্রি/ওপেন লাইসেন্সে বান্ডল করা যায়, নাকি ইউজারকে নিজে ইম্পোর্ট করতে হবে
  /// (যেমন SutonnyMJ — লাইসেন্স ছাড়া বান্ডল করা যাবে না)।
  final bool isBundled;

  const BanglaFontDefinition({
    required this.familyName,
    required this.displayName,
    required this.assetPath,
    this.isBanglaScript = true,
    this.isBundled = true,
  });

  @override
  String toString() =>
      'BanglaFontDefinition(familyName: $familyName, bundled: $isBundled)';
}
