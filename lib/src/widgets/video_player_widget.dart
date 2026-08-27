import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:nocturnal_flutter_tutorials/src/theme/tutorials_theme.dart';
import 'package:nocturnal_flutter_tutorials/src/widgets/tutorial_restart_scope.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final bool autoPlay;
  final bool looping;
  final double aspectRatio;

  /// Whether the clip plays with sound. Defaults to false — tutorial videos are
  /// silent unless the page opts in via [LeafPage.enableAudio].
  final bool enableAudio;

  /// Whether rotating to landscape expands the video to fullscreen.
  ///
  /// Defaults to false. When true this widget temporarily permits landscape
  /// while it is mounted and restores the portrait lock on dispose — see
  /// [LeafPage.allowFullScreenLandscape].
  final bool allowFullScreenLandscape;

  /// Whether Chewie's playback controls (play/pause, scrub, remaining time) are
  /// available at all. Defaults to true — see [LeafPage.showVideoControls].
  ///
  /// Note this only governs whether the controls *exist*, not whether they are
  /// on screen: they stay hidden until the user taps the video and auto-hide
  /// again a few seconds later. A slim progress bar is always visible.
  final bool showVideoControls;

  /// Whether to show this package's own replay button in the video's corner.
  ///
  /// Defaults to true — see [LeafPage.showRewatchButton].
  ///
  /// Chewie has a replay glyph of its own, but it is unreachable on a tutorial
  /// clip: it only appears once `position >= duration`, which a looping video
  /// never stably reaches, and it disappears entirely under
  /// [showVideoControls] `false`. This button is owned by the package, so it
  /// works regardless of both.
  final bool showRewatchButton;

  const VideoPlayerWidget({
    super.key,
    required this.videoUrl,
    required this.autoPlay,
    required this.looping,
    this.aspectRatio = 16 / 9,
    this.enableAudio = false,
    this.allowFullScreenLandscape = false,
    this.showVideoControls = true,
    this.showRewatchButton = true,
  });

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget>
    with WidgetsBindingObserver {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _hasError = false;

  /// Tracks what we last told Chewie, so a metrics change that isn't an
  /// orientation flip doesn't repeatedly push/pop its fullscreen route.
  bool _isLandscape = false;

  /// The restart signal we are currently subscribed to, kept so the listener
  /// can be detached from the same object it was attached to.
  ValueNotifier<int>? _restartTick;

  /// Guards [_reinitializePlayer] against re-entry from a rapid double tap.
  bool _isReinitializing = false;

  @override
  void initState() {
    super.initState();
    if (widget.allowFullScreenLandscape) {
      // Lift the app-wide portrait lock for as long as this page is mounted.
      // dispose() restores it unconditionally.
      WidgetsBinding.instance.addObserver(this);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }
    _initializePlayer();
  }

  /// Restart is broadcast from [TutorialBook] rather than passed in, so the
  /// subscription is (re)bound here whenever the enclosing scope changes.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final tick = TutorialRestartScope.maybeOf(context);
    if (identical(tick, _restartTick)) return;
    _restartTick?.removeListener(_handleRestart);
    _restartTick = tick;
    _restartTick?.addListener(_handleRestart);
  }

  /// Rewind to the first frame and resume per [widget.autoPlay].
  ///
  /// [PageView] reuses this state when the tutorial returns to an earlier page,
  /// so without this the clip would slide back into view still parked wherever
  /// the viewer left it.
  Future<void> _handleRestart() => _rewind(play: widget.autoPlay);

  /// Rewind to the first frame and play — what the rewatch button does.
  ///
  /// Always plays, whatever [widget.autoPlay] says: the viewer asked to watch
  /// the clip again, which is an explicit request to start it.
  Future<void> _handleRewatch() => _rewind(play: true);

  Future<void> _rewind({required bool play}) async {
    if (_hasError || !_videoPlayerController.value.isInitialized) return;

    // A controller that has played to the end will not resume: seekTo(zero)
    // reports success and isPlaying flips true, but the platform decoder stays
    // parked at end-of-stream and the position never advances off zero. That
    // is a video_player/ExoPlayer behaviour, not a Chewie one — it reproduces
    // with a bare VideoPlayerController and no Chewie in the tree. Rebuilding
    // the controller is the only reliable way back.
    //
    // A clip that has NOT finished rewinds fine, so keep the cheap path for it
    // and avoid the rebuild's flash of loading state.
    final value = _videoPlayerController.value;
    final atEnd =
        value.duration > Duration.zero && value.position >= value.duration;

    if (!atEnd) {
      await _videoPlayerController.seekTo(Duration.zero);
      if (!mounted) return;
      if (play) {
        await _videoPlayerController.play();
      } else {
        await _videoPlayerController.pause();
      }
      return;
    }

    await _reinitializePlayer(play: play);
  }

  /// Tear the finished controller down and build a fresh one in its place.
  ///
  /// Guarded by [_isReinitializing] so a double-tap cannot dispose a controller
  /// that a still-running rebuild is about to hand back.
  Future<void> _reinitializePlayer({required bool play}) async {
    if (_isReinitializing) return;
    _isReinitializing = true;

    final old = _videoPlayerController;
    final oldChewie = _chewieController;

    // Drop the widgets referencing the old controller before disposing it, so
    // no frame is built against a dead texture.
    if (mounted) {
      setState(() {
        _chewieController = null;
      });
    }

    await oldChewie?.videoPlayerController.pause();
    oldChewie?.dispose();
    await old.dispose();

    if (!mounted) {
      _isReinitializing = false;
      return;
    }

    await _initializePlayer(autoPlayOverride: play);
    _isReinitializing = false;
  }

  /// Chewie exposes enterFullScreen/exitFullScreen but does not react to
  /// rotation itself, so drive it from the platform metrics.
  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    if (!widget.allowFullScreenLandscape || !mounted) return;
    final view = View.maybeOf(context);
    if (view == null) return;
    final size = view.physicalSize;
    final landscape = size.width > size.height;
    if (landscape == _isLandscape) return;
    _isLandscape = landscape;
    final controller = _chewieController;
    if (controller == null) return;
    if (landscape) {
      if (!controller.isFullScreen) controller.enterFullScreen();
    } else {
      if (controller.isFullScreen) controller.exitFullScreen();
    }
  }

  /// [autoPlayOverride] lets a rewatch force playback on the fresh controller
  /// even on a page that opted out of autoplay — the viewer asked for it.
  Future<void> _initializePlayer({bool? autoPlayOverride}) async {
    // The client owns its assets, so the path resolves from the consuming app's
    // root — no `packages/<name>/` prefixing.
    _videoPlayerController = VideoPlayerController.asset(widget.videoUrl);

    try {
      await _videoPlayerController.initialize();
      _videoPlayerController.setVolume(widget.enableAudio ? 1.0 : 0.0);
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: autoPlayOverride ?? widget.autoPlay,
        looping: widget.looping,
        aspectRatio: widget.aspectRatio,
        showControls: widget.showVideoControls,
        // Chewie otherwise reveals the full control bar ~200ms after init,
        // without any user interaction — it crowds the fixed-height video box.
        // Hidden until tapped; Chewie's own tap handler brings it back.
        showControlsOnInitialize: false,
        allowFullScreen: widget.allowFullScreenLandscape,
        deviceOrientationsOnEnterFullScreen: const [
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ],
        deviceOrientationsAfterFullScreen: const [DeviceOrientation.portraitUp],
        errorBuilder: (context, errorMessage) {
          return _buildErrorWidget();
        },
      );
      if (mounted) setState(() {});
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
        });
      }
    }
  }

  Widget _buildErrorWidget() {
    return const ColoredBox(
      color: TutorialsTheme.surfaceColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: TutorialsTheme.textSecondary,
              size: 42,
            ),
            SizedBox(height: 8),
            Text('Unable to load video', style: TutorialsTheme.bodyStyle),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _restartTick?.removeListener(_handleRestart);
    if (widget.allowFullScreenLandscape) {
      WidgetsBinding.instance.removeObserver(this);
      // Restore the app-wide portrait lock unconditionally — a missed restore
      // would leave every other screen rotatable until the app restarts.
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    }
    _chewieController?.dispose();
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return _buildErrorWidget();
    }

    if (_chewieController == null ||
        !_videoPlayerController.value.isInitialized) {
      return const ColoredBox(
        color: TutorialsTheme.surfaceColor,
        child: Center(
          child: CircularProgressIndicator(color: TutorialsTheme.accentColor),
        ),
      );
    }

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Chewie(controller: _chewieController!),
        // The resting-state affordance: since the control bar is hidden until
        // tapped, this slim indicator is all that shows progress the rest of
        // the time. Chewie's own scrub bar briefly overlays it in this position
        // while the controls are up, then fades back out.
        VideoProgressIndicator(
          _videoPlayerController,
          allowScrubbing: false,
          padding: EdgeInsets.zero,
          colors: VideoProgressColors(
            playedColor: Colors.white.withValues(alpha: 0.8),
            bufferedColor: Colors.white.withValues(alpha: 0.3),
            backgroundColor: Colors.white.withValues(alpha: 0.2),
          ),
        ),
        // Sits above Chewie's layer so it survives showVideoControls: false,
        // and in the corner so it never lands under Chewie's centre play
        // button when the controls are up.
        if (widget.showRewatchButton)
          Positioned(
            top: 8,
            right: 8,
            // Chewie's controls layer puts a full-bleed GestureDetector over
            // the video, and a Stack hit-tests children last-to-first only
            // while they are opaque to the test. Wrapping in its own
            // Listener-backed detector with opaque behaviour claims the tap
            // before Chewie's detector sees it.
            child: _buildRewatchButton(),
          ),
      ],
    );
  }

  Widget _buildRewatchButton() {
    return Semantics(
      button: true,
      label: 'Replay video',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _handleRewatch,
        child: Opacity(
          opacity: TutorialsTheme.navArrowOpacity,
          child: SizedBox(
            width: TutorialsTheme.rewatchButtonSize,
            height: TutorialsTheme.rewatchButtonSize,
            child: DecoratedBox(
              decoration: const BoxDecoration(
                color: TutorialsTheme.navArrowColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.replay,
                color: AppColors.white,
                size: TutorialsTheme.rewatchButtonIconSize,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
