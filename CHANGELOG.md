# Changelog

## Unreleased

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
