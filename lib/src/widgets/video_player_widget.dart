import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:nocturnal_flutter_tutorials/src/theme/tutorials_theme.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final bool autoPlay;
  final bool looping;
  final double aspectRatio;
  final String? packageName;

  const VideoPlayerWidget({
    super.key,
    required this.videoUrl,
    this.autoPlay = true,
    this.looping = true,
    this.aspectRatio = 16 / 9,
    this.packageName,
  });

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    final path = widget.packageName != null
        ? 'packages/${widget.packageName}/${widget.videoUrl}'
        : widget.videoUrl;
    _videoPlayerController = VideoPlayerController.asset(path);

    try {
      await _videoPlayerController.initialize();
      _videoPlayerController.setVolume(0);
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: widget.autoPlay,
        looping: widget.looping,
        aspectRatio: widget.aspectRatio,
        showControls: false,
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
    return Container(
      color: TutorialsTheme.surfaceColor,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: TutorialsTheme.textSecondary,
              size: 42,
            ),
            SizedBox(height: 8),
            Text(
              'Unable to load video',
              style: TutorialsTheme.bodyStyle,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
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
      return Container(
        color: TutorialsTheme.surfaceColor,
        child: const Center(
          child: CircularProgressIndicator(
            color: TutorialsTheme.accentColor,
          ),
        ),
      );
    }

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Chewie(controller: _chewieController!),
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
