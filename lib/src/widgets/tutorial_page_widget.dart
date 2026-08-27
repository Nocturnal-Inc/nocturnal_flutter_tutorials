import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:nocturnal_flutter_tutorials/src/models/instruction_point.dart';
import 'package:nocturnal_flutter_tutorials/src/models/tutorial_page.dart';
import 'package:nocturnal_flutter_tutorials/src/theme/tutorials_theme.dart';
import 'package:nocturnal_flutter_tutorials/src/widgets/tutorial_restart_scope.dart';
import 'package:nocturnal_flutter_tutorials/src/widgets/video_player_widget.dart';

class TutorialPageWidget extends StatefulWidget {
  final LeafPage leaf;

  const TutorialPageWidget({super.key, required this.leaf});

  @override
  State<TutorialPageWidget> createState() => _TutorialPageWidgetState();
}

class _TutorialPageWidgetState extends State<TutorialPageWidget> {
  LeafPage get leaf => widget.leaf;

  ScrollController? _scrollController;
  bool _isAtBottom = false;

  /// See [_VideoPlayerWidgetState] for the same pattern — the scroll offset
  /// survives page reuse just as video position does.
  ValueNotifier<int>? _restartTick;

  @override
  void initState() {
    super.initState();
    if (leaf.isScrollable) {
      _scrollController = ScrollController();
      _scrollController!.addListener(_onScroll);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final tick = TutorialRestartScope.maybeOf(context);
    if (identical(tick, _restartTick)) return;
    _restartTick?.removeListener(_handleRestart);
    _restartTick = tick;
    _restartTick?.addListener(_handleRestart);
  }

  /// Send a reused page back to the top; [PageView] keeps it alive, so it would
  /// otherwise reopen wherever the viewer had scrolled to.
  void _handleRestart() {
    final controller = _scrollController;
    if (controller == null || !controller.hasClients) return;
    controller.jumpTo(0);
  }

  @override
  void dispose() {
    _restartTick?.removeListener(_handleRestart);
    _scrollController?.removeListener(_onScroll);
    _scrollController?.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController == null) return;
    final atBottom =
        _scrollController!.offset >=
        _scrollController!.position.maxScrollExtent - 20;
    if (atBottom != _isAtBottom) {
      setState(() => _isAtBottom = atBottom);
    }
  }

