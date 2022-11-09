import 'package:flutter/widgets.dart';

import '../flutter_animate.dart';

/// Provide an easy way to use Flutters TweenSequence API to express
/// complex multi-part tweens.
/// ```
/// // fades in, out, and back in
/// foo.animate().tweenSequence(
//   duration: 1.seconds,
//   sequence: TweenSequence<double>([
//     TweenSequenceItem(tween: Tween(begin: 0, end: 1), weight: .5),
//     TweenSequenceItem(tween: Tween(begin: 1, end: 0), weight: .5),
//     TweenSequenceItem(tween: Tween(begin: 0, end: 1), weight: .5),
//   ]),
//   builder: (_, double value, Widget child) {
//     return Opacity(opacity: value, child: child);
//   },
// )
/// ```
@immutable
class TweenSequenceEffect extends Effect<double> {
  const TweenSequenceEffect(
      {required this.builder, required this.sequence, Duration? delay, Duration? duration, Curve? curve})
      : super(delay: delay, duration: duration, curve: curve, begin: 0.0, end: 1.0);

  final TweenSequenceEffectBuilder builder;
  final TweenSequence sequence;

  @override
  Widget build(
    BuildContext context,
    Widget child,
    AnimationController controller,
    EffectEntry entry,
  ) {
    Animation<double> animation = buildAnimation(controller, entry);
    return getOptimizedBuilder<double>(
      animation: animation,
      builder: (ctx, __) => builder(ctx, sequence.evaluate(animation), child),
    );
  }
}

extension TweenSequenceExtensions<T> on AnimateManager<T> {
  /// Adds a [custom] extension to [AnimateManager] ([Animate] and [AnimateList]).
  T tweenSequence({
    required TweenSequenceEffectBuilder builder,
    required TweenSequence sequence,
    Duration? delay,
    Duration? duration,
    Curve? curve,
    double? begin,
    double? end,
  }) =>
      addEffect(
          TweenSequenceEffect(builder: builder, delay: delay, duration: duration, curve: curve, sequence: sequence));
}

typedef TweenSequenceEffectBuilder = Widget Function(
  BuildContext context,
  double value,
  Widget child,
);
