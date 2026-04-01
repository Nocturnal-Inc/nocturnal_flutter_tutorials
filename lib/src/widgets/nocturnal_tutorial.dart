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
/// Both [NocturnalOnboardingWidget] and [ConnectToMaskWidget] delegate to this
/// widget internally.
class NocturnalTutorial extends StatelessWidget {
  // ── Welcome screen config ──

  /// Whether to show the welcome screen before the tutorial.
  /// Defaults to `true`.
  final bool showWelcomeScreen;

  /// Whether to show the logo on the welcome screen.
  /// When `false`, [headline] is displayed in place of the logo.
  final bool showLogo;

  /// Headline text displayed in place of the logo when [showLogo] is `false`.
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

  /// Label for the finish button shown on the last page.
  final String finishLabel;

  // ── Callbacks ──

  /// Called when the user taps the finish button on the last page.
  final VoidCallback? onComplete;

  /// Called when the user taps the close/skip button.
  final VoidCallback? onSkip;

  // ── Package ──

  /// Optional package name used to resolve assets.
  ///
  /// When this library is consumed as a dependency, pass
  /// `'nocturnal_flutter_tutorials'` so that Flutter looks for assets under
  /// `packages/nocturnal_flutter_tutorials/`. When running standalone, leave
  /// this `null` so assets resolve from the root `assets/` directory.
  final String? packageName;

  const NocturnalTutorial({
    super.key,
    this.showWelcomeScreen = true,
    this.showLogo = true,
    this.headline,
    this.subtitle = 'Better sleep starts here',
    this.skipLabel,
    this.buttonLabel = 'Get Started',
    required this.pages,
    this.showRestartButton = false,
    this.enableDragToScrub = false,
    this.showSectionLabel = false,
    this.finishLabel = 'Finish',
    this.onComplete,
    this.onSkip,
    this.packageName,
  });

  @override
  Widget build(BuildContext context) {
    if (!showWelcomeScreen) {
      return _NocturnalTutorialScreen(
        pages: pages,
        showRestartButton: showRestartButton,
        enableDragToScrub: enableDragToScrub,
        showSectionLabel: showSectionLabel,
        finishLabel: finishLabel,
        onComplete: onComplete,
        onSkip: onSkip,
        packageName: packageName,
      );
    }
    return _NocturnalWelcomeScreen(
      showLogo: showLogo,
      headline: headline,
      subtitle: subtitle,
      skipLabel: skipLabel,
      buttonLabel: buttonLabel,
      onSkip: onSkip,
      packageName: packageName,
      destinationBuilder: (context) => _NocturnalTutorialScreen(
        pages: pages,
        showRestartButton: showRestartButton,
        enableDragToScrub: enableDragToScrub,
        showSectionLabel: showSectionLabel,
        finishLabel: finishLabel,
        onComplete: onComplete,
        onSkip: onSkip,
        packageName: packageName,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Private: Welcome Screen
// ─────────────────────────────────────────────────────────────────────────────

class _NocturnalWelcomeScreen extends StatelessWidget {
  final bool showLogo;
  final String? headline;
  final String subtitle;
  final String? skipLabel;
  final String buttonLabel;
  final VoidCallback? onSkip;
  final String? packageName;
  final Widget Function(BuildContext context) destinationBuilder;

  const _NocturnalWelcomeScreen({
    required this.showLogo,
    required this.headline,
    required this.subtitle,
    required this.skipLabel,
    required this.buttonLabel,
    required this.onSkip,
    required this.destinationBuilder,
    this.packageName,
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
                if (showLogo)
                  Image.asset(
                    'assets/logo/Nocturnal.png',
                    package: packageName,
                    width: 200,
                    fit: BoxFit.contain,
                  )
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
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              TutorialsTheme.buttonBorderRadius,
                            ),
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

class _NocturnalTutorialScreen extends StatefulWidget {
  final List<TutorialPage> pages;
  final bool showRestartButton;
  final bool enableDragToScrub;
  final bool showSectionLabel;
  final String finishLabel;
  final VoidCallback? onComplete;
  final VoidCallback? onSkip;
  final String? packageName;

  const _NocturnalTutorialScreen({
    required this.pages,
    required this.showRestartButton,
    required this.enableDragToScrub,
    required this.showSectionLabel,
    required this.finishLabel,
    required this.onComplete,
    required this.onSkip,
    this.packageName,
  });

  @override
  State<_NocturnalTutorialScreen> createState() =>
      _NocturnalTutorialScreenState();
}

class _NocturnalTutorialScreenState extends State<_NocturnalTutorialScreen> {
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
            _entries.add(
              _ContentPageEntry(child.type as LeafPage, parentGroup: group),
            );
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
                        packageName: widget.packageName,
                      ),
                      _ContentPageEntry(:final leaf) => TutorialPageWidget(
                        leaf: leaf,
                        packageName: widget.packageName,
                      ),
                    };
                  },
                ),
              ),
              if (_isLastPage) ...[
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 16),
                  child: SizedBox(
                    width: 220,
                    height: 56,
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

    final indicator = Padding(
      padding: const EdgeInsets.only(bottom: 24, top: 8),
      child: SmoothPageIndicator(
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
      ),
    );

    if (!widget.enableDragToScrub) return indicator;

    return GestureDetector(
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
}
