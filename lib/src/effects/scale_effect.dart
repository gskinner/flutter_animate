import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../flutter_animate.dart';

/// An effect that scales the target between the specified [begin] and [end]
/// offset values (via [Transform.scale]).
/// Defaults to `begin=Offset(0,0), end=Offset(1,1)`.
@immutable
class ScaleEffect extends Effect<Offset> {
  static const Offset neutralValue = Offset(neutralScale, neutralScale);
  static const Offset defaultValue = Offset(defaultScale, defaultScale);

  static const double neutralScale = 1.0;
  static const double defaultScale = 0;
  static const double minScale = 0.000001;

  const ScaleEffect({
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
          begin: begin ?? (end == null ? defaultValue : neutralValue),
          end: end ?? neutralValue,
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
          scaleX: _normalizeScale(animation.value.dx),
          scaleY: _normalizeScale(animation.value.dy),
          alignment: alignment ?? Alignment.center,
          child: child,
        );
      },
    );
  }

  double _normalizeScale(double scale) {
    // addresses an issue with zero value scales:
    // https://github.com/gskinner/flutter_animate/issues/79
    return scale < minScale ? minScale : scale;
  }
}

extension ScaleEffectExtensions<T> on AnimateManager<T> {
  /// Adds a [scale] extension to [AnimateManager] ([Animate] and [AnimateList]).
  T scale({
    Duration? delay,
    Duration? duration,
    Curve? curve,
    Offset? begin,
    Offset? end,
    Alignment? alignment,
  }) =>
      addEffect(ScaleEffect(
        delay: delay,
        duration: duration,
        curve: curve,
        begin: begin,
        end: end,
        alignment: alignment,
      ));

  /// Adds a [scaleX] extension to [AnimateManager] ([Animate] and [AnimateList]).
  /// This scales only on the x-axis according to the `double` begin/end values.
  T scaleX({
    Duration? delay,
    Duration? duration,
    Curve? curve,
    double? begin,
    double? end,
    Alignment? alignment,
  }) {
    begin ??=
        (end == null ? ScaleEffect.defaultScale : ScaleEffect.neutralScale);
    end ??= ScaleEffect.neutralScale;
    return addEffect(ScaleEffect(
      delay: delay,
      duration: duration,
      curve: curve,
      begin: ScaleEffect.neutralValue.copyWith(dx: begin),
      end: ScaleEffect.neutralValue.copyWith(dx: end),
      alignment: alignment,
    ));
  }

  /// Adds a [scaleY] extension to [AnimateManager] ([Animate] and [AnimateList]).
  /// This scales only on the y-axis according to the `double` begin/end values.
  T scaleY({
    Duration? delay,
    Duration? duration,
    Curve? curve,
    double? begin,
    double? end,
    Alignment? alignment,
  }) {
    begin ??=
        (end == null ? ScaleEffect.defaultScale : ScaleEffect.neutralScale);
    end ??= ScaleEffect.neutralScale;
    return addEffect(ScaleEffect(
      delay: delay,
      duration: duration,
      curve: curve,
      begin: ScaleEffect.neutralValue.copyWith(dy: begin),
      end: ScaleEffect.neutralValue.copyWith(dy: end),
      alignment: alignment,
    ));
  }

  /// Adds a [scaleXY] extension to [AnimateManager] ([Animate] and [AnimateList]).
  /// This scales uniformly according to the `double` begin/end values.
  T scaleXY({
    Duration? delay,
    Duration? duration,
    Curve? curve,
    double? begin,
    double? end,
    Alignment? alignment,
  }) {
    begin ??=
        (end == null ? ScaleEffect.defaultScale : ScaleEffect.neutralScale);
    end ??= ScaleEffect.neutralScale;
    return addEffect(ScaleEffect(
      delay: delay,
      duration: duration,
      curve: curve,
      begin: Offset(begin, begin),
      end: Offset(end, end),
      alignment: alignment,
    ));
  }
}
