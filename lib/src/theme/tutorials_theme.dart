import 'package:flutter/material.dart';

/// Colors matching nocturnal_mobile's AppColors.
class AppColors {
  // Gradient Colors
  static const Color yellow = Color.fromRGBO(253, 154, 97, 1);
  static const Color magenta = Color.fromRGBO(178, 66, 92, 1);
  static const Color violet = Color.fromRGBO(91, 32, 128, 1);
  static const Color darkPurple = Color.fromRGBO(72, 53, 135, 1);
  static const Color darkBlue = Color.fromRGBO(39, 46, 123, 1);

  // Accent Colors
  static const Color navyBlue = Color.fromRGBO(19, 21, 78, 1);
  static const Color white = Color.fromRGBO(255, 255, 255, 1);
  static const Color lightPink = Color.fromRGBO(255, 214, 224, 1);
  static const Color lightYellow = Color.fromRGBO(254, 225, 166, 1);
  static const Color lightBlue = Color.fromRGBO(219, 225, 255, 1);
  static const Color gray = Color.fromRGBO(107, 107, 107, 1);

  // Status Colors
  static const Color green = Color.fromRGBO(90, 163, 93, 1);
  static const Color lightGreen = Color.fromRGBO(144, 238, 144, 1);
  static const Color red = Color.fromRGBO(160, 40, 56, 1);

  static const Color glossyBlack = Color.fromRGBO(0, 0, 0, 1);
}

/// Gradients matching nocturnal_mobile's AppGradients.
class AppGradients {
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      AppColors.yellow,
      AppColors.magenta,
      AppColors.violet,
      AppColors.darkPurple,
      AppColors.darkBlue,
    ],
    stops: [0.0, 0.25, 0.5, 0.75, 1.0],
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      AppColors.darkBlue,
      AppColors.darkPurple,
      AppColors.violet,
      AppColors.magenta,
      AppColors.yellow,
    ],
    stops: [0.0, 0.25, 0.5, 0.75, 1.0],
  );

  static const LinearGradient redSunset = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [AppColors.magenta, AppColors.violet, AppColors.darkBlue],
    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient sunrise = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [AppColors.yellow, AppColors.magenta, AppColors.violet],
    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient night = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [AppColors.darkBlue, AppColors.darkPurple, AppColors.violet],
    stops: [0.0, 0.5, 1.0],
  );
}

class TutorialsTheme {
  static const String fontFamily = 'Poppins';

  // Colors — derived from nocturnal_mobile palette
  static const Color primaryColor = AppColors.navyBlue;
  static const Color accentColor = AppColors.violet;
  static const Color surfaceColor = AppColors.darkBlue;
  static const Color backgroundColor = AppColors.glossyBlack;
  static const Color textPrimary = AppColors.white;
  static const Color textSecondary = AppColors.lightBlue;
  static const Color dotActiveColor = AppColors.yellow;
  static const Color dotInactiveColor = AppColors.darkPurple;
  static const Color buttonColor = AppColors.magenta;
  static const Color buttonTextColor = AppColors.white;

  // Amoeba blob colors — semi-transparent versions of the gradient palette
  static const List<Color> blobColors = [
    Color.fromRGBO(253, 154, 97, 0.25), // yellow
    Color.fromRGBO(178, 66, 92, 0.20), // magenta
    Color.fromRGBO(91, 32, 128, 0.22), // violet
    Color.fromRGBO(72, 53, 135, 0.18), // darkPurple
  ];

  // Text styles — Poppins, matching nocturnal_mobile text theme sizing
  static const TextStyle headingStyle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 26,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    height: 1.3,
  );

  static const TextStyle subheadingStyle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.normal,
    color: textSecondary,
    height: 1.4,
  );

  static const TextStyle bodyStyle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: textSecondary,
    height: 1.6,
  );

  static const TextStyle sectionTitleStyle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.yellow,
    letterSpacing: 1.2,
  );

  static const TextStyle pageCounterStyle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: textSecondary,
  );

  static const TextStyle buttonTextStyle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: buttonTextColor,
  );

  static const TextStyle instructionHeadlineStyle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    height: 1.4,
  );

  static const TextStyle instructionDescriptionStyle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: textSecondary,
    height: 1.5,
  );

  // Dimensions
  static const double pagePadding = 24.0;
  static const double dotSize = 8.0;
  static const double dotSpacing = 10.0;
  static const double buttonBorderRadius = 30.0;
  static const double cardBorderRadius = 16.0;
  static const double placeholderIconSize = 80.0;
  static const double mediaMaxWidth = 600.0;
  static const double contentMaxWidth = 600.0;

  // Precomputed const shapes — use these in place of BorderRadius.circular(...)
  // so widgets that embed them can themselves be const.
  static const BorderRadius cardBorderRadiusShape = BorderRadius.all(
    Radius.circular(cardBorderRadius),
  );
  static const BorderRadius buttonBorderRadiusShape = BorderRadius.all(
    Radius.circular(buttonBorderRadius),
  );

  // Precomputed faded colors — static so they can be used in const contexts
  // (Color.withValues(...) is not a const expression).
  static const Color placeholderBorderColor = Color.fromRGBO(72, 53, 135, 0.3);
  static const Color placeholderIconColor = Color.fromRGBO(91, 32, 128, 0.6);
  static const Color placeholderTextColor = Color.fromRGBO(219, 225, 255, 0.6);
  static const Color bulletColor = textSecondary;
  static const Color scrollDownButtonColor = Color.fromRGBO(91, 32, 128, 0.8);

  // Navigation arrows — the violet of the scroll-down chevron, but named
  // separately so the two can diverge without disturbing each other.
  //
  // Kept fully opaque: [navArrowOpacity] is the single place the fade is
  // applied, so the circle and the glyph land at the same strength. Baking
  // alpha in here too would multiply with it and darken the circle relative
  // to the arrow.
  static const Color navArrowColor = Color.fromRGBO(91, 32, 128, 1.0);
  static const double navArrowSize = 44.0;

  /// The in-video replay button. Smaller than [navArrowSize] so it reads as a
  /// media control rather than page navigation.
  static const double rewatchButtonSize = 36.0;
  static const double rewatchButtonIconSize = 18.0;

  /// Applied to the whole arrow button — circle and glyph together — so the
  /// control recedes against the page instead of competing with it.
  static const double navArrowOpacity = 0.5;

  // Durations
  static const Duration pageTransitionDuration = Duration(milliseconds: 400);
  static const Duration entryAnimationDuration = Duration(milliseconds: 500);
}
