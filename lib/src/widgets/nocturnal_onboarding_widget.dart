import 'package:flutter/material.dart';
import 'package:nocturnal_flutter_tutorials/src/models/section_type.dart';
import 'package:nocturnal_flutter_tutorials/src/models/tutorial_content.dart';
import 'package:nocturnal_flutter_tutorials/src/widgets/nocturnal_tutorial.dart';

/// Public entry-point widget for the Nocturnal onboarding flow.
///
/// Consumer apps can push this widget as a route to start the full
/// onboarding experience (welcome screen -> tutorial book).
///
/// [onComplete] is called when the user finishes or dismisses the onboarding.
class NocturnalOnboardingWidget extends StatelessWidget {
  final VoidCallback? onComplete;

  /// Section types to exclude from the onboarding flow.
  final Set<SectionType> disabledSections;

  /// Label for an optional skip button on the welcome screen.
  ///
  /// When non-null a text button with this label is shown below "Get Started".
  /// Tapping it invokes [onSkip]. When null, no skip button is rendered.
  final String? skipLabel;

  /// Called when the user taps the skip button.
  final VoidCallback? onSkip;

  /// Whether to show the welcome screen before the tutorial book.
  ///
  /// When `false` the tutorial book is rendered directly, skipping the
  /// welcome screen entirely. Defaults to `true`.
  final bool showWelcomeScreen;

  /// Label for the finish button on the last tutorial page.
  ///
  /// Defaults to `'Finish'`.
  final String finishLabel;

  /// Whether to show the logo on the welcome screen.
  /// When `false`, [headline] is displayed in place of the logo.
  final bool showLogo;

  /// Headline text displayed in place of the logo when [showLogo] is `false`.
  final String? headline;

  /// Subtitle text shown below the logo or headline on the welcome screen.
  final String subtitle;

  const NocturnalOnboardingWidget({
    super.key,
    this.onComplete,
    this.disabledSections = const {},
    this.skipLabel,
    this.onSkip,
    this.showWelcomeScreen = true,
    this.finishLabel = 'Finish',
    this.showLogo = true,
    this.headline,
    this.subtitle = 'Better sleep starts here',
  });

  @override
  Widget build(BuildContext context) {
    return NocturnalTutorial(
      showWelcomeScreen: showWelcomeScreen,
      showLogo: showLogo,
      headline: headline,
      subtitle: "",
      skipLabel: skipLabel,
      onComplete: onComplete,
      onSkip: onSkip,
      finishLabel: finishLabel,
      sections: TutorialContent.filteredSections(disabledSections),
      showPageNumber: false,
      showRestartButton: false,
      enableDragToScrub: true,
      showSectionLabel: true,
    );
  }
}
