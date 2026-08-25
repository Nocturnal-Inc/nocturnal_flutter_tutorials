import 'package:flutter/material.dart';
import 'package:nocturnal_flutter_tutorials/nocturnal_flutter_tutorials.dart';

/// Demo app for the tutorial engine.
///
/// It builds its own content, exactly the way a consuming app does — the
/// package ships no copy and no assets of its own. Use this as the worked
/// example of the blueprint API.
void main() {
  runApp(const TutorialDemoApp());
}

/// A small, product-neutral tutorial built from the blueprint types.
///
/// Note the shape: a standalone [LeafPage] for the intro, then a [GroupPage]
/// that renders a section cover followed by each of its children.
final List<TutorialPage> demoPages = [
  TutorialPage(
    LeafPage(
      title: 'Welcome',
      contentType: ContentType.text,
      instructionContent: BulletPoints.text([
          'This tutorial is built by the app, not the package.',
          'Swipe or use the arrows below to move between pages.',
        ]),
    ),
  ),
  TutorialPage(
    GroupPage(
      section: const TutorialSection(id: 'demo', displayName: 'A Section'),
      subtitle: 'A section groups related pages behind a cover.',
      children: [
        LeafPage(
          title: 'Detailed instructions',
          contentType: ContentType.text,
          instructionContent: const DetailedInstructions(
            points: [
              InstructionPoint(
                headline: 'Headline',
                description: 'A longer description sits under the headline.',
                tip: 'And an optional tip in italics.',
              ),
            ],
          ),
        ),
        LeafPage(
          title: 'Media placeholder',
          contentType: ContentType.textAndImage,
          placeholderIcon: Icons.image_outlined,
          instructionContent: BulletPoints.text(['Supply imagePath / videoUrl / gifPath to show media.']),
        ),
      ],
    ),
  ),
];

class TutorialDemoApp extends StatelessWidget {
  const TutorialDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tutorial Book Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: TutorialsTheme.fontFamily,
        colorScheme: ColorScheme.fromSeed(
          seedColor: TutorialsTheme.accentColor,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: TutorialsTheme.backgroundColor,
      ),
      home: const _DemoLauncherPage(),
    );
  }
}

class _DemoLauncherPage extends StatelessWidget {
  const _DemoLauncherPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TutorialsTheme.backgroundColor,
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => TutorialBook(
                pages: demoPages,
                headline: 'Tutorial Book',
                subtitle: 'A content-agnostic tutorial engine',
                buttonLabel: 'Get Started',
                showSectionLabel: true,
                enableDragToScrub: true,
                onComplete: () => Navigator.of(context).pop(),
              ),
            ),
          ),
          child: const Text('Open demo tutorial'),
        ),
      ),
    );
  }
}
