import 'package:flutter/widgets.dart';

import '../../flutter_animate.dart';

/// A special convenience "effect" that makes it easier to sequence effects after
/// one another. It does this by establishing a new baseline time equal to the
/// previous effect's end time and its own optional [delay].
/// All subsequent effect delays are relative to this new baseline.
///
/// This example demonstrates [ThenEffect] and how it interacts with [delay]:
///
/// ```
/// Text("Hello").animate()
///   .fadeIn(delay: 300.ms, duration: 500.ms) // end @ 800ms
///   .then()                  // baseline=800ms (prior end)
///   .slide(duration: 400.ms) // start @ 800ms, end @ 1200ms
///   .then(delay: 300.ms)     // baseline=1500ms (1200+300)
///   .blur(delay: -150.ms)    // start @ 1350ms (1500-150)
///   .tint()                  // start @ 1350ms (inherited)
///   .shake(delay: 0.ms)      // start @ 1500ms (1500+0)
/// ```
@immutable
class ThenEffect extends Effect<double> {
  // NOTE: this is just an empty effect, the logic happens in Animate
  // when it recognizes the type.
  const ThenEffect({
    Duration? delay,
    Duration? duration,
    Curve? curve,
    Curve? reverseCurve,
  }) : super(
          delay: delay,
          duration: duration,
          curve: curve,
          reverseCurve: reverseCurve,
        );

  @override
  Widget build(
    BuildContext context,
    Widget child,
    AnimationController controller,
    EffectEntry entry,
  ) =>
      child;
}

extension ThenEffectExtensions<T> on AnimateManager<T> {
  /// Adds a [then] extension to [AnimateManager] ([Animate] and [AnimateList]).
  T then({
    Duration? delay,
    Duration? duration,
    Curve? curve,
    Curve? reverseCurve,
  }) =>
      addEffect(ThenEffect(
        delay: delay,
        duration: duration,
        curve: curve,
        reverseCurve: reverseCurve,
      ));
}
