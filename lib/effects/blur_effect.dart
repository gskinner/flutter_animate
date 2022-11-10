import 'dart:ui';
import 'package:flutter/widgets.dart';

import '../flutter_animate.dart';

/// Effect that animates a blur on the target (via [ImageFiltered])
/// between the specified begin and end blur radius values. Defaults to a blur radius of `begin=0, end=4`.
@immutable
class BlurEffect extends BeginEndEffect<Offset> {
  static const Offset neutralValue = Offset(neutralBlur, neutralBlur);
  static const Offset defaultValue = Offset(defaultBlur, defaultBlur);

  static const double neutralBlur = 0.0;
  static const double defaultBlur = 4.0;
  static const double minBlur = 0.01; // below this blur is set to 0

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
          begin: begin ?? neutralValue,
          end: end ?? (begin == null ? defaultValue : neutralValue),
        );

  @override
  Widget build(
    BuildContext context,
    Widget child,
    AnimationController controller,
    EffectEntry entry,
  ) {
    Animation<Offset> animation = buildBeginEndAnimation(controller, entry);
    return getOptimizedBuilder<Offset>(
      animation: animation,
      builder: (_, __) {
        final double sigmaX = _normalizeSigma(animation.value.dx);
        final double sigmaY = _normalizeSigma(animation.value.dy);
        return ImageFiltered(
          enabled: sigmaX != 0 || sigmaY != 0,
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
    return sigma < minBlur ? 0 : sigma;
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
    double? begin,
    double? end,
  }) {
    end ??= (begin == null ? BlurEffect.defaultBlur : BlurEffect.neutralBlur);
    begin ??= BlurEffect.neutralBlur;
    return addEffect(BlurEffect(
      delay: delay,
      duration: duration,
      curve: curve,
      begin: BlurEffect.neutralValue.copyWith(dx: begin),
      end: BlurEffect.neutralValue.copyWith(dx: end),
    ));
  }

  /// Adds a [blurY] extension to [AnimateManager] ([Animate] and [AnimateList]).
  /// This blurs only on the y-axis according to the `double` begin/end values.
  T blurY({
    Duration? delay,
    Duration? duration,
    Curve? curve,
    double? begin,
    double? end,
  }) {
    end ??= (begin == null ? BlurEffect.defaultBlur : BlurEffect.neutralBlur);
    begin ??= BlurEffect.neutralBlur;
    return addEffect(BlurEffect(
      delay: delay,
      duration: duration,
      curve: curve,
      begin: BlurEffect.neutralValue.copyWith(dy: begin),
      end: BlurEffect.neutralValue.copyWith(dy: end),
    ));
  }

  /// Adds a [blurXY] extension to [AnimateManager] ([Animate] and [AnimateList]).
  /// This blurs uniformly according to the `double` begin/end values.
  T blurXY({
    Duration? delay,
    Duration? duration,
    Curve? curve,
    double? begin,
    double? end,
  }) {
    end ??= (begin == null ? BlurEffect.defaultBlur : BlurEffect.neutralBlur);
    begin ??= BlurEffect.neutralBlur;
    return addEffect(BlurEffect(
      delay: delay,
      duration: duration,
      curve: curve,
      begin: Offset(begin, begin),
      end: Offset(end, end),
    ));
  }
}
