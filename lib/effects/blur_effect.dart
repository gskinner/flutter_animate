import 'dart:ui';
import 'package:flutter/widgets.dart';

import '../flutter_animate.dart';

/// Effect that animates a blur on the target (via [ImageFiltered])
/// between the specified begin and end blur radius values. Defaults to a blur radius of `begin=0, end=4`.
@immutable
class BlurEffect extends Effect<Offset> {
  const BlurEffect({
    Duration? delay,
    Duration? duration,
    Curve? curve,
    Offset? begin,
    Offset? end,
  }) : super(
          delay: delay,
          duration: duration,
          curve: curve,
          begin: begin ?? Offset.zero,
          end: end ?? const Offset(_defaultBlur, _defaultBlur),
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
        double sigmaX = _normalizeSigma(animation.value.dx);
        double sigmaY = _normalizeSigma(animation.value.dy);
        if (sigmaX == 0 && sigmaY == 0) return child;
        return ImageFiltered(
          imageFilter: ImageFilter.blur(
            sigmaX: sigmaX,
            sigmaY: sigmaY,
            tileMode: TileMode.decal,
          ),
          child: child,
        );
      },
    );
  }

  double _normalizeSigma(double sigma) {
    return sigma < _minBlur ? 0 : sigma;
  }
}

extension BlurEffectExtensions<T> on AnimateManager<T> {
  /// Adds a [blur] extension to [AnimateManager] ([Animate] and [AnimateList]).
  T blur({
    Duration? delay,
    Duration? duration,
    Curve? curve,
    Offset? begin,
    Offset? end,
  }) =>
      addEffect(BlurEffect(
        delay: delay,
        duration: duration,
        curve: curve,
        begin: begin,
        end: end,
      ));

  /// Adds a [blurX] extension to [AnimateManager] ([Animate] and [AnimateList]).
  /// This blurs only on the x-axis according to the `double` begin/end values.
  T blurX({
    Duration? delay,
    Duration? duration,
    Curve? curve,
    double begin = 0,
    double end = _defaultBlur,
  }) =>
      addEffect(BlurEffect(
        delay: delay,
        duration: duration,
        curve: curve,
        begin: Offset(begin, 0),
        end: Offset(end, 0),
      ));

  /// Adds a [blurY] extension to [AnimateManager] ([Animate] and [AnimateList]).
  /// This blurs only on the y-axis according to the `double` begin/end values.
  T blurY({
    Duration? delay,
    Duration? duration,
    Curve? curve,
    double begin = 0,
    double end = _defaultBlur,
  }) =>
      addEffect(BlurEffect(
        delay: delay,
        duration: duration,
        curve: curve,
        begin: Offset(0, begin),
        end: Offset(0, end),
      ));

  /// Adds a [blurXY] extension to [AnimateManager] ([Animate] and [AnimateList]).
  /// This blurs uniformly according to the `double` begin/end values.
  T blurXY({
    Duration? delay,
    Duration? duration,
    Curve? curve,
    double begin = 0,
    double end = _defaultBlur,
  }) =>
      addEffect(BlurEffect(
        delay: delay,
        duration: duration,
        curve: curve,
        begin: Offset(begin, begin),
        end: Offset(end, end),
      ));

  /// Adds an [unblur] extension to [AnimateManager] ([Animate] and [AnimateList]).
  /// This is identical to the [blurXY] extension, except it defaults to `begin=4, end=0`.
  T unblur({
    Duration? delay,
    Duration? duration,
    Curve? curve,
    double begin = _defaultBlur,
    double end = 0,
  }) =>
      addEffect(BlurEffect(
        delay: delay,
        duration: duration,
        curve: curve,
        begin: Offset(begin, begin),
        end: Offset(end, end),
      ));
}

const double _defaultBlur = 4;
const double _minBlur = 0.01;
