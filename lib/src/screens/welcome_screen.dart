import 'package:flutter/material.dart';
import 'package:nocturnal_onboarding/src/models/section_type.dart';
import 'package:nocturnal_onboarding/src/models/tutorial_content.dart';
import 'package:nocturnal_onboarding/src/widgets/nocturnal_tutorial.dart';

class WelcomeScreen extends StatelessWidget {
  final VoidCallback? onComplete;
  final Set<SectionType> disabledSections;
  final String? skipLabel;
  final VoidCallback? onSkip;
  final String finishLabel;

  /// Whether to show the logo on the welcome screen.
  /// When `false`, [headline] is displayed in place of the logo.
  final bool showLogo;

  /// Headline text displayed in place of the logo when [showLogo] is `false`.
  final String? headline;

  /// Subtitle text shown below the logo or headline on the welcome screen.
  final String subtitle;

  const WelcomeScreen({
    super.key,
    this.onComplete,
    this.disabledSections = const {},
    this.skipLabel,
    this.onSkip,
    this.finishLabel = 'Finish',
    this.showLogo = true,
    this.headline,
    this.subtitle = 'Better sleep starts here',
  });

  @override
  Widget build(BuildContext context) {
    return NocturnalTutorial(
      showWelcomeScreen: true,
      showLogo: showLogo,
      headline: headline,
      subtitle: subtitle,
      skipLabel: skipLabel,
      onComplete: onComplete,
      onSkip: onSkip,
      finishLabel: finishLabel,
      sections: TutorialContent.filteredSections(disabledSections),
      enableDragToScrub: true,
      showSectionLabel: true,
    );
  }
}
