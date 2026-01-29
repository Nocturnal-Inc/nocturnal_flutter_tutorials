import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:nocturnal_onboarding/src/models/book_entry.dart';
import 'package:nocturnal_onboarding/src/models/section_type.dart';
import 'package:nocturnal_onboarding/src/models/tutorial_content.dart';
import 'package:nocturnal_onboarding/src/models/tutorial_section.dart';
import 'package:nocturnal_onboarding/src/theme/tutorials_theme.dart';
import 'package:nocturnal_onboarding/src/widgets/section_cover_page.dart';
import 'package:nocturnal_onboarding/src/widgets/tutorial_page_widget.dart';

class TutorialBook extends StatefulWidget {
  final VoidCallback? onComplete;
  final VoidCallback? onSkip;
  final Set<SectionType> disabledSections;
  final bool showPageNumber;
  final bool showRestartButton;
  final String finishLabel;

  const TutorialBook({
    super.key,
    this.onComplete,
    this.onSkip,
    this.disabledSections = const {},
    this.showPageNumber = false,
    this.showRestartButton = false,
    this.finishLabel = 'Finish',
  });

  @override
  State<TutorialBook> createState() => _TutorialBookState();
}

class _TutorialBookState extends State<TutorialBook> {
  static const double _kDotScrubSensitivity = 2.0;

  late final PageController _pageController;
  int _currentPage = 0;
  double _indicatorDragAccumulator = 0.0;

  late final List<TutorialSection> _sections;
  late final List<BookEntry> _entries;
  late final int _totalPages;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    _sections = TutorialContent.filteredSections(widget.disabledSections);

    // Build flat list: section cover + content pages for each section
    _entries = [];
    for (final section in _sections) {
      _entries.add(SectionCover(section));
      for (final page in section.pages) {
        _entries.add(ContentPage(page, section));
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
                      SectionCover(:final section) =>
                        SectionCoverPage(section: section),
                      ContentPage(:final page) =>
                        TutorialPageWidget(page: page),
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
    final entry = _entries[_currentPage];
    return switch (entry) {
      ContentPage(:final section) => section.sectionTitle,
      SectionCover() => null,
    };
  }

  Widget _buildTopBar() {
    final sectionName = _currentSectionName;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      child: Column(
        children: [
          Row(
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
              // Page counter (optional, hidden by default)
              if (widget.showPageNumber)
                Text(
                  '${_currentPage + 1}/$_totalPages',
                  style: TutorialsTheme.pageCounterStyle,
                )
              else
                const SizedBox(width: 48),
              // Invisible placeholder to keep the counter centered
              const SizedBox(width: 48),
            ],
          ),
          Opacity(
            opacity: sectionName != null ? 1.0 : 0.0,
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                sectionName ?? '',
                style: TutorialsTheme.pageCounterStyle.copyWith(
                  color: TutorialsTheme.textSecondary.withValues(alpha: 0.5),
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomIndicator() {
    const double dotPitch = TutorialsTheme.dotSize + TutorialsTheme.dotSpacing;

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
      child: Padding(
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
      ),
    );
  }
}
