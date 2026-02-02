import 'package:flutter/material.dart';
import 'package:nocturnal_flutter_tutorials/src/models/section_type.dart';
import 'package:nocturnal_flutter_tutorials/src/models/tutorial_content.dart';
import 'package:nocturnal_flutter_tutorials/src/widgets/nocturnal_tutorial.dart';

class TutorialBook extends StatelessWidget {
  final VoidCallback? onComplete;
  final VoidCallback? onSkip;
  final Set<SectionType> disabledSections;
  final bool showRestartButton;
  final String finishLabel;

  const TutorialBook({
    super.key,
    this.onComplete,
    this.onSkip,
    this.disabledSections = const {},
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
      pages: TutorialContent.filteredSections(disabledSections),
      showRestartButton: showRestartButton,
      enableDragToScrub: true,
      showSectionLabel: true,
    );
  }
}
