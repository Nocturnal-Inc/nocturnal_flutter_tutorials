# nocturnal_flutter_tutorials

A content-agnostic **tutorial engine**: an optional welcome screen followed by a
swipeable book of section covers and content pages.

**The package ships no copy and no assets.** You build a `List<TutorialPage>` in
your own app, point it at your own images and videos, and hand it to
`TutorialBook`. That's the whole contract — a second product can use this without
forking it.

## Quick start

```dart
import 'package:nocturnal_flutter_tutorials/nocturnal_flutter_tutorials.dart';

// 1. Define your sections. These are content, so you own them.
const powering = TutorialSection(id: 'powering_on', displayName: 'Powering On');

// 2. Build your pages.
final pages = <TutorialPage>[
  // A standalone page.
  TutorialPage(
    LeafPage(
      title: 'Welcome',
      contentType: ContentType.text,
      instructionContent: const BulletPoints(
        bullets: ['Swipe to move between pages.'],
      ),
    ),
  ),
  // A section: renders a cover, then each child in order.
  TutorialPage(
    GroupPage(
      section: powering,
      subtitle: 'Getting started',
      imagePath: 'assets/images/onboarding/device.png',
      children: [
        LeafPage(
          title: 'Press once to power on',
          contentType: ContentType.video,
          videoUrl: 'assets/videos/onboarding/power_button.mp4',
          instructionContent: const DetailedInstructions(
            points: [
              InstructionPoint(
                headline: 'Press once',
                description: 'The device powers on in about 10 seconds.',
                tip: 'Already charging? It is already on.',
              ),
            ],
          ),
        ),
      ],
    ),
  ),
];

// 3. Render.
TutorialBook(
  pages: pages,
  logo: Image.asset('assets/images/my_logo.png', width: 200),
  subtitle: 'Better mornings start here',
  showSectionLabel: true,
  onComplete: () => Navigator.of(context).pop(),
);
```

See `example/lib/main.dart` for a runnable version.

## Assets

Asset paths are resolved **from the consuming app's root**, so declare them in
your own `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/images/onboarding/
    - assets/videos/onboarding/
```

Prefer listing specific directories over parent wildcards — Flutter's directory
globs are non-recursive, and broad entries tend to sweep up `.DS_Store` files
into your bundle.

## The model

| Type | Purpose |
|---|---|
| `TutorialPage` | Wrapper holding either a `GroupPage` or a `LeafPage` |
| `GroupPage` | A section: renders a cover, then its `children` |
| `LeafPage` | One content page: title, media, instructions |
| `TutorialSection` | Section identity — `id` for filtering, `displayName` for the cover |
| `ContentType` | `text`, `textAndImage`, `video`, `portraitVideo`, `gif`, `mixed` |
| `BulletPoints` | Instruction style: a simple list |
| `DetailedInstructions` | Instruction style: headline + description + optional tip |

`LeafPage.enableAudio` opts a page's video into sound (default `false` — videos
are silent). Audio pages still autoplay and loop, so the soundtrack repeats
while the page is open.

`LeafPage.showVideoControls` shows Chewie's playback controls — play/pause, a
scrub bar and remaining time, auto-hiding after a few seconds. It defaults to
**true**, so unlike the two flags above it is opt-OUT: set it `false` for a page
whose video should play uninterrupted. Note this makes seeking possible, so
users can skip ahead.

`LeafPage.allowFullScreenLandscape` lets a page's video expand to fullscreen when
the device is rotated to landscape, returning to the page on rotating back
(default `false`). The consuming app must also permit landscape natively — an
Android `screenOrientation` of `portrait` or an iOS `UISupportedInterfaceOrientations`
without landscape will veto the rotation regardless of this flag. The widget
lifts the portrait lock only while such a page is mounted and restores it on
dispose. Portrait (9:16) clips letterbox heavily in fullscreen landscape, so
leaving `portraitVideo` pages opted out is usually right.

`GroupPage.children` is typed `List<LeafPage>`: a section cannot contain another
section. That's deliberate — the flattener previously downcast and crashed at
runtime on nested groups.

## Filtering sections

Sections are filtered by the client before the list is handed over, keyed on
`TutorialSection.id` so display copy can change without breaking callers:

```dart
final visible = pages.where((p) {
  final t = p.type;
  return t is GroupPage ? !disabled.contains(t.section) : true;
}).toList();
```

## Theming

`TutorialsTheme` currently supplies a fixed palette. Injecting a theme object is
the next planned step; until then a different brand means editing that file.

## Tests

`flutter test` runs the engine suite. It's driven entirely by synthetic content,
which is what proves the engine works without owning any — treat those tests as
the executable usage docs.
