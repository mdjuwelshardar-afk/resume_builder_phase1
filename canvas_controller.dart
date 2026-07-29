import 'package:flutter/material.dart' show Offset;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/canvas_object.dart';
import '../models/canvas_transform.dart';
import 'canvas_editor_state.dart';

/// একটা রেজুমে/ডকুমেন্ট পেজের ক্যানভাসে সব ইন্টারঅ্যাকশন (সিলেক্ট করা, টেনে
/// সরানো, রিসাইজ, রোটেট, লক/আনলক, অপাসিটি, লেয়ার-অর্ডার) এই কন্ট্রোলার
/// দিয়ে হয়। এটা কোনো নির্দিষ্ট অবজেক্ট টাইপ (Text/Image/Shape) সম্পর্কে
/// জানে না — CanvasObject-এর abstract copyWithTransform/copyWithBase
/// মেথডের মাধ্যমেই কাজ করে, তাই নতুন অবজেক্ট টাইপ যোগ হলেও এই কন্ট্রোলার
/// পরিবর্তন করতে হবে না।
///
/// note: `riverpod_generator`/`@riverpod` কোডজেন এড়ানো হয়েছে ইচ্ছাকৃতভাবে —
/// এই ফাইলটা `build_runner` ছাড়াই (তাই এখানে কোনো *.g.dart লাগবে না) কম্পাইল
/// হওয়ার কথা, যেটা এই পর্যায়ে (কোডজেন রান করার সুযোগ না থাকা অবস্থায়)
/// নিরাপদ। পরে ইচ্ছা করলে `@riverpod` annotation-এ মাইগ্রেট করা যাবে।
class CanvasController extends StateNotifier<CanvasEditorState> {
  CanvasController() : super(const CanvasEditorState());

  // ---------------- অবজেক্ট যোগ/মুছা ----------------

  void addObject(CanvasObject object) {
    state = state.copyWith(objects: [...state.objects, object]);
  }

  void removeObject(String objectId) {
    final updated = state.objects.where((o) => o.id != objectId).toList();
    final stillSelected =
        state.selectedObjectId == objectId ? null : state.selectedObjectId;
    state = CanvasEditorState(
      objects: updated,
      selectedObjectId: stillSelected,
    );
  }

  // ---------------- সিলেকশন ----------------

  void selectObject(String? objectId) {
    state = CanvasEditorState(
      objects: state.objects,
      selectedObjectId: objectId,
    );
  }

  void clearSelection() {
    state = CanvasEditorState(objects: state.objects, selectedObjectId: null);
  }

  // ---------------- মুভ / রিসাইজ / রোটেট ----------------

  /// টাচ দিয়ে টেনে সরানোর সময় প্রতি ফ্রেমে কল হবে — একটা delta (dx, dy)।
  void moveObjectBy(String objectId, Offset delta) {
    _updateObjectTransform(objectId, (t) => t.copyWith(
          x: t.x + delta.dx,
          y: t.y + delta.dy,
        ));
  }

  /// রিসাইজ হ্যান্ডেল টানার সময় — নতুন width/height সরাসরি সেট করা হয়
  /// (delta না, কারণ resize handle-ভেদে দিক ভিন্ন হয়, সেই হিসাব UI লেয়ারে হয়)।
  void resizeObjectTo(String objectId, {double? width, double? height}) {
    _updateObjectTransform(objectId, (t) => t.copyWith(
          width: width != null ? _clampMinSize(width) : null,
          height: height != null ? _clampMinSize(height) : null,
        ));
  }

  /// একই সাথে position আর size বদলানোর জন্য — যেমন উপর-বাম হ্যান্ডেল থেকে
  /// রিসাইজ করলে position ও width/height দুটোই বদলায়।
  void moveAndResizeObjectTo(
    String objectId, {
    double? x,
    double? y,
    double? width,
    double? height,
  }) {
    _updateObjectTransform(objectId, (t) => t.copyWith(
          x: x,
          y: y,
          width: width != null ? _clampMinSize(width) : null,
          height: height != null ? _clampMinSize(height) : null,
        ));
  }

