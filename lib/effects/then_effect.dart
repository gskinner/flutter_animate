import 'package:flutter/widgets.dart';

import '../flutter_animate.dart';

/// A special convenience "effect" that makes it easier to sequence effects after
/// one another. It does this by calculating a new inheritable delay by adding the
/// previous effect's `delay`, `duration` and its own optional `delay`.
///
/// For example, this would cause the scale to run 300 milliseconds after the fade
/// completes:
///
/// ```
/// Text("Hello").animate()
///   .fadeIn(delay: 500.ms, duration: 900.ms)
///   .then(delay: 300.ms) // calculate delay: 500 + 900 + 300 = 1700ms
///   .scale(begin: 1, end: 2) // inherits the 1700ms delay
/// ```
///
/// This makes it easy to change the delay or duration of the `fadeIn`, without
/// having to update the delay on `scale` to match.
///
/// Note that this simply calculates a new `delay` that will be inherited by the
/// subsequent effect. In the example above, it is functionally equivalent to
/// setting `delay: 1700.ms` on the scale effect.
@immutable
class ThenEffect extends Effect<double> {
  // NOTE: this is just an empty effect, the logic happens in Animate
  // when it recognizes the type.
  const ThenEffect({Duration? delay, Duration? duration, Curve? curve})
      : super(delay: delay, duration: duration, curve: curve);

  @override
  Widget build(BuildContext context, Widget child,
          AnimationController controller, EffectEntry entry) =>
      child;
}

extension ThenEffectExtensions<T> on AnimateManager<T> {
  /// Adds a `.then()` extension to [AnimateManager] ([Animate] and [AnimateList]).
  T then({Duration? delay, Duration? duration, Curve? curve}) =>
      addEffect(ThenEffect(delay: delay, duration: duration, curve: curve));
}
