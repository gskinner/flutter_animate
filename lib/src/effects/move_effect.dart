import 'package:flutter/widgets.dart';

import '../../flutter_animate.dart';

/// An effect that moves the target between the specified [begin] and [end]
/// offsets (via [Transform.translate])
/// Defaults to `begin=Offset(0, -16), end=Offset.zero`.
/// [transformHitTests] is simply passed on to [Transform.translate].
///
/// See also: [SlideEffect] to specify offsets relative to the target's size.
@immutable
class MoveEffect extends Effect<Offset> {
  static const Offset neutralValue = Offset(neutralMove, neutralMove);
  static const Offset defaultValue = Offset(neutralMove, defaultMove);

  static const double neutralMove = 0.0;
  static const double defaultMove = -16.0;
  static const bool defaultTransformHitTests = true;

  const MoveEffect({
    Duration? delay,
    Duration? duration,
    Curve? curve,
    Offset? begin,
    Offset? end,
    bool? transformHitTests,
  })  : transformHitTests = transformHitTests ?? defaultTransformHitTests,
        super(
          delay: delay,
          duration: duration,
          curve: curve,
          begin: begin ?? (end == null ? defaultValue : neutralValue),
          end: end ?? neutralValue,
        );

  final bool transformHitTests;

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
        return Transform.translate(
          offset: animation.value,
          transformHitTests: transformHitTests,
          child: child,
        );
      },
    );
  }
}

extension MoveEffectExtensions<T> on AnimateManager<T> {
  /// Adds a [move] extension to [AnimateManager] ([Animate] and [AnimateList]).
  T move({
    Duration? delay,
    Duration? duration,
    Curve? curve,
    Offset? begin,
    Offset? end,
    bool? transformHitTests,
  }) =>
      addEffect(MoveEffect(
        delay: delay,
        duration: duration,
        curve: curve,
        begin: begin,
        end: end,
        transformHitTests: transformHitTests,
      ));

  /// Adds a [moveX] extension to [AnimateManager] ([Animate] and [AnimateList]).
  /// This moves only on the x-axis according to the `double` begin/end values.
  T moveX({
    Duration? delay,
    Duration? duration,
    Curve? curve,
    double? begin,
    double? end,
    bool? transformHitTests,
  }) {
    begin ??= end == null ? MoveEffect.defaultMove : MoveEffect.neutralMove;
    end ??= MoveEffect.neutralMove;
    return addEffect(MoveEffect(
      delay: delay,
      duration: duration,
      curve: curve,
      begin: MoveEffect.neutralValue.copyWith(dx: begin),
      end: MoveEffect.neutralValue.copyWith(dx: end),
      transformHitTests: transformHitTests,
    ));
  }

  /// Adds a [moveY] extension to [AnimateManager] ([Animate] and [AnimateList]).
  /// This moves only on the y-axis according to the `double` begin/end values.
  T moveY({
    Duration? delay,
    Duration? duration,
    Curve? curve,
    double? begin,
    double? end,
    bool? transformHitTests,
  }) {
    begin ??= end == null ? MoveEffect.defaultMove : MoveEffect.neutralMove;
    end ??= MoveEffect.neutralMove;
    return addEffect(MoveEffect(
      delay: delay,
      duration: duration,
      curve: curve,
      begin: MoveEffect.neutralValue.copyWith(dy: begin),
      end: MoveEffect.neutralValue.copyWith(dy: end),
      transformHitTests: transformHitTests,
    ));
  }

  // Note: there is no moveXY because diagonal movement isn't a significant use case.
}
