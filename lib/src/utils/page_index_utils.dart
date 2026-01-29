import 'package:nocturnal_onboarding/src/models/tutorial_section.dart';

class PageLocation {
  final int sectionIndex;
  final int pageIndex;

  const PageLocation({
    required this.sectionIndex,
    required this.pageIndex,
  });
}

class PageIndexUtils {
  /// Converts a flat page index (0-based) to a (section, page) pair.
  static PageLocation flatIndexToLocation(
    int flatIndex,
    List<TutorialSection> sections,
  ) {
    int remaining = flatIndex;
    for (int s = 0; s < sections.length; s++) {
      if (remaining < sections[s].pages.length) {
        return PageLocation(sectionIndex: s, pageIndex: remaining);
      }
      remaining -= sections[s].pages.length;
    }
    // Fallback to last page
    final lastSection = sections.length - 1;
    return PageLocation(
      sectionIndex: lastSection,
      pageIndex: sections[lastSection].pages.length - 1,
    );
  }

  /// Returns true if this flat index is the first page of its section.
  static bool isFirstPageOfSection(
    int flatIndex,
    List<TutorialSection> sections,
  ) {
    final location = flatIndexToLocation(flatIndex, sections);
    return location.pageIndex == 0;
  }

  /// Gets the section for a given flat index.
  static TutorialSection getSection(
    int flatIndex,
    List<TutorialSection> sections,
  ) {
    final location = flatIndexToLocation(flatIndex, sections);
    return sections[location.sectionIndex];
  }
}
