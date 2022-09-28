import 'package:flutter/widgets.dart';

import '../flutter_animate.dart';

/// Effect that moves the target (via [Transform.translate]) between the specified begin and end offsets.
/// Defaults to `begin=Offset(0, -16), end=Offset.zero`.
/// 
/// To specify offsets relative to the target's size, use [SlideEffect].
@immutable
class MoveEffect extends Effect<Offset> {
  const MoveEffect({
    Duration? delay,
    Duration? duration,
    Curve? curve,
    Offset? begin,
    Offset? end,
  }) : super(
          delay: delay,
          duration: duration,
          curve: curve,
          begin: begin ?? const Offset(0, -16),
          end: end ?? Offset.zero,
        );

  @override
  Widget build(
    BuildContext context,
    Widget child,
    AnimationController controller,
    EffectEntry entry,
  ) {
    Animation<Offset> animation = buildAnimation(controller, entry);
    return getOptimizedBuilder<Offset>(
      animation: animation,
      builder: (_, __) {
        return Transform.translate(offset: animation.value, child: child);
      },
    );
  }
}

extension MoveEffectExtensions<T> on AnimateManager<T> {
  /// Adds a `.move()` extension to [AnimateManager] ([Animate] and [AnimateList]).
  T move({
    Duration? delay,
    Duration? duration,
    Curve? curve,
    Offset? begin,
    Offset? end,
  }) =>
      addEffect(MoveEffect(
        delay: delay,
        duration: duration,
        curve: curve,
        begin: begin,
        end: end,
      ));
}
