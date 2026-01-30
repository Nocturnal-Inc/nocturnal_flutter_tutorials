import 'package:flutter/material.dart';
import 'package:nocturnal_onboarding/src/models/tutorial_content.dart';
import 'package:nocturnal_onboarding/src/widgets/nocturnal_tutorial.dart';

class ConnectToMaskWelcomeScreen extends StatelessWidget {
  final VoidCallback? onComplete;
  final VoidCallback? onSkip;
  final String finishLabel;
  final String? skipLabel;

  const ConnectToMaskWelcomeScreen({
    super.key,
    this.onComplete,
    this.onSkip,
    this.finishLabel = 'Finish',
    this.skipLabel,
  });

  @override
  Widget build(BuildContext context) {
    return NocturnalTutorial(
      showWelcomeScreen: true,
      skipLabel: skipLabel,
      onComplete: onComplete,
      onSkip: onSkip,
      finishLabel: finishLabel,
      pages: TutorialContent.connectToMaskPages,
    );
  }
}
