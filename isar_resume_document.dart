import 'package:isar/isar.dart';

part 'isar_resume_document.g.dart';

/// ⚠️ এই ফাইলটা কম্পাইল হতে `isar_resume_document.g.dart` লাগবে, যেটা
/// এখনো জেনারেট করা হয়নি (এই স্যান্ডবক্সে `build_runner` চালানোর সুযোগ নেই —
/// নেটওয়ার্ক বন্ধ)। প্রজেক্ট নিজের মেশিনে/CI-তে নেওয়ার পর প্রথমেই চালাতে হবে:
/// ```
/// flutter pub get
/// dart run build_runner build --delete-conflicting-outputs
/// ```
/// এটা PROJECT_CONTEXT.md-এর "সেশন লগ"-এ স্পষ্টভাবে নোট করা আছে।
@collection
class IsarResumeDocument {
  Id isarId = Isar.autoIncrement;

  /// অ্যাপ-লেভেল UUID (ইউজার-ফেসিং আইডি, Isar-এর ইন্টারনাল autoIncrement id থেকে আলাদা)।
  @Index(unique: true, replace: true)
  late String documentId;

  late String title;
  String? templateId;

  /// [PageSizeType]/[PageOrientation] enum-এর `.name` হিসেবে স্টোর করা হয়।
  late String pageSizeType;
  late String orientation;

  /// canvasObjects/profile/education/experience/skills — সবকিছু JSON
  /// স্ট্রিং হিসেবে রাখা হয়েছে, প্রতিটার জন্য আলাদা Isar embedded collection
  /// না বানিয়ে। কারণ: ক্যানভাস অবজেক্ট পলিমরফিক (Text/Image/Shape/Divider),
  /// আর Isar-এ পলিমরফিক embedded object হ্যান্ডেল করতে প্রতিটা সাবটাইপের
  /// জন্য আলাদা embedded class দরকার হতো — এই পর্যায়ে অপ্রয়োজনীয় জটিলতা।
  /// Trade-off: Isar দিয়ে সরাসরি নির্দিষ্ট অবজেক্টে কুয়েরি করা যাবে না
  /// (যেমন "সব ইমেজ অবজেক্ট খুঁজো") — পুরো ডকুমেন্ট লোড করে ডোমেইন লেয়ারে
  /// ফিল্টার করতে হবে। একটা রেজুমেতে কয়েক ডজন অবজেক্ট থাকে বলে এটা গ্রহণযোগ্য।
  late String canvasObjectsJson;
  String? profileJson;
  late String educationJson;
  late String experienceJson;
  late String skillsJson;

  late DateTime createdAt;
  late DateTime updatedAt;
}
