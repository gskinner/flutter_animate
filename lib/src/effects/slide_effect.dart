import 'package:flutter/widgets.dart';

import '../../flutter_animate.dart';

/// An effect that moves the target based on a fraction of its size
/// per the specified [begin] and [end] offsets (via [SlideTransition]).
/// Defaults to `begin=Offset(0, -0.5), end=Offset.zero`
/// (slide down from half its height).
///
/// See also: [MoveEffect] to use pixel offsets.
@immutable
class SlideEffect extends Effect<Offset> {
  static const Offset neutralValue = Offset(neutralSlide, neutralSlide);
  static const Offset defaultValue = Offset(neutralSlide, defaultSlide);

  static const double neutralSlide = 0.0;
  static const double defaultSlide = -0.5;

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
          begin: begin ?? (end == null ? defaultValue : neutralValue),
          end: end ?? neutralValue,
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
  /// Adds a [slide] extension to [AnimateManager] ([Animate] and [AnimateList]).
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

  /// Adds a [slideX] extension to [AnimateManager] ([Animate] and [AnimateList]).
  /// This slides only on the x-axis according to the `double` begin/end values.
  T slideX({
    Duration? delay,
    Duration? duration,
    Curve? curve,
    double? begin,
    double? end,
  }) {
    begin ??= end == null ? SlideEffect.defaultSlide : SlideEffect.neutralSlide;
    end ??= SlideEffect.neutralSlide;
    return addEffect(SlideEffect(
      delay: delay,
      duration: duration,
      curve: curve,
      begin: SlideEffect.neutralValue.copyWith(dx: begin),
      end: SlideEffect.neutralValue.copyWith(dx: end),
    ));
  }

  /// Adds a [slideY] extension to [AnimateManager] ([Animate] and [AnimateList]).
  /// This slides only on the y-axis according to the `double` begin/end values.
  T slideY({
    Duration? delay,
    Duration? duration,
    Curve? curve,
    double? begin,
    double? end,
  }) {
    begin ??= end == null ? SlideEffect.defaultSlide : SlideEffect.neutralSlide;
    end ??= SlideEffect.neutralSlide;
    return addEffect(SlideEffect(
      delay: delay,
      duration: duration,
      curve: curve,
      begin: SlideEffect.neutralValue.copyWith(dy: begin),
      end: SlideEffect.neutralValue.copyWith(dy: end),
    ));
  }

  // Note: there is no slideXY because diagonal movement isn't a significant use case.
}
