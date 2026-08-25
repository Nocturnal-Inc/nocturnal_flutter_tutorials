# Changelog

## Unreleased

### Added

- **Next/previous navigation arrows, on by default.** `TutorialBook` gains
  `showNavigationArrows`, which flanks the dot indicator with circular prev/next
  buttons. Swiping, tapping a dot and drag-to-scrub were the only ways to move
  between pages, and none of them advertise themselves — the example's own first
  page had to tell the reader to swipe.

  It defaults to `true`, making it the first opt-OUT flag on `TutorialBook`
  (the precedent is `LeafPage.showVideoControls`). Existing apps gain the arrows
  with no code change; pass `showNavigationArrows: false` to keep the previous
  bottom bar, which renders exactly as before.

  The arrows are drawn at the screen level, so section covers get them too. At
  the ends of the book the unavailable arrow is replaced by an equal-width
  spacer rather than removed, so the dots stay centred and nothing shifts. The
  drag-to-scrub recognizer stays bound to the dots alone so it does not compete
  with the arrow taps, and `_goToPage` is now bounds-guarded.

  The buttons render at 50% opacity (`TutorialsTheme.navArrowOpacity`) so they
  read as secondary chrome rather than competing with the page content. The
  fade is applied once, over the circle and the glyph together — the circle
  colour is kept fully opaque so the two do not land at different strengths.

### Fixed

- **Video pages no longer crash when `autoPlay`/`looping` are omitted.**
  `LeafPage.autoPlay` and `LeafPage.looping` were `bool?` with no constructor
  default, but were force-unwrapped in `_buildVideoArea` /
  `_buildPortraitVideoArea`, so any page that did not pass both threw
  `Null check operator used on a null value` on render. This hit every
  `ContentType.video`, `ContentType.portraitVideo` and `ContentType.mixed` page
  that left them unset — which is how most pages are written.

  Both fields are now non-nullable and default to `true`, restoring the
  behaviour `VideoPlayerWidget` had before they became configurable. Existing
  call sites are unaffected: passing either flag explicitly works exactly as
  before, and no call site passed `null`.

  Regression tests cover a `LeafPage` that omits both flags across all three
  video-bearing content types.

## 1.0.0+1

- Added `autoPlay` and `looping` to `LeafPage`, forwarded to
  `VideoPlayerWidget` (introduced the crash fixed above).
- Added `enableAudio`, `allowFullScreenLandscape` and `showVideoControls`
  opt-in/opt-out flags.
- Extracted the tutorial engine into a standalone package with
  content-ownership inversion.
