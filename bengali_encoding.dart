/// একটা টেক্সট ব্লক কোন এনকোডিং-এ লেখা হতে পারে তার শনাক্তকরণ ফলাফল।
enum BengaliEncoding {
  /// স্ট্যান্ডার্ড Unicode বাংলা (U+0980–U+09FF ব্লক) — সরাসরি প্রদর্শনযোগ্য।
  unicode,

  /// Bijoy Classic / SutonnyMJ / SutonnyOMJ ধরনের ANSI গ্লিফ-অর্ডার এনকোডিং —
  /// Unicode ফন্টে দেখালে ভেঙে/উল্টে দেখাবে, তাই কনভার্সন দরকার।
  legacyAnsiBijoy,

  /// বাংলা বলে মনে হচ্ছে না, বা এত কম স্যাম্পল যে নিশ্চিত হওয়া যাচ্ছে না।
  notBengaliOrUnknown,
}
