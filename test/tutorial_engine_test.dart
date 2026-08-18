import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nocturnal_flutter_tutorials/nocturnal_flutter_tutorials.dart';
import 'package:nocturnal_flutter_tutorials/src/widgets/section_cover_page.dart';
import 'package:nocturnal_flutter_tutorials/src/widgets/tutorial_page_widget.dart';

/// Engine tests driven by SYNTHETIC, non-Nocturnal content.
///
/// The point is twofold: they pin the rendering behaviour through the
/// content-ownership inversion, and they demonstrate that the engine works with
/// content it doesn't own — which is the property that makes it a blueprint.
///
/// Note: `pumpAndSettle` deadlocks here because the amoeba background animation
/// repeats forever. Always use `pump(Duration)`.

// --- synthetic content ------------------------------------------------------

LeafPage textLeaf(String title, {List<String>? bullets}) => LeafPage(
  title: title,
  contentType: ContentType.text,
  instructionContent: BulletPoints(bullets: bullets ?? const ['a bullet']),
);

LeafPage detailedLeaf(String title) => LeafPage(
  title: title,
  contentType: ContentType.text,
  instructionContent: const DetailedInstructions(
    points: [
      InstructionPoint(
        headline: 'Headline one',
        description: 'Description one',
        tip: 'A tip',
      ),
    ],
  ),
);

/// A leaf with no media, so the engine renders its placeholder path.
LeafPage placeholderLeaf(String title) => LeafPage(
  title: title,
  contentType: ContentType.textAndImage,
  instructionContent: const BulletPoints(bullets: ['x']),
  placeholderIcon: Icons.star,
);

Widget host(Widget child) => MaterialApp(home: child);

/// Pumps the engine past its entry animations without settling.
Future<void> pumpEngine(WidgetTester tester, Widget engine) async {
  await tester.pumpWidget(host(engine));
  await tester.pump(const Duration(seconds: 1));
}

