import 'package:nocturnal_onboarding/src/models/section_type.dart';
import 'package:nocturnal_onboarding/src/models/tutorial_page.dart';

class TutorialSection {
  final SectionType type;
  final String sectionSubtitle;
  final List<TutorialPage> pages;

  const TutorialSection({
    required this.type,
    required this.sectionSubtitle,
    required this.pages,
  });

  String get sectionTitle => type.displayName;
}
