import 'canvas_transform.dart';
import 'text_object.dart';
import 'image_object.dart';
import 'shape_object.dart';
import 'divider_object.dart';

/// ক্যানভাসে যে ধরনের অবজেক্ট থাকতে পারে।
enum CanvasObjectType { text, image, shape, divider }

/// সব ক্যানভাস অবজেক্টের (Text/Image/Shape/Divider) কমন বেস ক্লাস।
///
/// এই ক্লাসটা abstract — সরাসরি ইনস্ট্যান্স তৈরি হয় না, বরং TextObject,
/// ImageObject, ShapeObject, DividerObject এর মধ্যে দিয়ে ব্যবহার হয়।
/// প্রতিটা সাবক্লাসকে অবশ্যই [toJson] override করতে হবে এবং [copyWithTransform]
/// ও [copyWithBase] ইমপ্লিমেন্ট করতে হবে, যাতে ক্যানভাস ইঞ্জিনের কন্ট্রোলার
/// (drag/resize/rotate/lock/opacity) কোনো নির্দিষ্ট অবজেক্ট টাইপ না জেনেই কাজ করতে পারে।
abstract class CanvasObject {
  final String id;
  final CanvasObjectType type;
  final CanvasTransform transform;
  final double opacity;
  final bool locked;
  final bool visible;

  const CanvasObject({
    required this.id,
    required this.type,
    required this.transform,
    this.opacity = 1.0,
    this.locked = false,
    this.visible = true,
  }) : assert(opacity >= 0 && opacity <= 1,
            'opacity অবশ্যই 0.0 থেকে 1.0 এর মধ্যে হতে হবে');

  /// একই অবজেক্ট, শুধু ট্রান্সফর্ম (position/size/rotation/zIndex) বদলে —
  /// drag/resize/rotate গেসচারের সময় এইটা কল হবে।
  CanvasObject copyWithTransform(CanvasTransform newTransform);

  /// একই অবজেক্ট, শুধু opacity/locked/visible বদলে — টাইপ-নির্দিষ্ট
  /// ফিল্ড (যেমন টেক্সটের ফন্ট) পরিবর্তন করে না।
  CanvasObject copyWithBase({double? opacity, bool? locked, bool? visible});

  Map<String, dynamic> toJson();

  /// JSON থেকে সঠিক সাবক্লাস (Text/Image/Shape/Divider) চিনে নিয়ে অবজেক্ট বানায়।
  /// Isar/Hive থেকে ডেটা লোড করার সময় এইটা ব্যবহার হবে।
  static CanvasObject fromJson(Map<String, dynamic> json) {
    final typeName = json['type'] as String;
    final type = CanvasObjectType.values.byName(typeName);
    switch (type) {
      case CanvasObjectType.text:
        return TextObject.fromJson(json);
      case CanvasObjectType.image:
        return ImageObject.fromJson(json);
      case CanvasObjectType.shape:
        return ShapeObject.fromJson(json);
      case CanvasObjectType.divider:
        return DividerObject.fromJson(json);
    }
  }

  /// বেস ফিল্ডগুলোকে JSON ম্যাপে যোগ করার জন্য হেল্পার — সাবক্লাসগুলো নিজেদের
  /// toJson()-এ এইটা কল করে নিজস্ব ফিল্ড যোগ করে।
  Map<String, dynamic> baseToJson() => {
        'id': id,
        'type': type.name,
        'transform': transform.toJson(),
        'opacity': opacity,
        'locked': locked,
        'visible': visible,
      };
}