  void _scrollDownHalfPage() {
    if (_scrollController == null) return;
    final viewportHeight = _scrollController!.position.viewportDimension;
    final target = (_scrollController!.offset + viewportHeight / 2).clamp(
      0.0,
      _scrollController!.position.maxScrollExtent,
    );
    _scrollController!.animateTo(
      target,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: TutorialsTheme.pagePadding,
          ),
          child: leaf.isScrollable
              ? Stack(
                  children: [
                    SingleChildScrollView(
                      controller: _scrollController,
                      child: _buildContent(),
                    ),
                    Positioned(
                      bottom: 16,
                      right: 0,
                      child: AnimatedOpacity(
                        opacity: _isAtBottom ? 0.0 : 1.0,
                        duration: const Duration(milliseconds: 200),
                        child: GestureDetector(
                          onTap: _isAtBottom ? null : _scrollDownHalfPage,
                          child: const SizedBox(
                            width: 40,
                            height: 40,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: TutorialsTheme.scrollDownButtonColor,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.keyboard_arrow_down,
                                color: AppColors.white,
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : SingleChildScrollView(child: _buildContent()),
        )
        .animate()
        .fadeIn(duration: TutorialsTheme.entryAnimationDuration)
        .slideX(
          begin: 0.05,
          end: 0,
          duration: TutorialsTheme.entryAnimationDuration,
          curve: Curves.easeOut,
        );
  }

  Widget _buildContent() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: TutorialsTheme.contentMaxWidth,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: Text(
                leaf.title,
                style: TutorialsTheme.headingStyle,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 12),
            _buildMediaArea(),
            ...[const SizedBox(height: 24), _buildInstructionContent()],
            if (leaf.footerText != null) ...[
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: Text(
                  leaf.footerText!,
                  style: TutorialsTheme.instructionDescriptionStyle.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaArea() {
    switch (leaf.contentType) {
      case ContentType.text:
        return const SizedBox.shrink();
      case ContentType.textAndImage:
        return _buildImageOrPlaceholder();
      case ContentType.video:
        return _buildVideoArea();
      case ContentType.portraitVideo:
        return _buildPortraitVideoArea();
      case ContentType.gif:
        return _buildGifArea();
      case ContentType.mixed:
        return _buildMixedArea();
    }
  }

  Widget _buildImageOrPlaceholder() {
    if (leaf.imagePath != null) {
      return ClipRRect(
        borderRadius: TutorialsTheme.cardBorderRadiusShape,
        child: Image.asset(
          leaf.imagePath!,
          width: double.infinity,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => _buildPlaceholder(),
        ),
      );
    }
    return _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    return Container(
      width: double.infinity,
      height: 240,
      decoration: const BoxDecoration(
        color: TutorialsTheme.surfaceColor,
        borderRadius: TutorialsTheme.cardBorderRadiusShape,
        border: Border.fromBorderSide(
          BorderSide(color: TutorialsTheme.placeholderBorderColor),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            leaf.placeholderIcon ?? Icons.image,
            size: TutorialsTheme.placeholderIconSize,
            color: TutorialsTheme.placeholderIconColor,
          ),
          const SizedBox(height: 12),
          Text(
            'Media coming soon',
            style: TutorialsTheme.bodyStyle.copyWith(
              color: TutorialsTheme.placeholderTextColor,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoArea() {
    if (leaf.videoUrl != null) {
      return ClipRRect(
        borderRadius: TutorialsTheme.cardBorderRadiusShape,
        child: SizedBox(
          width: double.infinity,
          height: 240,
          child: VideoPlayerWidget(
            videoUrl: leaf.videoUrl!,
            enableAudio: leaf.enableAudio,
            allowFullScreenLandscape: leaf.allowFullScreenLandscape,
            showVideoControls: leaf.showVideoControls,
            showRewatchButton: leaf.showRewatchButton,
            looping: leaf.looping,
            autoPlay: leaf.autoPlay,
          ),
        ),
      );
    }
    return _buildPlaceholder();
  }

  Widget _buildPortraitVideoArea() {
    if (leaf.videoUrl != null) {
      return ClipRRect(
        borderRadius: TutorialsTheme.cardBorderRadiusShape,
        child: SizedBox(
          width: double.infinity,
          height: 300,
          child: VideoPlayerWidget(
            videoUrl: leaf.videoUrl!,
            aspectRatio: 9 / 16,
            enableAudio: leaf.enableAudio,
            allowFullScreenLandscape: leaf.allowFullScreenLandscape,
            showVideoControls: leaf.showVideoControls,
            showRewatchButton: leaf.showRewatchButton,
            looping: leaf.looping,
            autoPlay: leaf.autoPlay,
          ),
        ),
      );
    }
    return _buildPlaceholder();
  }

  Widget _buildGifArea() {
    if (leaf.gifPath != null) {
      return ClipRRect(
        borderRadius: TutorialsTheme.cardBorderRadiusShape,
        child: Image.asset(
          leaf.gifPath!,
          width: double.infinity,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => _buildPlaceholder(),
        ),
      );
    }
    return _buildPlaceholder();
  }

  Widget _buildMixedArea() {
    return Column(
      children: [
        _buildImageOrPlaceholder(),
        if (leaf.videoUrl != null) ...[
          const SizedBox(height: 16),
          _buildVideoArea(),
        ],
      ],
    );
  }

  Widget _buildInstructionContent() {
    return switch (leaf.instructionContent) {
      DetailedInstructions(:final points) => Column(
        children: [
          for (int i = 0; i < points.length; i++) ...[
            if (i > 0) const SizedBox(height: 28),
            switch (points[i]) {
              final InstructionPoint point => _buildPoint(point),
              BulletPoints(:final bullets) => _buildBullets(bullets),
            },
          ],
        ],
      ),
      BulletPoints(:final bullets) => _buildBullets(bullets),
    };
  }

  Widget _buildPoint(InstructionPoint point) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          if (point.headline != null)
            Text(
              point.headline!,
              style: TutorialsTheme.instructionHeadlineStyle,
              textAlign: TextAlign.center,
            ),
          if (point.description != null) ...[
            if (point.headline != null) const SizedBox(height: 4),
            Text(
              point.description!,
              style: TutorialsTheme.instructionDescriptionStyle,
              textAlign: TextAlign.center,
            ),
          ],
          if (point.tip != null) ...[
            if (point.headline != null || point.description != null)
              const SizedBox(height: 4),
            Text(
              point.tip!,
              style: TutorialsTheme.instructionDescriptionStyle.copyWith(
                fontStyle: FontStyle.italic,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  /// Shared by standalone and nested bullet lists; 12px apart, tighter than the 28px between items.
  Widget _buildBullets(List<Bullet> bullets) {
    const style = TutorialsTheme.instructionDescriptionStyle;
    return Column(
      children: [
        for (int i = 0; i < bullets.length; i++) ...[
          if (i > 0) const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nudges the 6px dot onto the cap-height of the first line (14px text, 1.5 line-height).
              const Padding(
                padding: EdgeInsets.only(top: 7),
                child: SizedBox(
                  width: 6,
                  height: 6,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: TutorialsTheme.bulletColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    children: [
                      if (bullets[i].label != null)
                        TextSpan(
                          text: "${bullets[i].label}: ",
                          // w600, not bold: Poppins ships only 400/600, so w700 silently falls back.
                          style: style.copyWith(fontWeight: FontWeight.w600),
                        ),
                      TextSpan(text: bullets[i].text),
                    ],
                  ),
                  style: style,
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