void main() {
  group('page flattening', () {
    testWidgets('a GroupPage emits one cover plus each child', (tester) async {
      final pages = [
        TutorialPage(
          GroupPage(
            section: const TutorialSection(
              id: 's1',
              displayName: 'Section One',
            ),
            subtitle: 'sub',
            children: [textLeaf('Child A'), textLeaf('Child B')],
          ),
        ),
      ];

      await pumpEngine(
        tester,
        TutorialBook(pages: pages, showWelcomeScreen: false),
      );

      // First entry is the section cover, not a content page.
      expect(find.byType(SectionCoverPage), findsOneWidget);
      expect(find.text('Child A'), findsNothing);
    });

    testWidgets('standalone LeafPages render directly', (tester) async {
      await pumpEngine(
        tester,
        TutorialBook(
          pages: [TutorialPage(textLeaf('Solo Page'))],
          showWelcomeScreen: false,
        ),
      );

      expect(find.byType(TutorialPageWidget), findsOneWidget);
      expect(find.text('Solo Page'), findsOneWidget);
      expect(find.byType(SectionCoverPage), findsNothing);
    });

    testWidgets('a mixed list flattens in declaration order', (tester) async {
      final pages = [
        TutorialPage(textLeaf('Intro')),
        TutorialPage(
          GroupPage(
            section: const TutorialSection(
              id: 's2',
              displayName: 'Section Two',
            ),
            subtitle: 'sub',
            children: [textLeaf('Inner')],
          ),
        ),
      ];

      await pumpEngine(
        tester,
        TutorialBook(pages: pages, showWelcomeScreen: false),
      );

      // Intro is first; the cover and inner page follow.
      expect(find.text('Intro'), findsOneWidget);
    });
  });

  group('instruction rendering', () {
    testWidgets('BulletPoints renders every bullet', (tester) async {
      await pumpEngine(
        tester,
        TutorialBook(
          pages: [
            TutorialPage(
              textLeaf('P', bullets: const ['first', 'second', 'third']),
            ),
          ],
          showWelcomeScreen: false,
        ),
      );

      expect(find.text('first'), findsOneWidget);
      expect(find.text('second'), findsOneWidget);
      expect(find.text('third'), findsOneWidget);
    });

    testWidgets('DetailedInstructions renders headline, body and tip', (
      tester,
    ) async {
      await pumpEngine(
        tester,
        TutorialBook(
          pages: [TutorialPage(detailedLeaf('P'))],
          showWelcomeScreen: false,
        ),
      );

      expect(find.text('Headline one'), findsOneWidget);
      expect(find.text('Description one'), findsOneWidget);
      expect(find.text('A tip'), findsOneWidget);
    });
  });

  group('media dispatch', () {
    testWidgets('a leaf with no media shows the placeholder icon', (
      tester,
    ) async {
      await pumpEngine(
        tester,
        TutorialBook(
          pages: [TutorialPage(placeholderLeaf('P'))],
          showWelcomeScreen: false,
        ),
      );

      expect(find.byIcon(Icons.star), findsOneWidget);
    });
  });

  group('welcome screen', () {
    testWidgets('showWelcomeScreen: true renders the start button', (
      tester,
    ) async {
      await pumpEngine(
        tester,
        TutorialBook(
          pages: [TutorialPage(textLeaf('P'))],
          headline: 'My headline',
          buttonLabel: 'Begin',
        ),
      );

      expect(find.text('My headline'), findsOneWidget);
      expect(find.text('Begin'), findsOneWidget);
      // The tutorial itself hasn't started yet.
      expect(find.byType(TutorialPageWidget), findsNothing);
    });

    testWidgets('showWelcomeScreen: false goes straight to page one', (
      tester,
    ) async {
      await pumpEngine(
        tester,
        TutorialBook(
          pages: [TutorialPage(textLeaf('First Page'))],
          showWelcomeScreen: false,
        ),
      );

      expect(find.text('First Page'), findsOneWidget);
    });

    testWidgets('onSkip fires from the welcome screen', (tester) async {
      var skipped = false;
      await pumpEngine(
        tester,
        TutorialBook(
          pages: [TutorialPage(textLeaf('P'))],
          skipLabel: 'Skip it',
          onSkip: () => skipped = true,
        ),
      );

      await tester.tap(find.text('Skip it'));
      await tester.pump(const Duration(milliseconds: 300));

      expect(skipped, isTrue);
    });
  });

  group('completion', () {
    testWidgets('onComplete fires from the finish button on a single page', (
      tester,
    ) async {
      var completed = false;
      await pumpEngine(
        tester,
        TutorialBook(
          pages: [TutorialPage(textLeaf('Only Page'))],
          showWelcomeScreen: false,
          finishLabel: 'Done',
          onComplete: () => completed = true,
        ),
      );

      // A single page is immediately the last page, so Finish is showing.
      expect(find.text('Done'), findsOneWidget);
      await tester.tap(find.text('Done'));
      await tester.pump(const Duration(milliseconds: 300));

      expect(completed, isTrue);
    });
  });

  group('section filtering', () {
    test('filtering drops a disabled section entirely', () {
      final pages = [
        TutorialPage(textLeaf('Keep me')),
        TutorialPage(
          GroupPage(
            section: const TutorialSection(
              id: 's3',
              displayName: 'Section Three',
            ),
            subtitle: 'sub',
            children: [textLeaf('Inner')],
          ),
        ),
      ];

      // Mirrors the filtering the client applies before handing pages over.
      List<TutorialPage> filtered(Set<TutorialSection> disabled) =>
          pages.where((p) {
            final t = p.type;
            return t is GroupPage ? !disabled.contains(t.section) : true;
          }).toList();

      expect(filtered({}).length, 2);
      expect(
        filtered({const TutorialSection(id: 's3', displayName: 'x')}).length,
        1,
      );
      // The surviving entry is the standalone leaf, not the group.
      expect(
        filtered({
          const TutorialSection(id: 's3', displayName: 'x'),
        }).single.type,
        isA<LeafPage>(),
      );
    });
  });

  group('video audio opt-in', () {
    // Volume itself needs a real platform player, so pin the plumbing: the flag
    // must reach VideoPlayerWidget from every video-bearing ContentType. A
    // missed call site is silent in both senses.
    LeafPage videoLeaf(ContentType type, {bool audio = false}) => LeafPage(
      title: 'V',
      contentType: type,
      videoUrl: 'assets/videos/nonexistent.mp4',
      instructionContent: const BulletPoints(bullets: ['x']),
      enableAudio: audio,
      looping: true,
      autoPlay: true,
    );

    testWidgets('defaults to silent', (tester) async {
      await pumpEngine(
        tester,
        TutorialBook(
          pages: [TutorialPage(videoLeaf(ContentType.video))],
          showWelcomeScreen: false,
        ),
      );
      final w = tester.widget<VideoPlayerWidget>(
        find.byType(VideoPlayerWidget),
      );
      expect(w.enableAudio, isFalse);
    });

    for (final type in [
      ContentType.video,
      ContentType.portraitVideo,
      ContentType.mixed,
    ]) {
      testWidgets('$type forwards enableAudio', (tester) async {
        await pumpEngine(
          tester,
          TutorialBook(
            pages: [TutorialPage(videoLeaf(type, audio: true))],
            showWelcomeScreen: false,
          ),
        );
        final w = tester.widget<VideoPlayerWidget>(
          find.byType(VideoPlayerWidget),
        );
        expect(w.enableAudio, isTrue, reason: '$type dropped the flag');
      });
    }
  });

  group('landscape fullscreen opt-in', () {
    // Orientation is a platform behaviour and can't be asserted in a widget
    // test, so pin the plumbing: the flag must reach VideoPlayerWidget from
    // every video-bearing ContentType.
    LeafPage videoLeaf(ContentType type, {bool landscape = false}) => LeafPage(
      title: 'V',
      contentType: type,
      videoUrl: 'assets/videos/nonexistent.mp4',
      instructionContent: const BulletPoints(bullets: ['x']),
      allowFullScreenLandscape: landscape,
      looping: true,
      autoPlay: true,
    );

    testWidgets('defaults to portrait-locked', (tester) async {
      await pumpEngine(
        tester,
        TutorialBook(
          pages: [TutorialPage(videoLeaf(ContentType.video))],
          showWelcomeScreen: false,
        ),
      );
      final w = tester.widget<VideoPlayerWidget>(
        find.byType(VideoPlayerWidget),
      );
      expect(w.allowFullScreenLandscape, isFalse);
    });

    for (final type in [
      ContentType.video,
      ContentType.portraitVideo,
      ContentType.mixed,
    ]) {
      testWidgets('$type forwards allowFullScreenLandscape', (tester) async {
        await pumpEngine(
          tester,
          TutorialBook(
            pages: [TutorialPage(videoLeaf(type, landscape: true))],
            showWelcomeScreen: false,
          ),
        );
        final w = tester.widget<VideoPlayerWidget>(
          find.byType(VideoPlayerWidget),
        );
        expect(
          w.allowFullScreenLandscape,
          isTrue,
          reason: '$type dropped the flag',
        );
      });
    }
  });

  group('video controls opt-out', () {
    // Inverted vs the other two flags: this one defaults TRUE, so the
    // forwarding tests must pass FALSE. Asserting the true case would pass even
    // with the wiring deleted, since VideoPlayerWidget defaults true too.
    LeafPage videoLeaf(ContentType type, {bool? controls}) => LeafPage(
      title: 'V',
      contentType: type,
      videoUrl: 'assets/videos/nonexistent.mp4',
      instructionContent: const BulletPoints(bullets: ['x']),
      showVideoControls: controls ?? true,
      looping: true,
      autoPlay: true,
    );

    testWidgets('defaults to controls shown', (tester) async {
      await pumpEngine(
        tester,
        TutorialBook(
          pages: [TutorialPage(videoLeaf(ContentType.video))],
          showWelcomeScreen: false,
        ),
      );
      final w = tester.widget<VideoPlayerWidget>(
        find.byType(VideoPlayerWidget),
      );
      expect(w.showVideoControls, isTrue);
    });

    for (final type in [
      ContentType.video,
      ContentType.portraitVideo,
      ContentType.mixed,
    ]) {
      testWidgets('$type forwards an explicit opt-out', (tester) async {
        await pumpEngine(
          tester,
          TutorialBook(
            pages: [TutorialPage(videoLeaf(type, controls: false))],
            showWelcomeScreen: false,
          ),
        );
        final w = tester.widget<VideoPlayerWidget>(
          find.byType(VideoPlayerWidget),
        );
        expect(w.showVideoControls, isFalse, reason: '$type dropped the flag');
      });
    }
  });
}
