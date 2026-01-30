import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:nocturnal_onboarding/src/models/tutorial_page.dart';
import 'package:nocturnal_onboarding/src/theme/tutorials_theme.dart';
import 'package:nocturnal_onboarding/src/widgets/video_player_widget.dart';

class TutorialPageWidget extends StatelessWidget {
  final TutorialPage page;

  const TutorialPageWidget({super.key, required this.page});

  @override
  Widget build(BuildContext context) {
    return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: TutorialsTheme.pagePadding,
          ),
          child: page.isScrollable
              ? SingleChildScrollView(child: _buildContent())
              : _buildContent(),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: Text(
            page.title,
            style: TutorialsTheme.headingStyle,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 24),
        _buildMediaArea(),
        if (page.instructionPoints.isNotEmpty) ...[
          const SizedBox(height: 24),
          _buildInstructionPoints(),
        ],
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildMediaArea() {
    switch (page.contentType) {
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
    if (page.imagePath != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(TutorialsTheme.cardBorderRadius),
        child: Image.asset(
          page.imagePath!,
          width: double.infinity,
          height: 240,
          fit: BoxFit.cover,
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
      decoration: BoxDecoration(
        color: TutorialsTheme.surfaceColor,
        borderRadius: BorderRadius.circular(TutorialsTheme.cardBorderRadius),
        border: Border.all(
          color: TutorialsTheme.dotInactiveColor.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            page.placeholderIcon ?? Icons.image,
            size: TutorialsTheme.placeholderIconSize,
            color: TutorialsTheme.accentColor.withValues(alpha: 0.6),
          ),
          const SizedBox(height: 12),
          Text(
            'Media coming soon',
            style: TutorialsTheme.bodyStyle.copyWith(
              color: TutorialsTheme.textSecondary.withValues(alpha: 0.6),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoArea() {
    if (page.videoUrl != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(TutorialsTheme.cardBorderRadius),
        child: SizedBox(
          width: double.infinity,
          height: 240,
          child: VideoPlayerWidget(videoUrl: page.videoUrl!),
        ),
      );
    }
    return _buildPlaceholder();
  }

  Widget _buildPortraitVideoArea() {
    if (page.videoUrl != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(TutorialsTheme.cardBorderRadius),
        child: SizedBox(
          width: double.infinity,
          height: 300,
          child: VideoPlayerWidget(
            videoUrl: page.videoUrl!,
            aspectRatio: 9 / 16,
          ),
        ),
      );
    }
    return _buildPlaceholder();
  }

  Widget _buildGifArea() {
    if (page.gifPath != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(TutorialsTheme.cardBorderRadius),
        child: Image.asset(
          page.gifPath!,
          width: double.infinity,
          height: 240,
          fit: BoxFit.cover,
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
        if (page.videoUrl != null) ...[
          const SizedBox(height: 16),
          _buildVideoArea(),
        ],
      ],
    );
  }

  Widget _buildInstructionPoints() {
    return Column(
      children: [
        for (int i = 0; i < page.instructionPoints.length; i++) ...[
          if (i > 0) const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                Text(
                  page.instructionPoints[i].headline,
                  style: TutorialsTheme.instructionHeadlineStyle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  page.instructionPoints[i].description,
                  style: TutorialsTheme.instructionDescriptionStyle,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
