import '../models/canvas_object.dart';

/// একটা রেজুমে/ডকুমেন্ট পেজের পুরো ক্যানভাস state — সব অবজেক্ট এবং কোনটা
/// এখন সিলেক্টেড তা এখানে থাকে। Riverpod এর মাধ্যমে UI এটা watch করে।
class CanvasEditorState {
  final List<CanvasObject> objects;
  final String? selectedObjectId;

  const CanvasEditorState({
    this.objects = const [],
    this.selectedObjectId,
  });

  CanvasObject? get selectedObject {
    if (selectedObjectId == null) return null;
    try {
      return objects.firstWhere((o) => o.id == selectedObjectId);
    } catch (_) {
      return null;
    }
  }

  /// z-index অনুযায়ী সাজানো অবজেক্ট লিস্ট — রেন্ডারারে আঁকার সময় এই অর্ডারে
  /// আঁকতে হবে (কম zIndex আগে, বেশি zIndex পরে/উপরে)।
  List<CanvasObject> get objectsInDrawOrder {
    final sorted = List<CanvasObject>.from(objects);
    sorted.sort((a, b) => a.transform.zIndex.compareTo(b.transform.zIndex));
    return sorted;
  }

  CanvasEditorState copyWith({
    List<CanvasObject>? objects,
    String? selectedObjectId,
    bool clearSelection = false,
  }) {
    return CanvasEditorState(
      objects: objects ?? this.objects,
      selectedObjectId:
          clearSelection ? null : (selectedObjectId ?? this.selectedObjectId),
    );
  }
}
