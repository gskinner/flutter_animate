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
  static const bool defaultTransformHitTests = true;

  const ScaleEffect({
    Duration? delay,
    Duration? duration,
    Curve? curve,
    Offset? begin,
    Offset? end,
    this.alignment,
    bool? transformHitTests,
  })  : transformHitTests = transformHitTests ?? defaultTransformHitTests,
        super(
          delay: delay,
          duration: duration,
          curve: curve,
          begin: begin ?? (end == null ? defaultValue : neutralValue),
          end: end ?? neutralValue,
        );

  final Alignment? alignment;
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
        return Transform.scale(
          scaleX: _normalizeScale(animation.value.dx),
          scaleY: _normalizeScale(animation.value.dy),
          alignment: alignment ?? Alignment.center,
          transformHitTests: transformHitTests,
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
    bool? transformHitTests,
  }) =>
      addEffect(ScaleEffect(
        delay: delay,
        duration: duration,
        curve: curve,
        begin: begin,
        end: end,
        alignment: alignment,
        transformHitTests: transformHitTests,
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
    bool? transformHitTests,
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
      transformHitTests: transformHitTests,
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
    bool? transformHitTests,
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
      transformHitTests: transformHitTests,
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
    bool? transformHitTests,
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
      transformHitTests: transformHitTests,
    ));
  }
}
