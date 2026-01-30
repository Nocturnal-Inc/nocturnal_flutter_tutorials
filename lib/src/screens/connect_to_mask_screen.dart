import 'package:flutter/material.dart';
import 'package:nocturnal_onboarding/src/models/tutorial_content.dart';
import 'package:nocturnal_onboarding/src/widgets/nocturnal_tutorial.dart';

/// Internal screen for the mask-connection tutorial flow.
///
/// Displays [TutorialContent.connectToMaskPages] in a swipeable [PageView]
/// with a dot indicator and a "Finish" button on the last page.
class ConnectToMaskScreen extends StatelessWidget {
  final VoidCallback? onComplete;
  final VoidCallback? onSkip;
  final String finishLabel;

  const ConnectToMaskScreen({
    super.key,
    this.onComplete,
    this.onSkip,
    this.finishLabel = 'Finish',
  });

  @override
  Widget build(BuildContext context) {
    return NocturnalTutorial(
      showWelcomeScreen: false,
      onComplete: onComplete,
      onSkip: onSkip,
      finishLabel: finishLabel,
      pages: TutorialContent.connectToMaskPages,
    );
  }
}
