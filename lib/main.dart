import 'package:flutter/material.dart';
import 'package:nocturnal_flutter_tutorials/nocturnal_flutter_tutorials.dart';

void main() {
  runApp(const NocturnalOnboardingApp());
}

class NocturnalOnboardingApp extends StatelessWidget {
  const NocturnalOnboardingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nocturnal Tutorials',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: TutorialsTheme.fontFamily,
        colorScheme: ColorScheme.fromSeed(
          seedColor: TutorialsTheme.accentColor,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: TutorialsTheme.backgroundColor,
      ),
      home: const _TutorialLauncherPage(),
    );
  }
}

class _TutorialLauncherPage extends StatelessWidget {
  const _TutorialLauncherPage();

  void _push(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: TutorialsTheme.pagePadding,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Nocturnal Tutorials', style: TutorialsTheme.headingStyle),
              const SizedBox(height: 12),
              Text(
                'Choose a tutorial to preview',
                style: TutorialsTheme.subheadingStyle,
              ),
              const SizedBox(height: 48),
              _LauncherButton(
                label: 'Nocturnal Onboarding',
                onTap: () => _push(
                  context,
                  NocturnalOnboardingWidget(
                    onComplete: () => Navigator.of(context).pop(),
                    onSkip: () => Navigator.of(context).pop(),
                    skipLabel: 'Skip',
                    disabledSections: const {},
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _LauncherButton(
                label: 'Connect to Mask',
                onTap: () => _push(
                  context,
                  ConnectToMaskWidget(
                    onComplete: () => Navigator.of(context).pop(),
                    onSkip: () => Navigator.of(context).pop(),
                    skipLabel: 'Skip',
                    finishLabel: 'Next',
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _LauncherButton(
                label: 'Experience Optimization',
                onTap: () => _push(
                  context,
                  ExperienceOptimizationWidget(
                    onComplete: () => Navigator.of(context).pop(),
                    onSkip: () => Navigator.of(context).pop(),
                    skipLabel: 'Skip',
                    finishLabel: 'Start',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LauncherButton extends StatelessWidget {
  const _LauncherButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: TutorialsTheme.buttonColor,
          foregroundColor: TutorialsTheme.buttonTextColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              TutorialsTheme.buttonBorderRadius,
            ),
          ),
        ),
        child: Text(label, style: TutorialsTheme.buttonTextStyle),
      ),
    );
  }
}
