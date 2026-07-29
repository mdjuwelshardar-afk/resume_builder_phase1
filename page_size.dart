/// সমর্থিত পেজ সাইজ। মান পয়েন্ট এককে (1pt = 1/72 inch) — এটাই PDF এক্সপোর্টেও
/// (`pdf` প্যাকেজ) সরাসরি ব্যবহারযোগ্য এবং ভবিষ্যতে বাড়তি রূপান্তর লাগে না।
enum PageSizeType { a4, letter, legal }

enum PageOrientation { portrait, landscape }

class PageDimensions {
  final double widthPt;
  final double heightPt;

  const PageDimensions({required this.widthPt, required this.heightPt});
}

/// পেজ সাইজ + অরিয়েন্টেশন থেকে আসল width/height (পয়েন্ট এককে) বের করার হেল্পার।
class PageSize {
  PageSize._();

  static const Map<PageSizeType, PageDimensions> _portraitDimensions = {
    PageSizeType.a4: PageDimensions(widthPt: 595.28, heightPt: 841.89),
    PageSizeType.letter: PageDimensions(widthPt: 612, heightPt: 792),
    PageSizeType.legal: PageDimensions(widthPt: 612, heightPt: 1008),
  };

  static PageDimensions dimensionsFor(
    PageSizeType type,
    PageOrientation orientation,
  ) {
    final portrait = _portraitDimensions[type]!;
    if (orientation == PageOrientation.portrait) return portrait;
    return PageDimensions(
      widthPt: portrait.heightPt,
      heightPt: portrait.widthPt,
    );
  }

  static String displayName(PageSizeType type) {
    switch (type) {
      case PageSizeType.a4:
        return 'A4';
      case PageSizeType.letter:
        return 'Letter';
      case PageSizeType.legal:
        return 'Legal';
    }
  }
}
