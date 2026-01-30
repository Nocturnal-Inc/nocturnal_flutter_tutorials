import 'package:flutter/material.dart';
import 'package:nocturnal_flutter_tutorials/src/models/tutorial_content.dart';
import 'package:nocturnal_flutter_tutorials/src/widgets/nocturnal_tutorial.dart';

/// Public entry-point widget for the Nocturnal mask connection flow.
///
/// Consumer apps can push this widget as a route to start the
/// mask connection tutorial (3 pages with an optional startup screen).
///
/// [onComplete] is called when the user finishes the tutorial.
/// [onSkip] is called when the user taps the close button.
class ConnectToMaskWidget extends StatelessWidget {
  final VoidCallback? onComplete;
  final VoidCallback? onSkip;

  /// Label for the finish button on the last tutorial page.
  ///
  /// Defaults to `'Finish'`.
  final String finishLabel;

  /// Whether to show a startup/welcome screen before the tutorial.
  ///
  /// When `false` the mask connection tutorial is rendered directly,
  /// skipping the startup screen entirely. Defaults to `true`.
  final bool showStartupScreen;

  /// Label for an optional skip button on the startup screen.
  ///
  /// When non-null a text button with this label is shown below "Get Started".
  /// Tapping it invokes [onSkip]. When null, no skip button is rendered.
  final String? skipLabel;

  const ConnectToMaskWidget({
    super.key,
    this.onComplete,
    this.onSkip,
    this.finishLabel = 'Finish',
    this.showStartupScreen = true,
    this.skipLabel,
  });

  @override
  Widget build(BuildContext context) {
    return NocturnalTutorial(
      showWelcomeScreen: showStartupScreen,
      skipLabel: skipLabel,
      onComplete: onComplete,
      onSkip: onSkip,
      finishLabel: finishLabel,
      pages: TutorialContent.connectToMaskPages,
      showLogo: false,
      headline: "Mask connection",
      subtitle: "Get started by connecting the mask",
      buttonLabel: "Next",
    );
  }
}
