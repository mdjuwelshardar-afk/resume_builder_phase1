/// UI-এর সব প্যাডিং/মার্জিন/গ্যাপ এই স্কেল থেকে নেওয়া উচিত — যেন পুরো অ্যাপে
/// স্পেসিং সামঞ্জস্যপূর্ণ থাকে (Material 3-এর 4dp গ্রিড অনুসরণ করে)।
class AppSpacing {
  AppSpacing._();

  static const double xs = 4;
  static const double s = 8;
  static const double m = 16;
  static const double l = 24;
  static const double xl = 32;
  static const double xxl = 48;
}

/// কর্নার রেডিয়াস টোকেন — কার্ড, বাটন, ডায়ালগ, এবং ক্যানভাসের rounded shape
/// অবজেক্টের ডিফল্ট মানের জন্য।
class AppRadius {
  AppRadius._();

  static const double small = 6;
  static const double medium = 12;
  static const double large = 20;
  static const double pill = 999;
}

/// এলিভেশন (শ্যাডো গভীরতা) টোকেন।
class AppElevation {
  AppElevation._();

  static const double level0 = 0;
  static const double level1 = 1;
  static const double level2 = 3;
  static const double level3 = 6;
  static const double level4 = 10;
}
