# Changelog

## Unreleased

### Added

- **A rewatch button on videos.** `LeafPage` gains `showRewatchButton`
  (default `true`), drawn as a small replay circle in the video's top-right
  corner.

  Chewie has a replay glyph of its own, but it is effectively unreachable on a
  tutorial clip. It only appears once `position >= duration`, which a looping
  video never stably reaches — so on a default page (`looping: true`) the
  centre button is always play/pause, never replay. It also disappears entirely
  under `showVideoControls: false`, along with the rest of Chewie's control
  layer. This button is drawn by the package in `VideoPlayerWidget`'s own
  `Stack`, above Chewie, so it is unaffected by both.

  Tapping it always restarts from the first frame and plays, whatever
  `autoPlay` and `looping` are set to — the viewer asking to rewatch is an
  explicit request to start.

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

- **The rewatch button now works on a clip that has played to the end.**
  Seeking a finished `VideoPlayerController` back to zero and calling `play()`
  left the video frozen on its last frame: `seekTo` reported success and
  `isPlaying` flipped `true`, but the platform decoder stayed parked at
  end-of-stream and the position never advanced off `0:00:00`.

  This is a `video_player`/ExoPlayer behaviour rather than a Chewie one — it
  reproduces with a bare `VideoPlayerController` and no Chewie in the tree, so
  no wrapper package built on `video_player` would avoid it. `_rewind` now
  detects the at-end case and rebuilds the controller instead of seeking it,
  which is the only reliable way back. A clip that has *not* finished still
  takes the cheap seek path, so the rebuild's brief loading state only appears
  where it is unavoidable. Re-entry is guarded so a double tap cannot dispose a
  controller that a still-running rebuild is about to hand back.

  Note this only ever bit pages with `looping: false`: a looping clip never
  reaches end-of-stream, so it never wedged.

- **The `Restart` button now resets the videos it returns to.** `_restart` only
  animated the `PageView` back to page 0. `PageView` keeps built pages alive, so
  page 0's `VideoPlayerWidget` state was reused — `initState` never ran again
  and nothing rewound the controller, leaving the clip parked wherever the
  viewer had left it.

  `TutorialBook` now broadcasts a restart signal through a new
  `TutorialRestartScope`, which the live videos and scrollable pages listen to
  in order to reset themselves.

  The same method also called `setState(_currentPage = 0)` synchronously, which
  flipped `_isLastPage` false on the frame of the tap and tore the Finish and
  Restart buttons out of the tree mid-animation — the button vanished under the
  user's finger. That eager `setState` is removed; `PageView.onPageChanged`
  already owns `_currentPage`.

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
