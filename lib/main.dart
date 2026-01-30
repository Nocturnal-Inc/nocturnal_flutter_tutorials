import 'package:flutter/material.dart';
import 'package:nocturnal_onboarding/nocturnal_onboarding.dart';

void main() {
  runApp(const NocturnalOnboardingApp());
}

class NocturnalOnboardingApp extends StatelessWidget {
  const NocturnalOnboardingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nocturnal Onboarding',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: TutorialsTheme.fontFamily,
        colorScheme: ColorScheme.fromSeed(
          seedColor: TutorialsTheme.accentColor,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: TutorialsTheme.backgroundColor,
      ),
      // home: NocturnalOnboardingWidget(
      //   onComplete: () {
      //     debugPrint('Onboarding complete!');
      //   },
      //   disabledSections: const {},
      //   skipLabel: 'Skip',
      //   onSkip: () => debugPrint('Onboarding skipped!'),
      // ),
      // home: ConnectToMaskWidget(
      //   onComplete: () {
      //     debugPrint('Connection tutorial complete!');
      //   },
      //   onSkip: () => debugPrint('Connection tutorial skipped!'),
      //   finishLabel: "Next",
      // ),
      home: ExperienceOptimizationWidget(
        onComplete: () {
          debugPrint('Experience optimazation complete!');
        },
        onSkip: () {
          debugPrint('Experience optimization skipped!');
        },
        finishLabel: "Next",
      ),
    );
  }
}
