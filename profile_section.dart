/// রেজুমের সবার উপরের প্রোফাইল অংশ — নাম, হেডলাইন, যোগাযোগের তথ্য।
/// এটা ক্যানভাস অবজেক্ট না — বরং "ডেটা" যেটা থেকে টেমপ্লেট ক্যানভাস
/// অবজেক্ট বানায় (TextObject, ImageObject)। এভাবে ইউজার একবার প্রোফাইল
/// পূরণ করলে বিভিন্ন টেমপ্লেটে (ভিন্ন লেআউটে) একই ডেটা বসানো যায়।
class ProfileSection {
  final String fullName;
  final String? headline;
  final String? photoStorageKey;
  final String? phone;
  final String? email;
  final String? address;
  final String? website;
  final String? linkedIn;
  final String? github;

  const ProfileSection({
    required this.fullName,
    this.headline,
    this.photoStorageKey,
    this.phone,
    this.email,
    this.address,
    this.website,
    this.linkedIn,
    this.github,
  });

  ProfileSection copyWith({
    String? fullName,
    String? headline,
    String? photoStorageKey,
    String? phone,
    String? email,
    String? address,
    String? website,
    String? linkedIn,
    String? github,
  }) {
    return ProfileSection(
      fullName: fullName ?? this.fullName,
      headline: headline ?? this.headline,
      photoStorageKey: photoStorageKey ?? this.photoStorageKey,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      website: website ?? this.website,
      linkedIn: linkedIn ?? this.linkedIn,
      github: github ?? this.github,
    );
  }

  Map<String, dynamic> toJson() => {
        'fullName': fullName,
        'headline': headline,
        'photoStorageKey': photoStorageKey,
        'phone': phone,
        'email': email,
        'address': address,
        'website': website,
        'linkedIn': linkedIn,
        'github': github,
      };

  factory ProfileSection.fromJson(Map<String, dynamic> json) {
    return ProfileSection(
      fullName: json['fullName'] as String? ?? '',
      headline: json['headline'] as String?,
      photoStorageKey: json['photoStorageKey'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      address: json['address'] as String?,
      website: json['website'] as String?,
      linkedIn: json['linkedIn'] as String?,
      github: json['github'] as String?,
    );
  }
}
