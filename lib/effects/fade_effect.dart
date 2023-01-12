import 'package:flutter/widgets.dart';

import '../flutter_animate.dart';

/// Effect that animates the opacity of the target (via [FadeTransition]) between the specified begin and end values.
/// It defaults to `begin=0, end=1`.
@immutable
class FadeEffect extends BeginEndEffect<double> {
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
      opacity: buildBeginEndAnimation(controller, entry),
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
}
