import 'dart:math';

import 'package:flutter/widgets.dart';

import '../../flutter_animate.dart';

/// Effect that shakes the target, using translation, rotation, or both.
///
/// The [hz] parameter indicates approximately how many times to repeat the shake
/// per second. It defaults to `8`.
///
/// Specify [rotation], [offset], or both to indicate the type and strength of the
/// shaking. Defaults to `rotation=pi/36, offset=Offset.zero`, which results in
/// a light rotational shake.
///
/// This example would shake left and right slowly by 10px:
///
/// ```
/// Text("Hello").animate()
///   .shake(hz: 3, offset: Offset(10, 0))
/// ```
///
/// There are also `shakeX` and `shakeY` shortcut extension methods.
@immutable
class ShakeEffect extends Effect<double> {
  static const double defaultHz = 8;
  static const double defaultRotation = pi / 36;
  static const double defaultMove = 5;

  const ShakeEffect({
    Duration? delay,
    Duration? duration,
    Curve? curve,
    Curve? reverseCurve,
    double? hz,
    Offset? offset,
    double? rotation,
  })  : rotation = rotation ?? defaultRotation,
        hz = hz ?? defaultHz,
        offset = offset ?? Offset.zero,
        super(
          delay: delay,
          duration: duration,
          curve: curve,
          reverseCurve: reverseCurve,
          begin: 0,
          end: 1,
        );

  final Offset offset;
  final double rotation;
  final double hz;

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
    final int count = (entry.duration.inMilliseconds / 1000 * hz).round();

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
    Curve? reverseCurve,
    double? hz,
    Offset? offset,
    double? rotation,
  }) =>
      addEffect(ShakeEffect(
        delay: delay,
        duration: duration,
        curve: curve,
        reverseCurve: reverseCurve,
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
    Curve? reverseCurve,
    double? hz,
    double? amount,
  }) =>
      addEffect(ShakeEffect(
        delay: delay,
        duration: duration,
        curve: curve,
        reverseCurve: reverseCurve,
        hz: hz,
        offset: Offset(amount ?? ShakeEffect.defaultMove, 0),
        rotation: 0,
      ));

  /// Adds a [shakeY] extension to [AnimateManager] ([Animate] and [AnimateList]).
  /// This sets `rotation=0` and `offset=Offset(0, amount)`.
  T shakeY({
    Duration? delay,
    Duration? duration,
    Curve? curve,
    Curve? reverseCurve,
    double? hz,
    double? amount,
  }) =>
      addEffect(ShakeEffect(
        delay: delay,
        duration: duration,
        curve: curve,
        reverseCurve: reverseCurve,
        hz: hz,
        offset: Offset(0, amount ?? ShakeEffect.defaultMove),
        rotation: 0,
      ));
}
