import 'canvas_object.dart';
import 'canvas_transform.dart';

enum ImageCropShape { rectangle, roundedRectangle, circle, oval }

/// প্রোফাইল ফটো, লোগো, সিগনেচার ইত্যাদির জন্য ইমেজ অবজেক্ট।
///
/// [imageStorageKey] আসল ইমেজ বাইট ধরে না — বরং Isar-এ সংরক্ষিত ইমেজ ব্লবের
/// একটা রেফারেন্স key/path রাখে। এতে ক্যানভাস state (undo/redo, autosave)
/// হালকা থাকে এবং বড় ইমেজ বারবার copy হয় না।
class ImageObject extends CanvasObject {
  final String imageStorageKey;
  final ImageCropShape cropShape;
  final double cornerRadius; // roundedRectangle এর জন্য
  final int? borderColorArgb;
  final double borderWidthPx;
  final double shadowBlurPx;
  final double brightness; // -1.0 থেকে 1.0, 0 = অপরিবর্তিত
  final double contrast; // -1.0 থেকে 1.0
  final double saturation; // -1.0 থেকে 1.0

  const ImageObject({
    required super.id,
    required super.transform,
    required this.imageStorageKey,
    this.cropShape = ImageCropShape.rectangle,
    this.cornerRadius = 0,
    this.borderColorArgb,
    this.borderWidthPx = 0,
    this.shadowBlurPx = 0,
    this.brightness = 0,
    this.contrast = 0,
    this.saturation = 0,
    super.opacity,
    super.locked,
    super.visible,
  }) : super(type: CanvasObjectType.image);

  ImageObject copyWithFields({
    String? imageStorageKey,
    ImageCropShape? cropShape,
    double? cornerRadius,
    int? borderColorArgb,
    double? borderWidthPx,
    double? shadowBlurPx,
    double? brightness,
    double? contrast,
    double? saturation,
  }) {
    return ImageObject(
      id: id,
      transform: transform,
      imageStorageKey: imageStorageKey ?? this.imageStorageKey,
      cropShape: cropShape ?? this.cropShape,
      cornerRadius: cornerRadius ?? this.cornerRadius,
      borderColorArgb: borderColorArgb ?? this.borderColorArgb,
      borderWidthPx: borderWidthPx ?? this.borderWidthPx,
      shadowBlurPx: shadowBlurPx ?? this.shadowBlurPx,
      brightness: brightness ?? this.brightness,
      contrast: contrast ?? this.contrast,
      saturation: saturation ?? this.saturation,
      opacity: opacity,
      locked: locked,
      visible: visible,
    );
  }

  @override
  ImageObject copyWithTransform(CanvasTransform newTransform) {
    return ImageObject(
      id: id,
      transform: newTransform,
      imageStorageKey: imageStorageKey,
      cropShape: cropShape,
      cornerRadius: cornerRadius,
      borderColorArgb: borderColorArgb,
      borderWidthPx: borderWidthPx,
      shadowBlurPx: shadowBlurPx,
      brightness: brightness,
      contrast: contrast,
      saturation: saturation,
      opacity: opacity,
      locked: locked,
      visible: visible,
    );
  }

  @override
  ImageObject copyWithBase({double? opacity, bool? locked, bool? visible}) {
    return ImageObject(
      id: id,
      transform: transform,
      imageStorageKey: imageStorageKey,
      cropShape: cropShape,
      cornerRadius: cornerRadius,
      borderColorArgb: borderColorArgb,
      borderWidthPx: borderWidthPx,
      shadowBlurPx: shadowBlurPx,
      brightness: brightness,
      contrast: contrast,
      saturation: saturation,
      opacity: opacity ?? this.opacity,
      locked: locked ?? this.locked,
      visible: visible ?? this.visible,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        ...baseToJson(),
        'imageStorageKey': imageStorageKey,
        'cropShape': cropShape.name,
        'cornerRadius': cornerRadius,
        'borderColorArgb': borderColorArgb,
        'borderWidthPx': borderWidthPx,
        'shadowBlurPx': shadowBlurPx,
        'brightness': brightness,
        'contrast': contrast,
        'saturation': saturation,
      };

  factory ImageObject.fromJson(Map<String, dynamic> json) {
    return ImageObject(
      id: json['id'] as String,
      transform:
          CanvasTransform.fromJson(json['transform'] as Map<String, dynamic>),
      imageStorageKey: json['imageStorageKey'] as String,
      cropShape: ImageCropShape.values
          .byName(json['cropShape'] as String? ?? 'rectangle'),
      cornerRadius: (json['cornerRadius'] as num?)?.toDouble() ?? 0,
      borderColorArgb: (json['borderColorArgb'] as num?)?.toInt(),
      borderWidthPx: (json['borderWidthPx'] as num?)?.toDouble() ?? 0,
      shadowBlurPx: (json['shadowBlurPx'] as num?)?.toDouble() ?? 0,
      brightness: (json['brightness'] as num?)?.toDouble() ?? 0,
      contrast: (json['contrast'] as num?)?.toDouble() ?? 0,
      saturation: (json['saturation'] as num?)?.toDouble() ?? 0,
      opacity: (json['opacity'] as num?)?.toDouble() ?? 1.0,
      locked: json['locked'] as bool? ?? false,
      visible: json['visible'] as bool? ?? true,
    );
  }
}
