import '../entities/resume_document.dart';

/// ডোমেইন লেয়ার শুধু এই ইন্টারফেসটা জানে — Isar/Hive/অন্য কোনো স্টোরেজ
/// ব্যবহার হচ্ছে কিনা তা জানে না। প্রেজেন্টেশন লেয়ার (Riverpod provider)
/// এই ইন্টারফেসের মাধ্যমেই ডেটা লেয়ারের সাথে কথা বলবে, যাতে ভবিষ্যতে
/// স্টোরেজ ইঞ্জিন বদলাতে হলে শুধু data/repositories/-এর implementation
/// বদলালেই হয়, বাকি অ্যাপ স্পর্শ করতে হয় না।
abstract class ResumeRepository {
  Future<void> save(ResumeDocument document);

  Future<ResumeDocument?> getById(String id);

  /// সাম্প্রতিক আপডেট হওয়া অনুযায়ী সাজানো — Home Screen-এর "Recent Resumes"-এ ব্যবহার হবে।
  Future<List<ResumeDocument>> getAllSortedByRecent();

  Future<void> delete(String id);

  Future<ResumeDocument> duplicate(String id, {required String newTitle});
}
