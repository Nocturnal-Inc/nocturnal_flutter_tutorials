import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:nocturnal_onboarding/src/models/section_type.dart';
import 'package:nocturnal_onboarding/src/screens/tutorial_book.dart';
import 'package:nocturnal_onboarding/src/theme/tutorials_theme.dart';
import 'package:nocturnal_onboarding/src/widgets/amoeba_background.dart';

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
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const AmoebaBackground(),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (showLogo)
                  Image.asset(
                    'assets/logo/Nocturnal.png',
                    width: 200,
                    fit: BoxFit.contain,
                  )
                else
                  Text(
                    headline ?? '',
                    style: TutorialsTheme.headingStyle,
                    textAlign: TextAlign.center,
                  ),
                const SizedBox(height: 24),
                Text(
                  subtitle,
                  style: TutorialsTheme.subheadingStyle.copyWith(
                    color: TutorialsTheme.textSecondary.withValues(alpha: 0.8),
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
                          builder: (_) => TutorialBook(
                            onComplete: onComplete,
                            onSkip: onSkip,
                            disabledSections: disabledSections,
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
