import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:nocturnal_onboarding/src/models/connect_to_mask_content.dart';
import 'package:nocturnal_onboarding/src/models/tutorial_page.dart';
import 'package:nocturnal_onboarding/src/theme/tutorials_theme.dart';
import 'package:nocturnal_onboarding/src/widgets/tutorial_page_widget.dart';

/// Internal screen for the mask-connection tutorial flow.
///
/// Displays [ConnectToMaskContent.pages] in a swipeable [PageView] with a
/// dot indicator and a "Finish" button on the last page.
class ConnectToMaskScreen extends StatefulWidget {
  final VoidCallback? onComplete;
  final VoidCallback? onSkip;
  final String finishLabel;

  const ConnectToMaskScreen({
    super.key,
    this.onComplete,
    this.onSkip,
    this.finishLabel = 'Finish',
  });

  @override
  State<ConnectToMaskScreen> createState() => _ConnectToMaskScreenState();
}

class _ConnectToMaskScreenState extends State<ConnectToMaskScreen> {
  late final PageController _pageController;
  int _currentPage = 0;

  static const List<TutorialPage> _pages = ConnectToMaskContent.pages;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  bool get _isLastPage => _currentPage == _pages.length - 1;

  void _finish() {
    if (widget.onComplete != null) {
      widget.onComplete!();
    } else {
      Navigator.of(context).pop();
    }
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
                  itemCount: _pages.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return TutorialPageWidget(page: _pages[index]);
                  },
                ),
              ),
              if (_isLastPage)
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
              _buildBottomIndicator(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
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
          const SizedBox(width: 48),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildBottomIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24, top: 8),
      child: SmoothPageIndicator(
        controller: _pageController,
        count: _pages.length,
        effect: ScrollingDotsEffect(
          dotWidth: TutorialsTheme.dotSize,
          dotHeight: TutorialsTheme.dotSize,
          spacing: TutorialsTheme.dotSpacing,
          activeDotColor: TutorialsTheme.dotActiveColor,
          dotColor: TutorialsTheme.dotInactiveColor,
        ),
      ),
    );
  }
}
