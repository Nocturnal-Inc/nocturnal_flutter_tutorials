import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:nocturnal_flutter_tutorials/src/models/tutorial_section.dart';
import 'package:nocturnal_flutter_tutorials/src/theme/tutorials_theme.dart';

/// A full-page widget that displays a section's title and subtitle.
class SectionCoverPage extends StatelessWidget {
  final TutorialSection section;

  const SectionCoverPage({super.key, required this.section});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: TutorialsTheme.pagePadding,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              section.sectionTitle.toUpperCase(),
              textAlign: TextAlign.center,
              style: TutorialsTheme.sectionTitleStyle.copyWith(
                fontSize: 28,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              section.sectionSubtitle,
              textAlign: TextAlign.center,
              style: TutorialsTheme.subheadingStyle,
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(duration: TutorialsTheme.entryAnimationDuration)
        .slideY(
          begin: 0.05,
          end: 0,
          duration: TutorialsTheme.entryAnimationDuration,
          curve: Curves.easeOut,
        );
  }
}
