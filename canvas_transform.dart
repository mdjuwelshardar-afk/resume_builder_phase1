/// ক্যানভাসের প্রতিটা অবজেক্টের (Text/Image/Shape/Divider) অবস্থান, আকার,
/// ঘোরানোর কোণ এবং স্তর (z-index) — এই সবকিছু এখানে থাকে।
///
/// এককগুলো "লজিক্যাল পিক্সেল" এককে — অর্থাৎ A4 পেজকে একটা নির্দিষ্ট প্রস্থ/উচ্চতায়
/// (যেমন 595 x 842, পয়েন্ট এককে) ম্যাপ করে সব হিসাব করা হয়, স্ক্রিন ডিভাইসের
/// আসল পিক্সেলের উপর নির্ভর করে না — এতে বিভিন্ন স্ক্রিন সাইজে ক্যানভাস একইভাবে দেখাবে।
class CanvasTransform {
  final double x;
  final double y;
  final double width;
  final double height;
  final double rotationDegrees;
  final int zIndex;

  const CanvasTransform({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    this.rotationDegrees = 0,
    this.zIndex = 0,
  });

  CanvasTransform copyWith({
    double? x,
    double? y,
    double? width,
    double? height,
    double? rotationDegrees,
    int? zIndex,
  }) {
    return CanvasTransform(
      x: x ?? this.x,
      y: y ?? this.y,
      width: width ?? this.width,
      height: height ?? this.height,
      rotationDegrees: rotationDegrees ?? this.rotationDegrees,
      zIndex: zIndex ?? this.zIndex,
    );
  }

  Map<String, dynamic> toJson() => {
        'x': x,
        'y': y,
        'width': width,
        'height': height,
        'rotationDegrees': rotationDegrees,
        'zIndex': zIndex,
      };

  factory CanvasTransform.fromJson(Map<String, dynamic> json) {
    return CanvasTransform(
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
      width: (json['width'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
      rotationDegrees: (json['rotationDegrees'] as num?)?.toDouble() ?? 0,
      zIndex: (json['zIndex'] as num?)?.toInt() ?? 0,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CanvasTransform &&
          runtimeType == other.runtimeType &&
          x == other.x &&
          y == other.y &&
          width == other.width &&
          height == other.height &&
          rotationDegrees == other.rotationDegrees &&
          zIndex == other.zIndex;

  @override
  int get hashCode =>
      Object.hash(x, y, width, height, rotationDegrees, zIndex);
}
