import 'package:flutter/widgets.dart';

import '../flutter_animate.dart';

/// An effect that applies an animated color tint to the target. The [begin] and
/// [end] values indicate the strength of the tint (0 - no tint, 1 - 100% tint).
/// The default [color] is opaque black (`Color(0xFF000000)`).
/// If [color] has an opacity less than one, that opacity is multiplied against
/// the strength. Ex. `Colors.black54` at strength `0.5` would apply a 27% tint.
///
/// For example, this would animate in a 50% blue tint:
///
/// ```
/// Image.asset('assets/rainbow.jpg').animate()
///   .tint(color: Colors.blue, end: 0.5, duration: 2.seconds)
/// ```
@immutable
class TintEffect extends BeginEndEffect<double> {
  static const double neutralValue = 0.0;
  static const double defaultValue = 1.0;

  const TintEffect({
    Duration? delay,
    Duration? duration,
    Curve? curve,
    double? begin,
    double? end,
    Color? color,
  })  : color = color ?? const Color(0xFF000000),
        super(
          delay: delay,
          duration: duration,
          curve: curve,
          begin: begin ?? neutralValue,
          end: end ?? (begin == null ? defaultValue : neutralValue),
        );

  final Color color;

  @override
  Widget build(
    BuildContext context,
    Widget child,
    AnimationController controller,
    EffectEntry entry,
  ) {
    Animation<double> animation = buildBeginEndAnimation(controller, entry);
    return getOptimizedBuilder<double>(
      animation: animation,
      builder: (_, __) => ColorFiltered(
        colorFilter: ColorFilter.matrix(getTintMatrix(animation.value, color)),
        child: child,
      ),
    );
  }

  static List<double> getTintMatrix(double strength, Color color) {
    double v = 1 - strength * color.alpha / 255;

    return <double>[
      v, 0, 0, 0, color.red * (1 - v), // r
      0, v, 0, 0, color.green * (1 - v), // g
      0, 0, v, 0, color.blue * (1 - v), // b
      0, 0, 0, 1, 0, // a
    ];
  }
}

extension TintEffectExtensions<T> on AnimateManager<T> {
  /// Adds a [tint] extension to [AnimateManager] ([Animate] and [AnimateList]).
  T tint({
    Duration? delay,
    Duration? duration,
    Curve? curve,
    double? begin,
    double? end,
    Color? color,
  }) =>
      addEffect(TintEffect(
        delay: delay,
        duration: duration,
        curve: curve,
        begin: begin,
        end: end,
        color: color,
      ));

  /// Adds a [untint] extension to [AnimateManager] ([Animate] and [AnimateList]).
  /// This is identical to the [tint] extension, except it defaults to `begin=1, end=0`.
  T untint({
    Duration? delay,
    Duration? duration,
    Curve? curve,
    double? begin,
    double? end,
    Color? color,
  }) =>
      addEffect(TintEffect(
        delay: delay,
        duration: duration,
        curve: curve,
        begin: begin ?? 1.0,
        end: end ?? TintEffect.neutralValue,
        color: color,
      ));
}
