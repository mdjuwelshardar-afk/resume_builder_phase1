import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import 'core/fonts/font_manager.dart';
import 'core/theme/app_theme.dart';
import 'shared/canvas_engine/controllers/canvas_controller.dart';
import 'shared/canvas_engine/models/canvas_transform.dart';
import 'shared/canvas_engine/models/text_object.dart';
import 'shared/canvas_engine/models/shape_object.dart';
import 'shared/canvas_engine/models/divider_object.dart';
import 'shared/canvas_engine/renderer/canvas_page_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // assets/fonts/-এ ফন্ট ফাইল থাকলে সেগুলো এখানেই ডিসকভার+রেজিস্টার হবে।
  // এখনো কোনো .ttf যোগ করা হয়নি বলে এটা এখন খালি লিস্ট দেবে — এটা প্রত্যাশিত,
  // ফন্ট ফাইল যোগ হলেই কোনো কোড পরিবর্তন ছাড়া কাজ করবে।
  await FontManager.instance.initialize();

  runApp(const ProviderScope(child: ResumeBuilderApp()));
}

class ResumeBuilderApp extends StatelessWidget {
  const ResumeBuilderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Resume Builder',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      home: const _CanvasEnginePreviewScreen(),
    );
  }
}

/// ⚠️ এটা চূড়ান্ত Home Screen না (সেটা ROADMAP.md Phase 1-এর আলাদা আইটেম) —
/// এটা শুধু এখন পর্যন্ত তৈরি হওয়া ক্যানভাস ইঞ্জিন (মডেল + কন্ট্রোলার +
/// রেন্ডারার) সত্যিই কাজ করছে কিনা তা চোখে দেখে যাচাই করার একটা ডেভ প্রিভিউ।
class _CanvasEnginePreviewScreen extends ConsumerStatefulWidget {
  const _CanvasEnginePreviewScreen();

  @override
  ConsumerState<_CanvasEnginePreviewScreen> createState() =>
      _CanvasEnginePreviewScreenState();
}

class _CanvasEnginePreviewScreenState
    extends ConsumerState<_CanvasEnginePreviewScreen> {
  static const _uuid = Uuid();
  bool _seeded = false;

  void _seedSampleObjects() {
    if (_seeded) return;
    _seeded = true;

    final controller = ref.read(canvasControllerProvider.notifier);

    controller.addObject(TextObject(
      id: _uuid.v4(),
      transform: const CanvasTransform(x: 48, y: 48, width: 300, height: 40, zIndex: 2),
      text: 'তোমার নাম এখানে',
      fontFamily: 'Roboto',
      fontSizePt: 24,
      isBold: true,
      textColorArgb: 0xFF0F172A,
    ));

    controller.addObject(DividerObject(
      id: _uuid.v4(),
      transform: const CanvasTransform(x: 48, y: 96, width: 300, height: 4, zIndex: 1),
      colorArgb: 0xFF2563EB,
      thicknessPx: 2,
    ));

    controller.addObject(ShapeObject(
      id: _uuid.v4(),
      transform: const CanvasTransform(x: 400, y: 48, width: 80, height: 80, zIndex: 1),
      kind: ShapeKind.circle,
      fillColorArgb: 0xFF0EA5A4,
    ));
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _seedSampleObjects());

    return Scaffold(
      appBar: AppBar(title: const Text('Canvas Engine — Dev Preview')),
      body: Center(
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 3,
          boundaryMargin: const EdgeInsets.all(200),
          child: const CanvasPageView(),
        ),
      ),
    );
  }
}
