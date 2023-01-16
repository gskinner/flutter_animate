import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../flutter_animate.dart';

/// An effect that animates a blur on the target (via [ImageFiltered])
/// between the specified [begin] and [end] blur radiuses.
/// Defaults to `begin=0, end=4`.
@immutable
class BlurEffect extends Effect<Offset> {
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
    Animation<Offset> animation = buildAnimation(controller, entry);
    return getOptimizedBuilder<Offset>(
      animation: animation,
      builder: (_, __) {
        final double sigmaX = _normalizeSigma(animation.value.dx);
        final double sigmaY = _normalizeSigma(animation.value.dy);
        return ImageFiltered(
          enabled: sigmaX > minBlur || sigmaY > minBlur,
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
    // Addresses a Flutter issue where near-zero blurs throw an error.
    // TODO: fix is in master, remove this when it hits stable.
    // https://github.com/flutter/engine/pull/36575
    return kIsWeb && sigma < minBlur ? minBlur : sigma;
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
