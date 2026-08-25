import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:nocturnal_flutter_tutorials/src/models/tutorial_page.dart';
import 'package:nocturnal_flutter_tutorials/src/theme/tutorials_theme.dart';
import 'package:nocturnal_flutter_tutorials/src/widgets/amoeba_background.dart';
import 'package:nocturnal_flutter_tutorials/src/widgets/section_cover_page.dart';
import 'package:nocturnal_flutter_tutorials/src/widgets/tutorial_page_widget.dart';

/// A fully configurable onboarding widget that encapsulates an optional welcome
/// screen followed by a swipeable tutorial flow.
///
/// [pages] is a list of [TutorialPage] whose [type] is either [GroupPage]
/// (rendered as a section cover with child content pages) or [LeafPage]
/// (rendered directly as a content page).
///
/// The client owns the content: build a `List<TutorialPage>` and pass it in.
class TutorialBook extends StatelessWidget {
  // ── Welcome screen config ──

  /// Whether to show the welcome screen before the tutorial.
  /// Defaults to `true`.
  final bool showWelcomeScreen;

  /// Headline text shown when no [logo] is supplied.
  final String? headline;

  /// Subtitle text shown below the logo or headline on the welcome screen.
  final String subtitle;

  /// Label for an optional skip button on the welcome screen.
  /// When non-null a text button with this label is shown below "Get Started".
  final String? skipLabel;

  /// Label for the "Get Started" button on the welcome screen.
  final String buttonLabel;

  // ── Content ──

  /// Tutorial pages. Each entry's [type] may be a [GroupPage] (section cover +
  /// children) or a [LeafPage] (standalone content page).
  final List<TutorialPage> pages;

  // ── Tutorial screen features ──

  /// Whether to show a restart button on the last page.
  final bool showRestartButton;

  /// Whether swiping on the dot indicator scrubs through pages.
  final bool enableDragToScrub;

  /// Whether to show the current section label in the top bar.
  /// Only applies when pages contain [GroupPage] entries.
  final bool showSectionLabel;

  /// Whether to show previous/next arrow buttons flanking the dot indicator.
  /// Defaults to `true` — set `false` to rely on swiping alone.
  final bool showNavigationArrows;

  /// Label for the finish button shown on the last page.
  final String finishLabel;

  // ── Callbacks ──

  /// Called when the user taps the finish button on the last page.
  final VoidCallback? onComplete;

  /// Called when the user taps the close/skip button.
  final VoidCallback? onSkip;

  // ── Branding ──

  /// Client-supplied brand mark shown on the welcome screen.
  ///
  /// The package owns no assets, so the logo is injected. When null, [headline]
  /// is shown instead.
  final Widget? logo;

