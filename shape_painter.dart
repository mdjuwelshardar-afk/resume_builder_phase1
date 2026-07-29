import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../models/shape_object.dart';

/// [ShapeObject]-কে তার [ShapeKind] অনুযায়ী আঁকে। প্রতিটা শেপের জ্যামিতি
/// object-এর width/height (transform থেকে আসা bounding box) এর ভেতরে
/// আঁকা হয় — rotation transform এই painter-এর বাইরে, widget লেয়ারে হয়।
class ShapePainter extends CustomPainter {
  final ShapeObject shape;

  ShapePainter(this.shape);

  @override
  void paint(Canvas canvas, Size size) {
    final fillPaint = Paint()
      ..color = Color(shape.fillColorArgb)
      ..style = PaintingStyle.fill;

    final strokePaint = shape.strokeColorArgb != null && shape.strokeWidthPx > 0
        ? (Paint()
          ..color = Color(shape.strokeColorArgb!)
          ..style = PaintingStyle.stroke
          ..strokeWidth = shape.strokeWidthPx)
        : null;

    final path = _pathFor(shape.kind, size, shape.cornerRadius, shape.sidesCount);

    canvas.drawPath(path, fillPaint);
    if (strokePaint != null) canvas.drawPath(path, strokePaint);
  }

  Path _pathFor(ShapeKind kind, Size size, double cornerRadius, int sides) {
    final w = size.width;
    final h = size.height;

    switch (kind) {
      case ShapeKind.rectangle:
        return Path()..addRect(Rect.fromLTWH(0, 0, w, h));

      case ShapeKind.roundedRectangle:
        return Path()
          ..addRRect(RRect.fromRectAndRadius(
            Rect.fromLTWH(0, 0, w, h),
            Radius.circular(cornerRadius),
          ));

      case ShapeKind.circle:
        final d = math.min(w, h);
        return Path()
          ..addOval(Rect.fromCenter(
              center: Offset(w / 2, h / 2), width: d, height: d));

      case ShapeKind.oval:
        return Path()..addOval(Rect.fromLTWH(0, 0, w, h));

      case ShapeKind.triangle:
        return Path()
          ..moveTo(w / 2, 0)
          ..lineTo(w, h)
          ..lineTo(0, h)
          ..close();

      case ShapeKind.diamond:
        return Path()
          ..moveTo(w / 2, 0)
          ..lineTo(w, h / 2)
          ..lineTo(w / 2, h)
          ..lineTo(0, h / 2)
          ..close();

      case ShapeKind.line:
        return Path()
          ..moveTo(0, h / 2)
          ..lineTo(w, h / 2);

      case ShapeKind.arrow:
        final path = Path();
        final shaftH = h * 0.4;
        final headW = w * 0.35;
        path.moveTo(0, (h - shaftH) / 2);
        path.lineTo(w - headW, (h - shaftH) / 2);
        path.lineTo(w - headW, 0);
        path.lineTo(w, h / 2);
        path.lineTo(w - headW, h);
        path.lineTo(w - headW, (h + shaftH) / 2);
        path.lineTo(0, (h + shaftH) / 2);
        path.close();
        return path;

      case ShapeKind.star:
        return _starPath(w, h, points: 5);

      case ShapeKind.polygon:
        return _polygonPath(w, h, sides: sides < 3 ? 5 : sides);

      case ShapeKind.heart:
        return _heartPath(w, h);

      case ShapeKind.speechBubble:
        final path = Path()
          ..addRRect(RRect.fromRectAndRadius(
            Rect.fromLTWH(0, 0, w, h * 0.8),
            Radius.circular(cornerRadius),
          ));
        path.moveTo(w * 0.2, h * 0.8);
        path.lineTo(w * 0.15, h);
        path.lineTo(w * 0.4, h * 0.8);
        path.close();
        return path;

      case ShapeKind.curve:
        return Path()
          ..moveTo(0, h)
          ..quadraticBezierTo(w / 2, -h * 0.3, w, h);
    }
  }

  Path _polygonPath(double w, double h, {required int sides}) {
    final path = Path();
    final cx = w / 2;
    final cy = h / 2;
    final radius = math.min(w, h) / 2;
    for (var i = 0; i < sides; i++) {
      final angle = (2 * math.pi * i / sides) - math.pi / 2;
      final point = Offset(cx + radius * math.cos(angle), cy + radius * math.sin(angle));
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    path.close();
    return path;
  }

  Path _starPath(double w, double h, {required int points}) {
    final path = Path();
    final cx = w / 2;
    final cy = h / 2;
    final outerRadius = math.min(w, h) / 2;
    final innerRadius = outerRadius * 0.45;
    final totalPoints = points * 2;
    for (var i = 0; i < totalPoints; i++) {
      final isOuter = i.isEven;
      final radius = isOuter ? outerRadius : innerRadius;
      final angle = (math.pi * i / points) - math.pi / 2;
      final point = Offset(cx + radius * math.cos(angle), cy + radius * math.sin(angle));
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    path.close();
    return path;
  }

  Path _heartPath(double w, double h) {
    final path = Path();
    path.moveTo(w / 2, h * 0.3);
    path.cubicTo(w * 0.1, -h * 0.1, -w * 0.1, h * 0.5, w / 2, h);
    path.cubicTo(w * 1.1, h * 0.5, w * 0.9, -h * 0.1, w / 2, h * 0.3);
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(covariant ShapePainter oldDelegate) {
    return oldDelegate.shape != shape;
  }
}
