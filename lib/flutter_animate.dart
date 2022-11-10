import 'package:flutter/widgets.dart';

import 'effect.dart';

export 'animate.dart';
export 'animate_list.dart';
export 'adapters/adapters.dart';
export 'effects/effects.dart';
export 'effect_entry.dart';
export 'effect.dart';
export 'effects/effects.dart';
export 'extensions/extensions.dart';

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

/// Provides a common interface for [Animate] and [AnimateList] to attach [BeginEndEffect] extensions.
mixin AnimateManager<T> {
  T addEffect(Effect effect) => throw (UnimplementedError());
  T addEffects(List<Effect> effects) {
    for (Effect o in effects) {
      addEffect(o);
    }
    return this as T;
  }
}
