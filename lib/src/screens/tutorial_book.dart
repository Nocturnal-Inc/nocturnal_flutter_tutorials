import 'package:flutter/material.dart';
import 'package:nocturnal_onboarding/src/models/section_type.dart';
import 'package:nocturnal_onboarding/src/models/tutorial_content.dart';
import 'package:nocturnal_onboarding/src/widgets/nocturnal_tutorial.dart';

class TutorialBook extends StatelessWidget {
  final VoidCallback? onComplete;
  final VoidCallback? onSkip;
  final Set<SectionType> disabledSections;
  final bool showPageNumber;
  final bool showRestartButton;
  final String finishLabel;

  const TutorialBook({
    super.key,
    this.onComplete,
    this.onSkip,
    this.disabledSections = const {},
    this.showPageNumber = false,
    this.showRestartButton = false,
    this.finishLabel = 'Finish',
  });

  @override
  Widget build(BuildContext context) {
    return NocturnalTutorial(
      showWelcomeScreen: false,
      onComplete: onComplete,
      onSkip: onSkip,
      finishLabel: finishLabel,
      sections: TutorialContent.filteredSections(disabledSections),
      showPageNumber: showPageNumber,
      showRestartButton: showRestartButton,
      enableDragToScrub: true,
      showSectionLabel: true,
    );
  }
}
