import 'package:flutter/widgets.dart';

/// Broadcasts a "restart the tutorial" pulse to every descendant that cares.
///
/// [PageView] keeps already-built pages alive, so navigating back to page 0
/// reuses the existing page and video state — `initState` never runs again and
/// a finished clip would otherwise stay parked on its last frame. Descendants
/// listen to [restartTick] and reset themselves when it fires.
class TutorialRestartScope extends InheritedWidget {
  /// Incremented once per restart. The value itself is meaningless; the
  /// notification is the signal.
  final ValueNotifier<int> restartTick;

  const TutorialRestartScope({
    super.key,
    required this.restartTick,
    required super.child,
  });

  /// The nearest restart signal, or null when there is no scope above — the
  /// widgets below are usable standalone, outside a [TutorialBook].
  static ValueNotifier<int>? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<TutorialRestartScope>()
        ?.restartTick;
  }

  @override
  bool updateShouldNotify(TutorialRestartScope oldWidget) {
    return restartTick != oldWidget.restartTick;
  }
}
