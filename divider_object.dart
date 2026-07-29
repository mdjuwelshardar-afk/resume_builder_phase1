import 'canvas_object.dart';
import 'canvas_transform.dart';

/// রেজুমের সেকশনগুলো (যেমন Experience আর Education) আলাদা করার জন্য
/// ব্যবহৃত সরল লাইন/ডিভাইডার অবজেক্ট।
class DividerObject extends CanvasObject {
  final int colorArgb;
  final double thicknessPx;
  final bool isDashed;

  const DividerObject({
    required super.id,
    required super.transform,
    this.colorArgb = 0xFFD1D5DB,
    this.thicknessPx = 1.5,
    this.isDashed = false,
    super.opacity,
    super.locked,
    super.visible,
  }) : super(type: CanvasObjectType.divider);

  DividerObject copyWithFields({
    int? colorArgb,
    double? thicknessPx,
    bool? isDashed,
  }) {
    return DividerObject(
      id: id,
      transform: transform,
      colorArgb: colorArgb ?? this.colorArgb,
      thicknessPx: thicknessPx ?? this.thicknessPx,
      isDashed: isDashed ?? this.isDashed,
      opacity: opacity,
      locked: locked,
      visible: visible,
    );
  }

  @override
  DividerObject copyWithTransform(CanvasTransform newTransform) {
    return DividerObject(
      id: id,
      transform: newTransform,
      colorArgb: colorArgb,
      thicknessPx: thicknessPx,
      isDashed: isDashed,
      opacity: opacity,
      locked: locked,
      visible: visible,
    );
  }

  @override
  DividerObject copyWithBase({double? opacity, bool? locked, bool? visible}) {
    return DividerObject(
      id: id,
      transform: transform,
      colorArgb: colorArgb,
      thicknessPx: thicknessPx,
      isDashed: isDashed,
      opacity: opacity ?? this.opacity,
      locked: locked ?? this.locked,
      visible: visible ?? this.visible,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        ...baseToJson(),
        'colorArgb': colorArgb,
        'thicknessPx': thicknessPx,
        'isDashed': isDashed,
      };

  factory DividerObject.fromJson(Map<String, dynamic> json) {
    return DividerObject(
      id: json['id'] as String,
      transform:
          CanvasTransform.fromJson(json['transform'] as Map<String, dynamic>),
      colorArgb: (json['colorArgb'] as num?)?.toInt() ?? 0xFFD1D5DB,
      thicknessPx: (json['thicknessPx'] as num?)?.toDouble() ?? 1.5,
      isDashed: json['isDashed'] as bool? ?? false,
      opacity: (json['opacity'] as num?)?.toDouble() ?? 1.0,
      locked: json['locked'] as bool? ?? false,
      visible: json['visible'] as bool? ?? true,
    );
  }
}
