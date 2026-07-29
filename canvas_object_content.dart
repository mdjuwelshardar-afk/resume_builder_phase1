import 'dart:io';
import 'package:flutter/material.dart';

import '../models/canvas_object.dart';
import '../models/text_object.dart';
import '../models/image_object.dart';
import '../models/shape_object.dart';
import '../models/divider_object.dart';
import 'shape_painter.dart';
import 'divider_painter.dart';

/// একটা [CanvasObject]-কে তার concrete টাইপ (Text/Image/Shape/Divider)
/// অনুযায়ী রেন্ডার করে। শুধু "কেমন দেখাবে" তার দায়িত্ব — সিলেকশন আউটলাইন,
/// ড্র্যাগ/রিসাইজ/রোটেট gesture এই widget-এর কাজ না, সেটা
/// `canvas_object_slot.dart`-এ হয়, যাতে এই widget PDF export প্রিভিউ বা
/// থাম্বনেইলেও (যেখানে gesture লাগে না) পুনর্ব্যবহার করা যায়।
class CanvasObjectContent extends StatelessWidget {
  final CanvasObject object;

  const CanvasObjectContent({super.key, required this.object});

  @override
  Widget build(BuildContext context) {
    if (!object.visible) return const SizedBox.shrink();

    final Widget content;
    if (object is TextObject) {
      content = _buildText(object as TextObject);
    } else if (object is ImageObject) {
      content = _buildImage(object as ImageObject);
    } else if (object is ShapeObject) {
      content = _buildShape(object as ShapeObject);
    } else if (object is DividerObject) {
      content = _buildDivider(object as DividerObject);
    } else {
      content = const SizedBox.shrink();
    }

    return Opacity(opacity: object.opacity, child: content);
  }

  Widget _buildText(TextObject o) {
    final decorations = <TextDecoration>[
      if (o.isUnderline) TextDecoration.underline,
      if (o.isStrikethrough) TextDecoration.lineThrough,
    ];

    return Container(
      width: double.infinity,
      height: double.infinity,
      color:
          o.backgroundColorArgb != null ? Color(o.backgroundColorArgb!) : null,
      alignment: _boxAlignmentFor(o.textAlign),
      child: Text(
        o.text,
        textAlign: _textAlignFor(o.textAlign),
        style: TextStyle(
          fontFamily: o.fontFamily,
          fontSize: o.fontSizePt,
          fontWeight: o.isBold ? FontWeight.bold : FontWeight.normal,
          fontStyle: o.isItalic ? FontStyle.italic : FontStyle.normal,
          decoration: decorations.isEmpty
              ? TextDecoration.none
              : TextDecoration.combine(decorations),
          color: Color(o.textColorArgb),
          letterSpacing: o.letterSpacing,
          height: o.lineHeightMultiplier,
        ),
      ),
    );
  }

  Widget _buildImage(ImageObject o) {
    // imageStorageKey আপাতত একটা লোকাল ফাইল-পাথ ধরে নেওয়া হচ্ছে (Phase 1
    // স্কোপ)। Isar blob storage ইন্টিগ্রেশনের পর এখানে repository lookup
    // বসবে — সেটা data layer-এর কাজ, এই widget বদলাতে হবে না যদি
    // ImageProvider resolve করার লজিক একটা ছোট adapter ফাংশনে রাখা হয়।
    final file = File(o.imageStorageKey);
    final image = Image.file(
      file,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Container(
        color: const Color(0xFFE5E7EB),
        alignment: Alignment.center,
        child: const Icon(Icons.image_not_supported_outlined, color: Color(0xFF9CA3AF)),
      ),
    );

    Widget clipped;
    switch (o.cropShape) {
      case ImageCropShape.circle:
      case ImageCropShape.oval:
        clipped = ClipOval(child: image);
        break;
      case ImageCropShape.roundedRectangle:
        clipped = ClipRRect(
          borderRadius: BorderRadius.circular(o.cornerRadius),
          child: image,
        );
        break;
      case ImageCropShape.rectangle:
        clipped = image;
    }

    return Container(
      decoration: BoxDecoration(
        border: o.borderColorArgb != null
            ? Border.all(
                color: Color(o.borderColorArgb!), width: o.borderWidthPx)
            : null,
        boxShadow: o.shadowBlurPx > 0
            ? [BoxShadow(color: Colors.black26, blurRadius: o.shadowBlurPx)]
            : null,
      ),
      child: clipped,
    );
  }

  Widget _buildShape(ShapeObject o) {
    return CustomPaint(
      painter: ShapePainter(o),
      size: Size.infinite,
    );
  }

  Widget _buildDivider(DividerObject o) {
    return CustomPaint(
      painter: DividerPainter(o),
      size: Size.infinite,
    );
  }

  Alignment _boxAlignmentFor(TextAlignment align) {
    switch (align) {
      case TextAlignment.left:
        return Alignment.centerLeft;
      case TextAlignment.center:
        return Alignment.center;
      case TextAlignment.right:
        return Alignment.centerRight;
      case TextAlignment.justify:
        return Alignment.centerLeft;
    }
  }

  TextAlign _textAlignFor(TextAlignment align) {
    switch (align) {
      case TextAlignment.left:
        return TextAlign.left;
      case TextAlignment.center:
        return TextAlign.center;
      case TextAlignment.right:
        return TextAlign.right;
      case TextAlignment.justify:
        return TextAlign.justify;
    }
  }
}
