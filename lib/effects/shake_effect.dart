import 'dart:math';

import 'package:flutter/widgets.dart';

import '../flutter_animate.dart';

/// Effect that shakes the target, using translation, rotation, or both.
/// The `count` parameter indicates how many times to repeat the shake within
/// the duration. Defaults to a 5 degree (`pi / 36`) shake, repeated 3 times —
/// equivalent to:
///
/// ```
/// Text("Hello").animate()
///   .shake(count: 3, rotation: pi / 36)
/// ```
///
/// There are also shortcut extensions for applying horizontal / vertical shake.
/// For example, this would shake 10 pixels horizontally (default is 6):
///
/// ```
/// Text("Hello").animate().shakeX(amount: 10)
/// ```
@immutable
class ShakeEffect extends Effect<double> {
  const ShakeEffect({
    Duration? delay,
    Duration? duration,
    Curve? curve,
    int? count,
    Offset? offset,
    double? rotation,
  })  : rotation = rotation ?? pi / 36,
        offset = offset ?? Offset.zero,
        super(
          delay: delay,
          duration: duration,
          curve: curve,
          begin: 0,
          end: (count ?? 3) * pi * 2,
        );

  final Offset offset;
  final double rotation;

  @override
  Widget build(
    BuildContext context,
    Widget child,
    AnimationController controller,
    EffectEntry entry,
  ) {
    bool shouldRotate = rotation != 0;
    bool shouldTranslate = offset != Offset.zero;
    if (!shouldRotate && !shouldTranslate) return child;
    Animation<double> animation = buildAnimation(controller, entry);
    return getOptimizedBuilder<double>(
      animation: animation,
      builder: (_, __) {
        double value = sin(animation.value);
        Widget widget = child;
        if (shouldRotate) {
          widget = Transform.rotate(angle: rotation * value, child: widget);
        }
        if (shouldTranslate) {
          widget = Transform.translate(offset: offset * value, child: widget);
        }
        return widget;
      },
    );
  }
}

extension ShakeEffectExtensions<T> on AnimateManager<T> {
  /// Adds a `.shake()` extension to [AnimateManager] ([Animate] and [AnimateList]).
  T shake({
    Duration? delay,
    Duration? duration,
    Curve? curve,
    int? count,
    Offset? offset,
    double? rotation,
  }) =>
      addEffect(ShakeEffect(
        delay: delay,
        duration: duration,
        curve: curve,
        count: count,
        offset: offset,
        rotation: rotation,
      ));

  /// Adds a `.shakeX()` extension to [AnimateManager] ([Animate] and [AnimateList]).
  /// This sets `rotation=0` and `offset=Offset(amount, 0)`.
  T shakeX({
    Duration? delay,
    Duration? duration,
    Curve? curve,
    int? count,
    double amount = defaultAmount,
  }) =>
      addEffect(ShakeEffect(
        delay: delay,
        duration: duration,
        curve: curve,
        count: count,
        offset: Offset(amount, 0),
        rotation: 0,
      ));

  /// Adds a `.shakeY()` extension to [AnimateManager] ([Animate] and [AnimateList]).
  /// This sets `rotation=0` and `offset=Offset(0, amount)`.
  T shakeY({
    Duration? delay,
    Duration? duration,
    Curve? curve,
    int? count,
    double amount = defaultAmount,
  }) =>
      addEffect(ShakeEffect(
        delay: delay,
        duration: duration,
        curve: curve,
        count: count,
        offset: Offset(0, amount),
        rotation: 0,
      ));
}

const double defaultAmount = 6;