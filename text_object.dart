import 'canvas_object.dart';
import 'canvas_transform.dart';

enum TextAlignment { left, center, right, justify }

/// রেজুমে/কভার লেটার ইত্যাদিতে ব্যবহৃত টেক্সট অবজেক্ট।
///
/// রং `ARGB int` ফরম্যাটে রাখা হয়েছে (যেমন Flutter-এর `Color.value`), যাতে এই
/// ডোমেইন মডেলটা `dart:ui`/Flutter-এর উপর নির্ভরশীল না হয় — প্রেজেন্টেশন লেয়ারে
/// গিয়ে এই int কে `Color(argb)` দিয়ে সহজেই রূপান্তর করা যাবে।
class TextObject extends CanvasObject {
  final String text;
  final String fontFamily;
  final double fontSizePt;
  final bool isBold;
  final bool isItalic;
  final bool isUnderline;
  final bool isStrikethrough;
  final int textColorArgb;
  final int? backgroundColorArgb; // null মানে ব্যাকগ্রাউন্ড নেই (transparent)
  final TextAlignment textAlign;
  final double letterSpacing;
  final double lineHeightMultiplier; // 1.0 = normal
  final String? hyperlink;

  const TextObject({
    required super.id,
    required super.transform,
    required this.text,
    this.fontFamily = 'NotoSansBengali',
    this.fontSizePt = 12,
    this.isBold = false,
    this.isItalic = false,
    this.isUnderline = false,
    this.isStrikethrough = false,
    this.textColorArgb = 0xFF000000,
    this.backgroundColorArgb,
    this.textAlign = TextAlignment.left,
    this.letterSpacing = 0,
    this.lineHeightMultiplier = 1.2,
    this.hyperlink,
    super.opacity,
    super.locked,
    super.visible,
  }) : super(type: CanvasObjectType.text);

  TextObject copyWithFields({
    String? text,
    String? fontFamily,
    double? fontSizePt,
    bool? isBold,
    bool? isItalic,
    bool? isUnderline,
    bool? isStrikethrough,
    int? textColorArgb,
    int? backgroundColorArgb,
    TextAlignment? textAlign,
    double? letterSpacing,
    double? lineHeightMultiplier,
    String? hyperlink,
  }) {
    return TextObject(
      id: id,
      transform: transform,
      text: text ?? this.text,
      fontFamily: fontFamily ?? this.fontFamily,
      fontSizePt: fontSizePt ?? this.fontSizePt,
      isBold: isBold ?? this.isBold,
      isItalic: isItalic ?? this.isItalic,
      isUnderline: isUnderline ?? this.isUnderline,
      isStrikethrough: isStrikethrough ?? this.isStrikethrough,
      textColorArgb: textColorArgb ?? this.textColorArgb,
      backgroundColorArgb: backgroundColorArgb ?? this.backgroundColorArgb,
      textAlign: textAlign ?? this.textAlign,
      letterSpacing: letterSpacing ?? this.letterSpacing,
      lineHeightMultiplier: lineHeightMultiplier ?? this.lineHeightMultiplier,
      hyperlink: hyperlink ?? this.hyperlink,
      opacity: opacity,
      locked: locked,
      visible: visible,
    );
  }

  @override
  TextObject copyWithTransform(CanvasTransform newTransform) {
    return TextObject(
      id: id,
      transform: newTransform,
      text: text,
      fontFamily: fontFamily,
      fontSizePt: fontSizePt,
      isBold: isBold,
      isItalic: isItalic,
      isUnderline: isUnderline,
      isStrikethrough: isStrikethrough,
      textColorArgb: textColorArgb,
      backgroundColorArgb: backgroundColorArgb,
      textAlign: textAlign,
      letterSpacing: letterSpacing,
      lineHeightMultiplier: lineHeightMultiplier,
      hyperlink: hyperlink,
      opacity: opacity,
      locked: locked,
      visible: visible,
    );
  }

  @override
  TextObject copyWithBase({double? opacity, bool? locked, bool? visible}) {
    return TextObject(
      id: id,
      transform: transform,
      text: text,
      fontFamily: fontFamily,
      fontSizePt: fontSizePt,
      isBold: isBold,
      isItalic: isItalic,
      isUnderline: isUnderline,
      isStrikethrough: isStrikethrough,
      textColorArgb: textColorArgb,
      backgroundColorArgb: backgroundColorArgb,
      textAlign: textAlign,
      letterSpacing: letterSpacing,
      lineHeightMultiplier: lineHeightMultiplier,
      hyperlink: hyperlink,
      opacity: opacity ?? this.opacity,
      locked: locked ?? this.locked,
      visible: visible ?? this.visible,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        ...baseToJson(),
        'text': text,
        'fontFamily': fontFamily,
        'fontSizePt': fontSizePt,
        'isBold': isBold,
        'isItalic': isItalic,
        'isUnderline': isUnderline,
        'isStrikethrough': isStrikethrough,
        'textColorArgb': textColorArgb,
        'backgroundColorArgb': backgroundColorArgb,
        'textAlign': textAlign.name,
        'letterSpacing': letterSpacing,
        'lineHeightMultiplier': lineHeightMultiplier,
        'hyperlink': hyperlink,
      };

  factory TextObject.fromJson(Map<String, dynamic> json) {
    return TextObject(
      id: json['id'] as String,
      transform:
          CanvasTransform.fromJson(json['transform'] as Map<String, dynamic>),
      text: json['text'] as String,
      fontFamily: json['fontFamily'] as String? ?? 'NotoSansBengali',
      fontSizePt: (json['fontSizePt'] as num?)?.toDouble() ?? 12,
      isBold: json['isBold'] as bool? ?? false,
      isItalic: json['isItalic'] as bool? ?? false,
      isUnderline: json['isUnderline'] as bool? ?? false,
      isStrikethrough: json['isStrikethrough'] as bool? ?? false,
      textColorArgb: (json['textColorArgb'] as num?)?.toInt() ?? 0xFF000000,
      backgroundColorArgb: (json['backgroundColorArgb'] as num?)?.toInt(),
      textAlign: TextAlignment.values
          .byName(json['textAlign'] as String? ?? 'left'),
      letterSpacing: (json['letterSpacing'] as num?)?.toDouble() ?? 0,
      lineHeightMultiplier:
          (json['lineHeightMultiplier'] as num?)?.toDouble() ?? 1.2,
      hyperlink: json['hyperlink'] as String?,
      opacity: (json['opacity'] as num?)?.toDouble() ?? 1.0,
      locked: json['locked'] as bool? ?? false,
      visible: json['visible'] as bool? ?? true,
    );
  }
}
