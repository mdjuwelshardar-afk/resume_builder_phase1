import '../../../../shared/canvas_engine/models/canvas_object.dart';
import '../../../../shared/canvas_engine/models/page_size.dart';
import 'profile_section.dart';
import 'resume_sections.dart';

/// একটা সম্পূর্ণ রেজুমে ডকুমেন্ট — এটাই Isar-এ সেভ হয় এবং PDF export-এর ইনপুট।
///
/// দুই স্তরের ডেটা একসাথে রাখা হয়েছে ইচ্ছাকৃতভাবে:
/// ১. [canvasObjects] — ভিজুয়াল লেআউট (position/style সহ, ইউজার যা টেনে
///    সরিয়েছে/এডিট করেছে) — এটাই সরাসরি রেন্ডার ও PDF export হয়।
/// ২. [profile]/[education]/[experience]/[skills] — কাঠামোবদ্ধ ডেটা, যাতে
///    ইউজার একটা টেমপ্লেট থেকে আরেকটায় সুইচ করলে (Phase 1 এর পরে আসবে)
///    বা ATS Checker/AI ফিচার (Phase 4) ব্যবহার করলে তথ্য পুনর্ব্যবহার করা যায়,
///    শুধু ক্যানভাসের ফ্রি-ফর্ম টেক্সট থেকে আবার পার্স করতে না হয়।
class ResumeDocument {
  final String id;
  final String title;
  final String? templateId;
  final PageSizeType pageSizeType;
  final PageOrientation orientation;
  final List<CanvasObject> canvasObjects;
  final ProfileSection? profile;
  final List<EducationEntry> education;
  final List<ExperienceEntry> experience;
  final List<SkillEntry> skills;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ResumeDocument({
    required this.id,
    required this.title,
    this.templateId,
    this.pageSizeType = PageSizeType.a4,
    this.orientation = PageOrientation.portrait,
    this.canvasObjects = const [],
    this.profile,
    this.education = const [],
    this.experience = const [],
    this.skills = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  ResumeDocument copyWith({
    String? title,
    String? templateId,
    PageSizeType? pageSizeType,
    PageOrientation? orientation,
    List<CanvasObject>? canvasObjects,
    ProfileSection? profile,
    List<EducationEntry>? education,
    List<ExperienceEntry>? experience,
    List<SkillEntry>? skills,
    DateTime? updatedAt,
  }) {
    return ResumeDocument(
      id: id,
      title: title ?? this.title,
      templateId: templateId ?? this.templateId,
      pageSizeType: pageSizeType ?? this.pageSizeType,
      orientation: orientation ?? this.orientation,
      canvasObjects: canvasObjects ?? this.canvasObjects,
      profile: profile ?? this.profile,
      education: education ?? this.education,
      experience: experience ?? this.experience,
      skills: skills ?? this.skills,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}
