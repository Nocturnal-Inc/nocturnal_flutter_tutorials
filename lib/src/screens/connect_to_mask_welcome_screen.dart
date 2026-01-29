import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:nocturnal_onboarding/src/screens/connect_to_mask_screen.dart';
import 'package:nocturnal_onboarding/src/theme/tutorials_theme.dart';
import 'package:nocturnal_onboarding/src/widgets/amoeba_background.dart';

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
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const AmoebaBackground(),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logo/Nocturnal.png',
                  width: 200,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 24),
                Text(
                  'Better sleep starts here',
                  style: TutorialsTheme.subheadingStyle.copyWith(
                    color:
                        TutorialsTheme.textSecondary.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(height: 60),
                SizedBox(
                  width: 220,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ConnectToMaskScreen(
                            onComplete: onComplete,
                            onSkip: onSkip,
                            finishLabel: finishLabel,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TutorialsTheme.buttonColor,
                      foregroundColor: TutorialsTheme.buttonTextColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          TutorialsTheme.buttonBorderRadius,
                        ),
                      ),
                      elevation: 4,
                    ),
                    child: const Text(
                      'Get Started',
                      style: TutorialsTheme.buttonTextStyle,
                    ),
                  ),
                )
                    .animate()
                    .fadeIn(
                      delay: const Duration(milliseconds: 600),
                      duration: const Duration(milliseconds: 800),
                    )
                    .slideY(
                      begin: 0.3,
                      end: 0,
                      delay: const Duration(milliseconds: 600),
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.easeOut,
                    ),
                if (skipLabel != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: TextButton(
                      onPressed: onSkip,
                      child: Text(
                        skipLabel!,
                        style: TutorialsTheme.subheadingStyle.copyWith(
                          color: TutorialsTheme.textSecondary,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  )
                      .animate()
                      .fadeIn(
                        delay: const Duration(milliseconds: 900),
                        duration: const Duration(milliseconds: 800),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
