import 'package:flutter/widgets.dart';

import 'effects/effects.dart';
import 'animate.dart';
import 'animate_list.dart';

export 'animate.dart';
export 'animate_list.dart';
export 'adapters/adapters.dart';
export 'effects/effects.dart';
export 'extensions/num_duration_extensions.dart';
export 'extensions/animation_controller_loop_extensions.dart';

/// Because [Effect] classes are immutable and may be reused between multiple
/// [Animate] (or [AnimateList]) instances, an `EffectEntry` is created to store
/// values that may be different between instances. For example, due to
/// `AnimateList interval`, or from inheriting values from prior effects in the chain.
@immutable
class EffectEntry {
  const EffectEntry({
    required this.effect,
    required this.delay,
    required this.duration,
    required this.curve,
    required this.owner,
  });

  /// The delay for this entry.
  final Duration delay;

  /// The duration for this entry.
  final Duration duration;

  /// The curve used by this entry.
  final Curve curve;

  /// The effect associated with this entry.
  final Effect effect;

  /// The [Animate] instance that created this entry. This can be used by effects
  /// to read information about the animation. Effects _should not_ modify
  /// the animation (ex. by calling [Animate.addEffect]).
  final Animate owner;

  /// The begin time for this entry.
  Duration get begin => delay;

  /// The end time for this entry.
  Duration get end => delay + duration;

  /// Builds a sub-animation based on the properties of this entry.
  Animation<double> buildAnimation(
    AnimationController controller, {
    Curve? curve,
  }) {
    return buildSubAnimation(controller, begin, end, curve ?? this.curve);
  }
}

/// Builds a sub-animation to the provided controller that runs from start to
/// end, with the provided curve. For example, it could create an animation that
/// runs from 300ms to 800ms with an easeOut curve, within a controller that has a
/// total duration of 1000ms.
///
/// Mostly used by [EffectEntry] and [Effect] classes.
Animation<double> buildSubAnimation(
  AnimationController controller,
  Duration begin,
  Duration end,
  Curve curve,
) {
  int ttlT = controller.duration?.inMicroseconds ?? 0;
  int beginT = begin.inMicroseconds, endT = end.inMicroseconds;
  return CurvedAnimation(
    parent: controller,
    curve: Interval(beginT / ttlT, endT / ttlT, curve: curve),
  );
}

/// Provides a common interface for [Animate] and [AnimateList] to attach [Effect] extensions.
mixin AnimateManager<T> {
  T addEffect(Effect effect) => throw (UnimplementedError());
  T addEffects(List<Effect> effects) {
    for (Effect o in effects) {
      addEffect(o);
    }
    return this as T;
  }
}
