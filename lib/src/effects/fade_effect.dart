import 'package:flutter/widgets.dart';

import '../../flutter_animate.dart';

/// An effect that animates the opacity of the target between the specified
/// [begin] and [end] values (via [FadeTransition]).
/// It defaults to `begin=0, end=1`.
@immutable
class FadeEffect extends Effect<double> {
  static const double neutralValue = 1.0;
  static const double defaultValue = 0.0;

  const FadeEffect({
    Duration? delay,
    Duration? duration,
    Curve? curve,
    double? begin,
    double? end,
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
    return FadeTransition(
      opacity: buildAnimation(controller, entry),
      child: child,
    );
  }
}

extension FadeEffectExtensions<T> on AnimateManager<T> {
  /// Adds a [fade] extension to [AnimateManager] ([Animate] and [AnimateList]).
  T fade({
    Duration? delay,
    Duration? duration,
    Curve? curve,
    double? begin,
    double? end,
  }) =>
      addEffect(FadeEffect(
        delay: delay,
        duration: duration,
        curve: curve,
        begin: begin,
        end: end,
      ));

  /// Adds a [fadeIn] extension to [AnimateManager] ([Animate] and [AnimateList]).
  /// This is identical to the [fade] extension, except it always uses `end=1.0`.
  T fadeIn({
    Duration? delay,
    Duration? duration,
    Curve? curve,
    double? begin,
  }) =>
      addEffect(FadeEffect(
        delay: delay,
        duration: duration,
        curve: curve,
        begin: begin ?? FadeEffect.defaultValue,
        end: 1.0,
      ));

  /// Adds a [fadeOut] extension to [AnimateManager] ([Animate] and [AnimateList]).
  /// This is identical to the [fade] extension, except it always uses `end=0.0`.
  T fadeOut({
    Duration? delay,
    Duration? duration,
    Curve? curve,
    double? begin,
  }) =>
      addEffect(FadeEffect(
        delay: delay,
        duration: duration,
        curve: curve,
        begin: begin ?? FadeEffect.neutralValue,
        end: 0.0,
      ));
}
