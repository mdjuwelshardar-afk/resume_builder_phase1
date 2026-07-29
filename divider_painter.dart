import 'package:flutter/material.dart';

import '../models/divider_object.dart';

/// [DividerObject]-কে আঁকে — object-এর height-কে লাইনের thickness হিসেবে
/// ধরা হয় না (thickness আলাদা ফিল্ড), বরং width জুড়ে object-এর height-এর
/// মাঝ বরাবর একটা অনুভূমিক লাইন আঁকা হয়। ভার্টিক্যাল ডিভাইডার দরকার হলে
/// ব্যবহারকারী object-টা ৯০° রোটেট করবে (rotation transform অটোমেটিক আসবে)।
class DividerPainter extends CustomPainter {
  final DividerObject divider;

  DividerPainter(this.divider);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(divider.colorArgb)
      ..strokeWidth = divider.thicknessPx
      ..strokeCap = StrokeCap.round;

    final y = size.height / 2;
    final start = Offset(0, y);
    final end = Offset(size.width, y);

    if (!divider.isDashed) {
      canvas.drawLine(start, end, paint);
      return;
    }

    const dashWidth = 6.0;
    const dashGap = 4.0;
    var currentX = 0.0;
    while (currentX < size.width) {
      final segmentEnd = (currentX + dashWidth).clamp(0.0, size.width);
      canvas.drawLine(Offset(currentX, y), Offset(segmentEnd, y), paint);
      currentX += dashWidth + dashGap;
    }
  }

  @override
  bool shouldRepaint(covariant DividerPainter oldDelegate) {
    return oldDelegate.divider != divider;
  }
}
