import 'package:isar/isar.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/resume_document.dart';
import '../../domain/repositories/resume_repository.dart';
import '../models/isar_resume_document.dart';
import '../models/resume_document_mapper.dart';

/// [ResumeRepository]-এর Isar-ভিত্তিক বাস্তবায়ন। এই ক্লাসটাই একমাত্র জায়গা
/// যেখানে Isar-নির্দিষ্ট কোড আছে — presentation layer (Riverpod provider)
/// শুধু [ResumeRepository] ইন্টারফেস দিয়ে এটা ব্যবহার করবে।
class IsarResumeRepository implements ResumeRepository {
  final Isar isar;
  static const _uuid = Uuid();

  IsarResumeRepository(this.isar);

  @override
  Future<void> save(ResumeDocument document) async {
    await isar.writeTxn(() async {
      final existing = await isar.isarResumeDocuments
          .filter()
          .documentIdEqualTo(document.id)
          .findFirst();

      final isarDoc = ResumeDocumentMapper.toIsar(
        document,
        existingIsarId: existing?.isarId,
      );
      await isar.isarResumeDocuments.put(isarDoc);
    });
  }

  @override
  Future<ResumeDocument?> getById(String id) async {
    final isarDoc = await isar.isarResumeDocuments
        .filter()
        .documentIdEqualTo(id)
        .findFirst();
    if (isarDoc == null) return null;
    return ResumeDocumentMapper.toDomain(isarDoc);
  }

  @override
  Future<List<ResumeDocument>> getAllSortedByRecent() async {
    final isarDocs = await isar.isarResumeDocuments
        .where()
        .sortByUpdatedAtDesc()
        .findAll();
    return isarDocs.map(ResumeDocumentMapper.toDomain).toList();
  }

  @override
  Future<void> delete(String id) async {
    await isar.writeTxn(() async {
      await isar.isarResumeDocuments.filter().documentIdEqualTo(id).deleteAll();
    });
  }

  @override
  Future<ResumeDocument> duplicate(String id, {required String newTitle}) async {
    final original = await getById(id);
    if (original == null) {
      throw StateError('ডুপ্লিকেট করার জন্য রেজুমে ($id) পাওয়া যায়নি');
    }

    final now = DateTime.now();
    final copy = ResumeDocument(
      id: _uuid.v4(),
      title: newTitle,
      templateId: original.templateId,
      pageSizeType: original.pageSizeType,
      orientation: original.orientation,
      canvasObjects: original.canvasObjects,
      profile: original.profile,
      education: original.education,
      experience: original.experience,
      skills: original.skills,
      createdAt: now,
      updatedAt: now,
    );

    await save(copy);
    return copy;
  }
}
