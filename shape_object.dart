import 'canvas_object.dart';
import 'canvas_transform.dart';

enum ShapeKind {
  rectangle,
  roundedRectangle,
  circle,
  oval,
  triangle,
  arrow,
  star,
  polygon,
  diamond,
  heart,
  speechBubble,
  line,
  curve,
}

/// রেজুমে ডিজাইনে ডেকোরেশন/ডিভাইডার হিসেবে ব্যবহৃত শেপ অবজেক্ট
/// (রেক্টাঙ্গেল, বৃত্ত, তারা, তীর ইত্যাদি)।
class ShapeObject extends CanvasObject {
  final ShapeKind kind;
  final int fillColorArgb;
  final int? strokeColorArgb;
  final double strokeWidthPx;
  final double cornerRadius; // শুধু roundedRectangle এর জন্য
  final int sidesCount; // শুধু polygon এর জন্য (যেমন pentagon = 5)

  const ShapeObject({
    required super.id,
    required super.transform,
    required this.kind,
    this.fillColorArgb = 0xFF2563EB,
    this.strokeColorArgb,
    this.strokeWidthPx = 0,
    this.cornerRadius = 8,
    this.sidesCount = 5,
    super.opacity,
    super.locked,
    super.visible,
  }) : super(type: CanvasObjectType.shape);

  ShapeObject copyWithFields({
    ShapeKind? kind,
    int? fillColorArgb,
    int? strokeColorArgb,
    double? strokeWidthPx,
    double? cornerRadius,
    int? sidesCount,
  }) {
    return ShapeObject(
      id: id,
      transform: transform,
      kind: kind ?? this.kind,
      fillColorArgb: fillColorArgb ?? this.fillColorArgb,
      strokeColorArgb: strokeColorArgb ?? this.strokeColorArgb,
      strokeWidthPx: strokeWidthPx ?? this.strokeWidthPx,
      cornerRadius: cornerRadius ?? this.cornerRadius,
      sidesCount: sidesCount ?? this.sidesCount,
      opacity: opacity,
      locked: locked,
      visible: visible,
    );
  }

  @override
  ShapeObject copyWithTransform(CanvasTransform newTransform) {
    return ShapeObject(
      id: id,
      transform: newTransform,
      kind: kind,
      fillColorArgb: fillColorArgb,
      strokeColorArgb: strokeColorArgb,
      strokeWidthPx: strokeWidthPx,
      cornerRadius: cornerRadius,
      sidesCount: sidesCount,
      opacity: opacity,
      locked: locked,
      visible: visible,
    );
  }

  @override
  ShapeObject copyWithBase({double? opacity, bool? locked, bool? visible}) {
    return ShapeObject(
      id: id,
      transform: transform,
      kind: kind,
      fillColorArgb: fillColorArgb,
      strokeColorArgb: strokeColorArgb,
      strokeWidthPx: strokeWidthPx,
      cornerRadius: cornerRadius,
      sidesCount: sidesCount,
      opacity: opacity ?? this.opacity,
      locked: locked ?? this.locked,
      visible: visible ?? this.visible,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        ...baseToJson(),
        'kind': kind.name,
        'fillColorArgb': fillColorArgb,
        'strokeColorArgb': strokeColorArgb,
        'strokeWidthPx': strokeWidthPx,
        'cornerRadius': cornerRadius,
        'sidesCount': sidesCount,
      };

  factory ShapeObject.fromJson(Map<String, dynamic> json) {
    return ShapeObject(
      id: json['id'] as String,
      transform:
          CanvasTransform.fromJson(json['transform'] as Map<String, dynamic>),
      kind: ShapeKind.values.byName(json['kind'] as String? ?? 'rectangle'),
      fillColorArgb: (json['fillColorArgb'] as num?)?.toInt() ?? 0xFF2563EB,
      strokeColorArgb: (json['strokeColorArgb'] as num?)?.toInt(),
      strokeWidthPx: (json['strokeWidthPx'] as num?)?.toDouble() ?? 0,
      cornerRadius: (json['cornerRadius'] as num?)?.toDouble() ?? 8,
      sidesCount: (json['sidesCount'] as num?)?.toInt() ?? 5,
      opacity: (json['opacity'] as num?)?.toDouble() ?? 1.0,
      locked: json['locked'] as bool? ?? false,
      visible: json['visible'] as bool? ?? true,
    );
  }
}
