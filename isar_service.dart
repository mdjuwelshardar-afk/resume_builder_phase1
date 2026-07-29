import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../features/resume_builder/data/models/isar_resume_document.dart';
import '../../features/resume_builder/data/repositories/isar_resume_repository.dart';
import '../../features/resume_builder/domain/repositories/resume_repository.dart';

/// অ্যাপের একমাত্র Isar ইনস্ট্যান্স এখান থেকেই খোলা হয়। নতুন কোনো ফিচার
/// মডিউল (cover_letter, biodata ইত্যাদি) নিজের Isar কালেকশন যোগ করতে চাইলে
/// [schemas] লিস্টে সেটার schema যোগ করবে — Isar একটাই ডিরেক্টরিতে সব
/// কালেকশন একসাথে রাখে, প্রতিটা ফিচারের জন্য আলাদা Isar.open() লাগবে না।
class IsarService {
  IsarService._();

  static Future<Isar> open() async {
    final dir = await getApplicationDocumentsDirectory();
    return Isar.open(
      [IsarResumeDocumentSchema],
      directory: dir.path,
      inspector: false,
    );
  }
}

/// অ্যাপ শুরুতে একবার resolve হবে, তারপর পুরো অ্যাপ একই Isar ইনস্ট্যান্স
/// শেয়ার করবে। UI-তে ব্যবহার: `ref.watch(isarProvider)` (AsyncValue হিসেবে)।
final isarProvider = FutureProvider<Isar>((ref) => IsarService.open());

/// [ResumeRepository] ইন্টারফেস দিয়ে বাকি অ্যাপ ডেটা লেয়ারের সাথে কথা বলবে —
/// এই provider Isar রেডি হওয়ার পরই resolve হয়।
final resumeRepositoryProvider = FutureProvider<ResumeRepository>((ref) async {
  final isar = await ref.watch(isarProvider.future);
  return IsarResumeRepository(isar);
});