  const TutorialBook({
    super.key,
    this.showWelcomeScreen = true,
    this.logo,
    this.headline,
    this.subtitle = '',
    this.skipLabel,
    this.buttonLabel = 'Get Started',
    required this.pages,
    this.showRestartButton = false,
    this.enableDragToScrub = false,
    this.showSectionLabel = false,
    this.showNavigationArrows = true,
    this.finishLabel = 'Finish',
    this.onComplete,
    this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    if (!showWelcomeScreen) {
      return _TutorialBookScreen(
        pages: pages,
        showRestartButton: showRestartButton,
        enableDragToScrub: enableDragToScrub,
        showSectionLabel: showSectionLabel,
        showNavigationArrows: showNavigationArrows,
        finishLabel: finishLabel,
        onComplete: onComplete,
        onSkip: onSkip,
      );
    }
    return _TutorialBookWelcomeScreen(
      logo: logo,
      headline: headline,
      subtitle: subtitle,
      skipLabel: skipLabel,
      buttonLabel: buttonLabel,
      onSkip: onSkip,
      destinationBuilder: (context) => _TutorialBookScreen(
        pages: pages,
        showRestartButton: showRestartButton,
        enableDragToScrub: enableDragToScrub,
        showSectionLabel: showSectionLabel,
        showNavigationArrows: showNavigationArrows,
        finishLabel: finishLabel,
        onComplete: onComplete,
        onSkip: onSkip,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Private: Welcome Screen
// ─────────────────────────────────────────────────────────────────────────────

class _TutorialBookWelcomeScreen extends StatelessWidget {
  final Widget? logo;
  final String? headline;
  final String subtitle;
  final String? skipLabel;
  final String buttonLabel;
  final VoidCallback? onSkip;
  final Widget Function(BuildContext context) destinationBuilder;

  const _TutorialBookWelcomeScreen({
    required this.logo,
    required this.headline,
    required this.subtitle,
    required this.skipLabel,
    required this.buttonLabel,
    required this.onSkip,
    required this.destinationBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const AmoebaBackground(),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (logo != null)
                  logo!
                else
                  Text(
                    headline ?? '',
                    style: TutorialsTheme.headingStyle,
                    textAlign: TextAlign.center,
                  ),
                const SizedBox(height: 24),
                Text(
                  subtitle,
                  style: TutorialsTheme.subheadingStyle.copyWith(
                    color: TutorialsTheme.textSecondary.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(height: 60),
                SizedBox(
                      width: 180,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: destinationBuilder),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: TutorialsTheme.buttonColor,
                          foregroundColor: TutorialsTheme.buttonTextColor,
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                TutorialsTheme.buttonBorderRadiusShape,
                          ),
                          elevation: 4,
                        ),
                        child: Text(
                          buttonLabel,
                          style: TutorialsTheme.buttonTextStyle,
                        ),
                      ),
                    )
                    .animate()
                    .fadeIn(
                      delay: const Duration(milliseconds: 600),
                      duration: const Duration(milliseconds: 800),
                    )
                    .slideY(
                      begin: 0.3,
                      end: 0,
                      delay: const Duration(milliseconds: 600),
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.easeOut,
                    ),
                if (skipLabel != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: TextButton(
                      onPressed: onSkip,
                      child: Text(
                        skipLabel!,
                        style: TutorialsTheme.subheadingStyle.copyWith(
                          color: TutorialsTheme.textSecondary,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ).animate().fadeIn(
                    delay: const Duration(milliseconds: 900),
                    duration: const Duration(milliseconds: 800),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Private: Tutorial Screen
// ─────────────────────────────────────────────────────────────────────────────

/// Internal type to unify section-based entries and flat page entries.
sealed class _PageEntry {
  const _PageEntry();
}

class _SectionCoverEntry extends _PageEntry {
  final GroupPage group;
  const _SectionCoverEntry(this.group);
}

class _ContentPageEntry extends _PageEntry {
  final LeafPage leaf;
  final GroupPage? parentGroup;
  const _ContentPageEntry(this.leaf, {this.parentGroup});
}

class _TutorialBookScreen extends StatefulWidget {
  final List<TutorialPage> pages;
  final bool showRestartButton;
  final bool enableDragToScrub;
  final bool showSectionLabel;
  final bool showNavigationArrows;
  final String finishLabel;
  final VoidCallback? onComplete;
  final VoidCallback? onSkip;

  const _TutorialBookScreen({
    required this.pages,
    required this.showRestartButton,
    required this.enableDragToScrub,
    required this.showSectionLabel,
    required this.showNavigationArrows,
    required this.finishLabel,
    required this.onComplete,
    required this.onSkip,
  });

  @override
  State<_TutorialBookScreen> createState() => _TutorialBookScreenState();
}

class _TutorialBookScreenState extends State<_TutorialBookScreen> {
  static const double _kDotScrubSensitivity = 2.0;

  late final PageController _pageController;
  int _currentPage = 0;
  double _indicatorDragAccumulator = 0.0;

  late final List<_PageEntry> _entries;
  late final int _totalPages;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    _entries = [];
    for (final page in widget.pages) {
      switch (page.type) {
        case GroupPage group:
          _entries.add(_SectionCoverEntry(group));
          for (final child in group.children) {
            _entries.add(_ContentPageEntry(child, parentGroup: group));
          }
        case LeafPage leaf:
          _entries.add(_ContentPageEntry(leaf));
      }
    }
    _totalPages = _entries.length;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  bool get _isLastPage => _currentPage == _totalPages - 1;

  void _goToPage(int index) {
    if (index < 0 || index >= _totalPages) return;
    _pageController.animateToPage(
      index,
      duration: TutorialsTheme.pageTransitionDuration,
      curve: Curves.easeInOut,
    );
  }

  void _finish() {
    if (widget.onComplete != null) {
      widget.onComplete!();
    } else {
      Navigator.of(context).pop();
    }
  }

  void _restart() {
    _goToPage(0);
    setState(() {
      _currentPage = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: TutorialsTheme.backgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              _buildTopBar(),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _totalPages,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    final entry = _entries[index];
                    return switch (entry) {
                      _SectionCoverEntry(:final group) => SectionCoverPage(
                        group: group,
                      ),
                      _ContentPageEntry(:final leaf) => TutorialPageWidget(
                        leaf: leaf,
                      ),
                    };
                  },
                ),
              ),
              if (_isLastPage) ...[
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 16),
                  child: SizedBox(
                    width: 180,
                    child: ElevatedButton(
                      onPressed: _finish,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TutorialsTheme.buttonColor,
                        foregroundColor: TutorialsTheme.buttonTextColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            TutorialsTheme.buttonBorderRadius,
                          ),
                        ),
                        elevation: 4,
                      ),
                      child: Text(
                        widget.finishLabel,
                        style: TutorialsTheme.buttonTextStyle,
                      ),
                    ),
                  ),
                ),
                if (widget.showRestartButton)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: TextButton(
                      onPressed: _restart,
                      child: Text(
                        'Restart',
                        style: TutorialsTheme.subheadingStyle.copyWith(
                          color: TutorialsTheme.textSecondary,
                        ),
                      ),
                    ),
                  ),
              ],
              _buildBottomIndicator(),
            ],
          ),
        ),
      ),
    );
  }

  String? get _currentSectionName {
    if (!widget.showSectionLabel) return null;
    final entry = _entries[_currentPage];
    return switch (entry) {
      _ContentPageEntry(:final parentGroup) => parentGroup?.title,
      _SectionCoverEntry() => null,
    };
  }

  Widget _buildTopBar() {
    final sectionName = _currentSectionName;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          widget.onSkip != null
              ? IconButton(
                  onPressed: widget.onSkip!,
                  icon: const Icon(
                    Icons.close,
                    color: TutorialsTheme.textSecondary,
                  ),
                )
              : const SizedBox(width: 48),
          if (widget.showSectionLabel)
            Opacity(
              opacity: sectionName != null ? 1.0 : 0.0,
              child: Text(
                sectionName ?? '',
                style: TutorialsTheme.pageCounterStyle.copyWith(
                  color: TutorialsTheme.textSecondary.withValues(alpha: 0.5),
                  fontSize: 12,
                ),
              ),
            )
          else
            const SizedBox.shrink(),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildBottomIndicator() {
    const double dotPitch = TutorialsTheme.dotSize + TutorialsTheme.dotSpacing;

    Widget indicator = SmoothPageIndicator(
      controller: _pageController,
      count: _totalPages,
      effect: ScrollingDotsEffect(
        dotWidth: TutorialsTheme.dotSize,
        dotHeight: TutorialsTheme.dotSize,
        spacing: TutorialsTheme.dotSpacing,
        activeDotColor: TutorialsTheme.dotActiveColor,
        dotColor: TutorialsTheme.dotInactiveColor,
      ),
      onDotClicked: _goToPage,
    );

    // The scrub gesture stays bound to the dots alone. Wrapping the whole row
    // would put its horizontal drag recognizer in competition with the arrow
    // taps sitting on either side.
    if (widget.enableDragToScrub) {
      indicator = GestureDetector(
        behavior: HitTestBehavior.opaque,
        onHorizontalDragStart: (_) {
          _indicatorDragAccumulator = 0.0;
        },
        onHorizontalDragUpdate: (details) {
          _indicatorDragAccumulator += details.delta.dx * _kDotScrubSensitivity;

          while (_indicatorDragAccumulator <= -dotPitch) {
            _indicatorDragAccumulator += dotPitch;
            final nextPage = _currentPage + 1;
            if (nextPage < _totalPages) {
              _goToPage(nextPage);
            }
          }

          while (_indicatorDragAccumulator >= dotPitch) {
            _indicatorDragAccumulator -= dotPitch;
            final prevPage = _currentPage - 1;
            if (prevPage >= 0) {
              _goToPage(prevPage);
            }
          }
        },
        child: indicator,
      );
    }

    const padding = EdgeInsets.only(bottom: 24, top: 8);

    if (!widget.showNavigationArrows) {
      return Padding(padding: padding, child: indicator);
    }

    // Inset the row so the arrows sit off the screen edge, matching the
    // horizontal rhythm of the top bar.
    const rowPadding = EdgeInsets.fromLTRB(16, 8, 16, 24);

    // Absent arrows leave an equal-width gap behind, which is what keeps the
    // dots optically centred as the first and last pages come and go.
    return Padding(
      padding: rowPadding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildNavArrow(
            icon: Icons.arrow_back_ios_new,
            semanticLabel: 'Previous page',
            onTap: _currentPage > 0 ? () => _goToPage(_currentPage - 1) : null,
          ),
          Flexible(child: indicator),
          _buildNavArrow(
            icon: Icons.arrow_forward_ios,
            semanticLabel: 'Next page',
            onTap: _isLastPage ? null : () => _goToPage(_currentPage + 1),
          ),
        ],
      ),
    );
  }

  /// One circular arrow button, or an equal-width spacer when [onTap] is null
  /// (the first page has no previous, the last page has no next).
  Widget _buildNavArrow({
    required IconData icon,
    required String semanticLabel,
    required VoidCallback? onTap,
  }) {
    const size = TutorialsTheme.navArrowSize;

    if (onTap == null) {
      return const SizedBox(width: size, height: size);
    }

    return Semantics(
      button: true,
      label: semanticLabel,
      child: GestureDetector(
        onTap: onTap,
        // Opacity wraps the circle and the glyph together; fading only the
        // circle colour would leave a full-strength white arrow on top.
        child: Opacity(
          opacity: TutorialsTheme.navArrowOpacity,
          child: SizedBox(
            width: size,
            height: size,
            child: DecoratedBox(
              decoration: const BoxDecoration(
                color: TutorialsTheme.navArrowColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.white, size: 20),
            ),
          ),
        ),
      ),
    );
  }
}
