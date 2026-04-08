import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:nocturnal_flutter_tutorials/src/models/tutorial_page.dart';
import 'package:nocturnal_flutter_tutorials/src/theme/tutorials_theme.dart';

/// A full-page widget that displays a section's title and subtitle.
class SectionCoverPage extends StatelessWidget {
  final GroupPage group;
  final String? packageName;

  const SectionCoverPage({super.key, required this.group, this.packageName});

  @override
  Widget build(BuildContext context) {
    return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: TutorialsTheme.pagePadding,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: TutorialsTheme.contentMaxWidth,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    group.title.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TutorialsTheme.sectionTitleStyle.copyWith(
                      fontSize: 28,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    group.subtitle,
                    textAlign: TextAlign.center,
                    style: TutorialsTheme.subheadingStyle,
                  ),
                  if (group.imagePath != null) ...[
                    const SizedBox(height: 24),
                    Flexible(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          TutorialsTheme.cardBorderRadius,
                        ),
                        child: Image.asset(
                          group.imagePath!,
                          package: packageName,
                          width: double.infinity,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
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
