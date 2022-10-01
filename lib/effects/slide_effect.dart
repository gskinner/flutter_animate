import 'package:flutter/widgets.dart';

import '../flutter_animate.dart';

/// Effect that moves the target based on a fraction of its size (via [SlideTransition])
/// based on the specified begin and end offsets. Defaults to `begin=Offset(0, -0.5),
/// end=Offset.zero` (ie. slide down from half its height).
///
/// To use pixel offsets instead, use [MoveEffect].
@immutable
class SlideEffect extends Effect<Offset> {
  const SlideEffect({
    Duration? delay,
    Duration? duration,
    Curve? curve,
    Offset? begin,
    Offset? end,
  }) : super(
          delay: delay,
          duration: duration,
          curve: curve,
          begin: begin ?? const Offset(0, -_defaultSlide),
          end: end ?? Offset.zero,
        );

  @override
  Widget build(
    BuildContext context,
    Widget child,
    AnimationController controller,
    EffectEntry entry,
  ) {
    return SlideTransition(
      position: buildAnimation(controller, entry),
      child: child,
    );
  }
}

extension SlideEffectExtensions<T> on AnimateManager<T> {
  /// Adds a `.slide()` extension to [AnimateManager] ([Animate] and [AnimateList]).
  T slide({
    Duration? delay,
    Duration? duration,
    Curve? curve,
    Offset? begin,
    Offset? end,
  }) =>
      addEffect(SlideEffect(
        delay: delay,
        duration: duration,
        curve: curve,
        begin: begin,
        end: end,
      ));

  /// Adds a `.slideX()` extension to [AnimateManager] ([Animate] and [AnimateList]).
  /// This slides only on the x-axis according to the `double` begin/end values.
  T slideX({
    Duration? delay,
    Duration? duration,
    Curve? curve,
    double? begin,
    double? end,
  }) =>
      addEffect(SlideEffect(
        delay: delay,
        duration: duration,
        curve: curve,
        begin: Offset(begin ?? -_defaultSlide, 0),
        end: Offset(end ?? 0, 0),
      ));

  /// Adds a `.slideY()` extension to [AnimateManager] ([Animate] and [AnimateList]).
  /// This slides only on the y-axis according to the `double` begin/end values.
  T slideY({
    Duration? delay,
    Duration? duration,
    Curve? curve,
    double? begin,
    double? end,
  }) =>
      addEffect(SlideEffect(
        delay: delay,
        duration: duration,
        curve: curve,
        begin: Offset(0, begin ?? -_defaultSlide),
        end: Offset(0, end ?? 0),
      ));

  // Note: there is no slideXY because diagonal movement isn't a significant use case.
}

const double _defaultSlide = 0.5;
