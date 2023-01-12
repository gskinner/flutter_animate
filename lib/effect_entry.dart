import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';

export 'animate.dart';
export 'animate_list.dart';
export 'adapters/adapters.dart';
export 'effects/effects.dart';

export 'extensions/extensions.dart';

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

  /// Builds a sub-animation that runs from 0-1, based on the properties of this entry.
  Animation<double> buildAnimation(
    AnimationController controller, {
    Curve? curve,
  }) {
    return buildSubAnimation(controller, begin, end, curve ?? this.curve);
  }

  /// Builds an sub-animation that runs from the begin and end values of a given [Tween]
  Animation<T> buildTweenedAnimation<T>(AnimationController controller, Tween<T> tween) =>
      buildAnimation(controller).drive(tween);
}