  double _clampMinSize(double value) => value < 8 ? 8 : value;

  /// রোটেশন হ্যান্ডেল টানার সময় — সম্পূর্ণ নতুন কোণ (ডেল্টা না), যাতে
  /// সংক্ষিপ্তভাবে angle wrap-around বাগ এড়ানো যায়।
  void rotateObjectTo(String objectId, double newDegrees) {
    final normalized = newDegrees % 360;
    _updateObjectTransform(objectId, (t) => t.copyWith(
          rotationDegrees: normalized,
        ));
  }

  void _updateObjectTransform(
    String objectId,
    CanvasTransform Function(CanvasTransform current) updater,
  ) {
    if (_isLocked(objectId)) return; // লক করা অবজেক্ট মুভ/রিসাইজ/রোটেট করা যাবে না

    final updated = state.objects.map((o) {
      if (o.id != objectId) return o;
      return o.copyWithTransform(updater(o.transform));
    }).toList();

    state = CanvasEditorState(
      objects: updated,
      selectedObjectId: state.selectedObjectId,
    );
  }

  bool _isLocked(String objectId) {
    try {
      return state.objects.firstWhere((o) => o.id == objectId).locked;
    } catch (_) {
      return false;
    }
  }

  // ---------------- লক / ভিজিবিলিটি / অপাসিটি ----------------

  void toggleLock(String objectId) {
    final updated = state.objects.map((o) {
      if (o.id != objectId) return o;
      return o.copyWithBase(locked: !o.locked);
    }).toList();
    state = CanvasEditorState(
        objects: updated, selectedObjectId: state.selectedObjectId);
  }

  void toggleVisibility(String objectId) {
    final updated = state.objects.map((o) {
      if (o.id != objectId) return o;
      return o.copyWithBase(visible: !o.visible);
    }).toList();
    state = CanvasEditorState(
        objects: updated, selectedObjectId: state.selectedObjectId);
  }

  void setOpacity(String objectId, double opacity) {
    final clamped = opacity.clamp(0.0, 1.0);
    final updated = state.objects.map((o) {
      if (o.id != objectId) return o;
      return o.copyWithBase(opacity: clamped);
    }).toList();
    state = CanvasEditorState(
        objects: updated, selectedObjectId: state.selectedObjectId);
  }

  // ---------------- লেয়ার অর্ডার (z-index) — মৌলিক অংশ ----------------
  // সম্পূর্ণ Layer System (group/ungroup, align, distribute) পরের ধাপে।

  void bringForward(String objectId) {
    _shiftZIndex(objectId, 1);
  }

  void sendBackward(String objectId) {
    _shiftZIndex(objectId, -1);
  }

  void bringToFront(String objectId) {
    if (state.objects.isEmpty) return;
    final maxZ =
        state.objects.map((o) => o.transform.zIndex).reduce((a, b) => a > b ? a : b);
    _updateObjectTransform(objectId, (t) => t.copyWith(zIndex: maxZ + 1));
  }

  void sendToBack(String objectId) {
    if (state.objects.isEmpty) return;
    final minZ =
        state.objects.map((o) => o.transform.zIndex).reduce((a, b) => a < b ? a : b);
    _updateObjectTransform(objectId, (t) => t.copyWith(zIndex: minZ - 1));
  }

  void _shiftZIndex(String objectId, int delta) {
    _updateObjectTransform(
        objectId, (t) => t.copyWith(zIndex: t.zIndex + delta));
  }
}

/// অ্যাপের যেকোনো জায়গা থেকে ক্যানভাস state watch/মডিফাই করার Provider।
/// প্রতিটা খোলা ডকুমেন্টের জন্য আলাদা প্রোভাইডার ইনস্ট্যান্স দরকার হলে
/// ভবিষ্যতে `.family` ব্যবহার করে ডকুমেন্ট আইডি অনুযায়ী স্কোপ করা যাবে।
final canvasControllerProvider =
    StateNotifierProvider<CanvasController, CanvasEditorState>(
  (ref) => CanvasController(),
);
