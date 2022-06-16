import 'package:flutter/widgets.dart';

import '../flutter_animate.dart';

/// An effect that animates the color saturation of the target. The `begin` and
/// `end` values indicate the saturation level, where 0 is fully desaturated
/// (ie. grayscale) and 1 is normal saturation. Values over 1 will oversaturate.
///
/// For example, this fade from grayscale to full color:
///
/// ```
/// Image.asset('assets/rainbow.jpg').animate()
///   .saturate(duration: 2.seconds)
/// ```
@immutable
class SaturateEffect extends Effect<double> {
  const SaturateEffect({
    Duration? delay,
    Duration? duration,
    Curve? curve,
    double? begin,
    double? end,
  }) : super(
          delay: delay,
          duration: duration,
          curve: curve,
          begin: begin ?? 0,
          end: end ?? 1,
        );

  @override
  Widget build(
    BuildContext context,
    Widget child,
    AnimationController controller,
    EffectEntry entry,
  ) {
    Animation<double> animation = buildAnimation(controller, entry);
    return AnimatedBuilder(
      animation: animation,
      child: child,
      builder: (_, child) {
        double value = animation.value;
        if (value == 1) return child!;
        return ColorFiltered(
          colorFilter: ColorFilter.matrix(_getColorMatrix(animation.value)),
          child: child,
        );
      },
    );
  }

  List<double> _getColorMatrix(double saturation) {
    double r0 = 0.33 * (1 - saturation), r1 = saturation + r0;
    double g0 = 0.59 * (1 - saturation), g1 = saturation + g0;
    double b0 = 0.11 * (1 - saturation), b1 = saturation + b0;

    return <double>[
      r1, g0, b0, 0, 0, // r
      r0, g1, b0, 0, 0, // g
      r0, g0, b1, 0, 0, // b
      0, 0, 0, 1, 0, // a
    ];
  }
}

extension SaturateEffectExtensions<T> on AnimateManager<T> {
  /// Adds a `.saturate()` extension to [AnimateManager] ([Animate] and [AnimateList]).
  T saturate({
    Duration? delay,
    Duration? duration,
    Curve? curve,
    double? begin,
    double? end,
  }) =>
      addEffect(SaturateEffect(
        delay: delay,
        duration: duration,
        curve: curve,
        begin: begin,
        end: end,
      ));

  /// Adds a `.desaturate()` extension to [AnimateManager] ([Animate] and [AnimateList]).
  /// This is identical to the `.saturate()` extension, except it defaults to `begin=1, end=0`.
  T desaturate({
    Duration? delay,
    Duration? duration,
    Curve? curve,
    double? begin,
    double? end,
  }) =>
      addEffect(SaturateEffect(
        delay: delay,
        duration: duration,
        curve: curve,
        begin: begin ?? 1.0,
        end: end ?? 0.0,
      ));
}
