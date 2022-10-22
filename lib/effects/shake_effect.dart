import 'dart:math';

import 'package:flutter/widgets.dart';

import '../flutter_animate.dart';

/// Effect that shakes the target, using translation, rotation, or both.
/// The `hz` parameter indicates approximately how many times to repeat the shake
/// per second.
///
/// Defaults to a 5 degree (`pi / 36`) shake, 12 times per second — equivalent to:
///
/// ```
/// Text("Hello").animate()
///   .shake(hz: 12, rotation: pi / 36)
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
    int? hz,
    Offset? offset,
    double? rotation,
  })  : rotation = rotation ?? pi / 36,
        hz = hz ?? 10,
        offset = offset ?? Offset.zero,
        super(
          delay: delay,
          duration: duration,
          curve: curve,
          begin: 0,
          end: 1,
        );

  final Offset offset;
  final double rotation;
  final int hz;

  @override
  Widget build(
    BuildContext context,
    Widget child,
    AnimationController controller,
    EffectEntry entry,
  ) {
    final bool shouldRotate = rotation != 0;
    final bool shouldTranslate = offset != Offset.zero;
    if (!shouldRotate && !shouldTranslate) return child;

    final Animation<double> animation = buildAnimation(controller, entry);
    final int count = (entry.duration.inSeconds * hz).floor();

    return getOptimizedBuilder<double>(
      animation: animation,
      builder: (_, __) {
        double value = sin(animation.value * count * pi * 2);
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
  /// Adds a [shake] extension to [AnimateManager] ([Animate] and [AnimateList]).
  T shake({
    Duration? delay,
    Duration? duration,
    Curve? curve,
    int? hz,
    Offset? offset,
    double? rotation,
  }) =>
      addEffect(ShakeEffect(
        delay: delay,
        duration: duration,
        curve: curve,
        hz: hz,
        offset: offset,
        rotation: rotation,
      ));

  /// Adds a [shakeX] extension to [AnimateManager] ([Animate] and [AnimateList]).
  /// This sets `rotation=0` and `offset=Offset(amount, 0)`.
  T shakeX({
    Duration? delay,
    Duration? duration,
    Curve? curve,
    int? hz,
    double amount = _defaultXY,
  }) =>
      addEffect(ShakeEffect(
        delay: delay,
        duration: duration,
        curve: curve,
        hz: hz,
        offset: Offset(amount, 0),
        rotation: 0,
      ));

  /// Adds a [shakeY] extension to [AnimateManager] ([Animate] and [AnimateList]).
  /// This sets `rotation=0` and `offset=Offset(0, amount)`.
  T shakeY({
    Duration? delay,
    Duration? duration,
    Curve? curve,
    int? hz,
    double amount = _defaultXY,
  }) =>
      addEffect(ShakeEffect(
        delay: delay,
        duration: duration,
        curve: curve,
        hz: hz,
        offset: Offset(0, amount),
        rotation: 0,
      ));
}

const double _defaultXY = 6;
