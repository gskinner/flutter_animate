import 'dart:ui';
import 'package:flutter/widgets.dart';

import '../flutter_animate.dart';

/// Effect that animates a blur on the target (via [ImageFiltered])
/// between the specified begin and end blur radius values. Defaults to a blur radius of `begin=0, end=4`.
@immutable
class BlurEffect extends Effect<double> {
  const BlurEffect({
    Duration? delay,
    Duration? duration,
    Curve? curve,
    double? begin,
    double? end,
  }) : super(
          delay: delay,
          duration: duration,
          curve: curve,
          begin: begin ?? 0.0,
          end: end ?? defaultBlur,
        );

  @override
  Widget build(
    BuildContext context,
    Widget child,
    AnimationController controller,
    EffectEntry entry,
  ) {
    Animation<double> animation = buildAnimation(controller, entry);
    return getOptimizedBuilder<double>(
      animation: animation,
      builder: (_, __) => ImageFiltered(
        imageFilter: ImageFilter.blur(
          sigmaX: animation.value,
          sigmaY: animation.value,
          tileMode: TileMode.decal,
        ),
        child: child,
      ),
    );
  }
}

extension BlurEffectExtensions<T> on AnimateManager<T> {
  /// Adds a `.blur()` extension to [AnimateManager] ([Animate] and [AnimateList]).
  T blur({
    Duration? delay,
    Duration? duration,
    Curve? curve,
    double? begin,
    double? end,
  }) =>
      addEffect(BlurEffect(
        delay: delay,
        duration: duration,
        curve: curve,
        begin: begin,
        end: end,
      ));

  /// Adds an `.unblur()` extension to [AnimateManager] ([Animate] and [AnimateList]).
  /// This is identical to the `.blur()` extension, except it defaults to `begin=4, end=0`.
  T unblur({
    Duration? delay,
    Duration? duration,
    Curve? curve,
    double? begin = defaultBlur,
    double? end = 0,
  }) =>
      addEffect(BlurEffect(
        delay: delay,
        duration: duration,
        curve: curve,
        begin: begin,
        end: end,
      ));
}

const double defaultBlur = 4;