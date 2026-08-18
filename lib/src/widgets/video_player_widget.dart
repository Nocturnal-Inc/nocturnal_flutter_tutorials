import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:nocturnal_flutter_tutorials/src/theme/tutorials_theme.dart';

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

  const VideoPlayerWidget({
    super.key,
    required this.videoUrl,
    required this.autoPlay,
    required this.looping,
    this.aspectRatio = 16 / 9,
    this.enableAudio = false,
    this.allowFullScreenLandscape = false,
    this.showVideoControls = true,
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

  Future<void> _initializePlayer() async {
    // The client owns its assets, so the path resolves from the consuming app's
    // root — no `packages/<name>/` prefixing.
    _videoPlayerController = VideoPlayerController.asset(widget.videoUrl);

    try {
      await _videoPlayerController.initialize();
      _videoPlayerController.setVolume(widget.enableAudio ? 1.0 : 0.0);
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: widget.autoPlay,
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
      ],
    );
  }
}
