import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Effect that scales the target (via [Transform.scale]) between the specified begin and end offsets.
/// Defaults to `begin=Offset(1.0, 1.0), end=Offset.zero`.
@immutable
class ScaleEffectXY extends Effect<Offset> {
  const ScaleEffectXY({
    Duration? delay,
    Duration? duration,
    Curve? curve,
    Offset? begin,
    Offset? end,
    this.alignment,
  }) : super(
    delay: delay,
    duration: duration,
    curve: curve,
    begin: begin ?? Offset.zero,
    end: end ?? const Offset(1.0, 1.0),
  );

  final Alignment? alignment;

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
        return Transform.scale(
            scaleX: animation.value.dx,
            scaleY: animation.value.dy,
            child: child,
        );
      },
    );
  }
}

extension ScaleEffectXYExtensions<T> on AnimateManager<T> {
  /// Adds a `.scaleXY()` extension to [AnimateManager] ([Animate] and [AnimateList]).
  T scaleXY({
    Duration? delay,
    Duration? duration,
    Curve? curve,
    Offset? begin,
    Offset? end,
    Alignment? alignment,
  }) =>
      addEffect(ScaleEffectXY(
        delay: delay,
        duration: duration,
        curve: curve,
        begin: begin,
        end: end,
        alignment: alignment,
      ));
}
