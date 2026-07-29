import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../controllers/canvas_controller.dart';
import '../models/page_size.dart';
import 'canvas_object_slot.dart';

/// একটা রেজুমে/ডকুমেন্ট পেজের পুরো ক্যানভাস — বাস্তব কাগজের মতো একটা সাদা
/// পেজ, তার উপর [CanvasController]-এর সব অবজেক্ট z-order অনুযায়ী বসানো।
///
/// এই widget নিজে zoom/pan হ্যান্ডেল করে না — সেটার জন্য এটাকে একটা
/// `InteractiveViewer`-এর ভেতরে বসাতে হবে (হোম/এডিটর স্ক্রিনে), যাতে
/// zoom/pinch আর object drag/resize gesture একে অপরের সাথে conflict না করে।
class CanvasPageView extends ConsumerWidget {
  final PageSizeType pageSizeType;
  final PageOrientation orientation;

  const CanvasPageView({
    super.key,
    this.pageSizeType = PageSizeType.a4,
    this.orientation = PageOrientation.portrait,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editorState = ref.watch(canvasControllerProvider);
    final controller = ref.read(canvasControllerProvider.notifier);
    final dimensions = PageSize.dimensionsFor(pageSizeType, orientation);

    return GestureDetector(
      // পেজের খালি জায়গায় ট্যাপ করলে সিলেকশন ক্লিয়ার হবে।
      onTap: controller.clearSelection,
      child: Container(
        width: dimensions.widthPt,
        height: dimensions.heightPt,
        decoration: BoxDecoration(
          color: AppColors.canvasPageBackground,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.none,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            for (final object in editorState.objectsInDrawOrder)
              CanvasObjectSlot(key: ValueKey(object.id), object: object),
          ],
        ),
      ),
    );
  }
}
