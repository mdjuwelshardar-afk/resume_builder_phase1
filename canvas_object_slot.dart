import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../controllers/canvas_controller.dart';
import '../models/canvas_object.dart';
import 'canvas_object_content.dart';

/// ক্যানভাসে একটা অবজেক্ট বসানো, ট্যাপ করে সিলেক্ট করা, টেনে সরানো —
/// এই সবকিছুর জন্য দায়ী। প্রকৃত "কেমন দেখাবে" এর দায়িত্ব [CanvasObjectContent]-এর।
///
/// ⚠️ বর্তমান সীমাবদ্ধতা (পরের ধাপে ঠিক হবে): শুধু bottom-right কর্নার হ্যান্ডেল
/// দিয়ে রিসাইজ করা যায় (৮-দিকের হ্যান্ডেল না), এবং রোটেট করা অবস্থায়
/// রিসাইজ হ্যান্ডেলের দিক (axis) ঠিকমতো সমন্বয় হয় না — এটা PROJECT_CONTEXT.md
/// এ noted আছে, "সম্পূর্ণ" বলে দাবি করা হয়নি।
class CanvasObjectSlot extends ConsumerWidget {
  final CanvasObject object;

  const CanvasObjectSlot({super.key, required this.object});

  static const double _handleSize = 18;
  static const double _rotateHandleOffset = 32;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(canvasControllerProvider.notifier);
    final isSelected =
        ref.watch(canvasControllerProvider).selectedObjectId == object.id;
    final t = object.transform;

    return Positioned(
      left: t.x,
      top: t.y,
      width: t.width,
      height: t.height,
      child: Transform.rotate(
        angle: t.rotationDegrees * math.pi / 180,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => controller.selectObject(object.id),
          onPanStart: (_) => controller.selectObject(object.id),
          onPanUpdate: (details) {
            if (object.locked) return;
            controller.moveObjectBy(object.id, details.delta);
          },
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              RepaintBoundary(child: CanvasObjectContent(object: object)),
              if (isSelected) _selectionOutline(),
              if (isSelected && !object.locked) ..._handles(controller),
            ],
          ),
        ),
      ),
    );
  }

  Widget _selectionOutline() {
    return Positioned.fill(
      child: IgnorePointer(
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.canvasSelectionOutline,
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _handles(CanvasController controller) {
    return [
      // bottom-right resize handle
      Positioned(
        right: -_handleSize / 2,
        bottom: -_handleSize / 2,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onPanUpdate: (details) {
            final t = object.transform;
            controller.resizeObjectTo(
              object.id,
              width: t.width + details.delta.dx,
              height: t.height + details.delta.dy,
            );
          },
          child: _handleDot(),
        ),
      ),
      // rotate handle — উপরের মাঝ বরাবর, একটু উপরে ভাসমান
      Positioned(
        top: -_rotateHandleOffset,
        left: 0,
        right: 0,
        child: Center(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onPanUpdate: (details) {
              final t = object.transform;
              final center = Offset(t.width / 2, t.height / 2);
              // হ্যান্ডেলের local পজিশন থেকে অবজেক্ট-কেন্দ্রের দিকে vector
              // ধরে atan2 দিয়ে নতুন কোণ বের করা হচ্ছে।
              final localPoint =
                  Offset(t.width / 2, -_rotateHandleOffset) + details.delta;
              final angleRad =
                  math.atan2(localPoint.dx - center.dx, center.dy - localPoint.dy);
              final degrees = angleRad * 180 / math.pi;
              controller.rotateObjectTo(object.id, degrees);
            },
            child: _handleDot(icon: Icons.rotate_right, filled: true),
          ),
        ),
      ),
    ];
  }

  Widget _handleDot({IconData? icon, bool filled = false}) {
    return Container(
      width: _handleSize,
      height: _handleSize,
      decoration: BoxDecoration(
        color: filled ? AppColors.canvasSelectionOutline : Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.canvasSelectionOutline, width: 1.5),
      ),
      child: icon != null
          ? Icon(icon, size: 12, color: filled ? Colors.white : AppColors.canvasSelectionOutline)
          : null,
    );
  }
}
