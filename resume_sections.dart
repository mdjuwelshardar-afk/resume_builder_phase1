/// রেজুমের "Education" সেকশনের একটা এন্ট্রি (একটা ডিগ্রি/প্রতিষ্ঠান)।
class EducationEntry {
  final String institutionName;
  final String degreeName;
  final String? fieldOfStudy;
  final String? startDate; // ফ্রি-টেক্সট রাখা হয়েছে (যেমন "জানুয়ারি ২০২০"), ইউজার নিজের ফরম্যাটে লিখতে পারবে
  final String? endDate; // null বা "চলমান" মানে বর্তমানে অধ্যয়নরত
  final String? description;

  const EducationEntry({
    required this.institutionName,
    required this.degreeName,
    this.fieldOfStudy,
    this.startDate,
    this.endDate,
    this.description,
  });

  Map<String, dynamic> toJson() => {
        'institutionName': institutionName,
        'degreeName': degreeName,
        'fieldOfStudy': fieldOfStudy,
        'startDate': startDate,
        'endDate': endDate,
        'description': description,
      };

  factory EducationEntry.fromJson(Map<String, dynamic> json) {
    return EducationEntry(
      institutionName: json['institutionName'] as String? ?? '',
      degreeName: json['degreeName'] as String? ?? '',
      fieldOfStudy: json['fieldOfStudy'] as String?,
      startDate: json['startDate'] as String?,
      endDate: json['endDate'] as String?,
      description: json['description'] as String?,
    );
  }
}

/// রেজুমের "Experience" সেকশনের একটা এন্ট্রি (একটা চাকরি/ইন্টার্নশিপ)।
class ExperienceEntry {
  final String companyName;
  final String jobTitle;
  final String? location;
  final String? startDate;
  final String? endDate;
  final List<String> responsibilities; // বুলেট পয়েন্ট আকারে

  const ExperienceEntry({
    required this.companyName,
    required this.jobTitle,
    this.location,
    this.startDate,
    this.endDate,
    this.responsibilities = const [],
  });

  Map<String, dynamic> toJson() => {
        'companyName': companyName,
        'jobTitle': jobTitle,
        'location': location,
        'startDate': startDate,
        'endDate': endDate,
        'responsibilities': responsibilities,
      };

  factory ExperienceEntry.fromJson(Map<String, dynamic> json) {
    return ExperienceEntry(
      companyName: json['companyName'] as String? ?? '',
      jobTitle: json['jobTitle'] as String? ?? '',
      location: json['location'] as String?,
      startDate: json['startDate'] as String?,
      endDate: json['endDate'] as String?,
      responsibilities: (json['responsibilities'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );
  }
}

/// দক্ষতার মাত্রা — ATS Checker (Phase 4) এবং স্কিল-বার ডিজাইনের জন্য দরকার হবে।
enum SkillProficiency { beginner, intermediate, advanced, expert }

/// রেজুমের "Skills" সেকশনের একটা এন্ট্রি।
class SkillEntry {
  final String name;
  final SkillProficiency proficiency;

  const SkillEntry({
    required this.name,
    this.proficiency = SkillProficiency.intermediate,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'proficiency': proficiency.name,
      };

  factory SkillEntry.fromJson(Map<String, dynamic> json) {
    return SkillEntry(
      name: json['name'] as String? ?? '',
      proficiency: SkillProficiency.values
          .byName(json['proficiency'] as String? ?? 'intermediate'),
    );
  }
}
