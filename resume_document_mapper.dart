import 'dart:convert';

import '../../../../shared/canvas_engine/models/canvas_object.dart';
import '../../../../shared/canvas_engine/models/page_size.dart';
import '../../domain/entities/profile_section.dart';
import '../../domain/entities/resume_document.dart';
import '../../domain/entities/resume_sections.dart';
import 'isar_resume_document.dart';

/// [ResumeDocument] (ডোমেইন এনটিটি, Isar সম্পর্কে কিছু জানে না) আর
/// [IsarResumeDocument] (স্টোরেজ মডেল) এর মধ্যে রূপান্তরের দায়িত্ব একমাত্র
/// এই ক্লাসের — এটাই Clean Architecture-এ data layer-এর কাজ।
class ResumeDocumentMapper {
  ResumeDocumentMapper._();

  static IsarResumeDocument toIsar(ResumeDocument doc, {int? existingIsarId}) {
    final isarDoc = IsarResumeDocument()
      ..documentId = doc.id
      ..title = doc.title
      ..templateId = doc.templateId
      ..pageSizeType = doc.pageSizeType.name
      ..orientation = doc.orientation.name
      ..canvasObjectsJson =
          json.encode(doc.canvasObjects.map((o) => o.toJson()).toList())
      ..profileJson =
          doc.profile != null ? json.encode(doc.profile!.toJson()) : null
      ..educationJson =
          json.encode(doc.education.map((e) => e.toJson()).toList())
      ..experienceJson =
          json.encode(doc.experience.map((e) => e.toJson()).toList())
      ..skillsJson = json.encode(doc.skills.map((s) => s.toJson()).toList())
      ..createdAt = doc.createdAt
      ..updatedAt = doc.updatedAt;

    if (existingIsarId != null) {
      isarDoc.isarId = existingIsarId;
    }
    return isarDoc;
  }

  static ResumeDocument toDomain(IsarResumeDocument isarDoc) {
    final canvasObjectsRaw =
        json.decode(isarDoc.canvasObjectsJson) as List<dynamic>;
    final educationRaw = json.decode(isarDoc.educationJson) as List<dynamic>;
    final experienceRaw =
        json.decode(isarDoc.experienceJson) as List<dynamic>;
    final skillsRaw = json.decode(isarDoc.skillsJson) as List<dynamic>;

    return ResumeDocument(
      id: isarDoc.documentId,
      title: isarDoc.title,
      templateId: isarDoc.templateId,
      pageSizeType: PageSizeType.values.byName(isarDoc.pageSizeType),
      orientation: PageOrientation.values.byName(isarDoc.orientation),
      canvasObjects: canvasObjectsRaw
          .map((raw) => CanvasObject.fromJson(raw as Map<String, dynamic>))
          .toList(),
      profile: isarDoc.profileJson != null
          ? ProfileSection.fromJson(
              json.decode(isarDoc.profileJson!) as Map<String, dynamic>)
          : null,
      education: educationRaw
          .map((e) => EducationEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
      experience: experienceRaw
          .map((e) => ExperienceEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
      skills: skillsRaw
          .map((s) => SkillEntry.fromJson(s as Map<String, dynamic>))
          .toList(),
      createdAt: isarDoc.createdAt,
      updatedAt: isarDoc.updatedAt,
    );
  }
}
