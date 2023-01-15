import 'package:flutter/widgets.dart';

import '../flutter_animate.dart';

/// An effect to apply an animated rectangular drop shadow (via [DecoratedBox]).
/// The [begin] and [end] parameters accept [BoxShadow] instances to animate between.
/// You can also specify a [borderRadius] that defines rounded corners for the shadow.
///
/// See also: [ElevationEffect] for simpler animated shadows based on elevation.
@immutable
class BoxShadowEffect extends Effect<BoxShadow> {
  static const BoxShadow? neutralValue = null;
  static const BoxShadow defaultValue = BoxShadow(
    color: Color(0x80000000),
    blurRadius: 8.0,
    offset: Offset(0.0, 4.0),
  );

  const BoxShadowEffect({
    Duration? delay,
    Duration? duration,
    Curve? curve,
    BoxShadow? begin,
    BoxShadow? end,
    this.borderRadius,
  }) : super(
          delay: delay,
          duration: duration,
          curve: curve,
          begin: begin ?? neutralValue,
          end: end ?? (begin == null ? defaultValue : neutralValue),
        );

  final BorderRadius? borderRadius;

  @override
  Widget build(
    BuildContext context,
    Widget child,
    AnimationController controller,
    EffectEntry entry,
  ) {
    Animation<double> animation = entry.buildAnimation(controller);
    return getOptimizedBuilder<double>(
      animation: animation,
      builder: (_, __) => DecoratedBox(
        decoration: BoxDecoration(
          boxShadow: [BoxShadow.lerp(begin, end, animation.value)!],
          borderRadius: borderRadius,
        ),
        child: child,
      ),
    );
  }
}

extension BoxShadowEffectExtensions<T> on AnimateManager<T> {
  /// Adds a [boxShadow] extension to [AnimateManager] ([Animate] and [AnimateList]).
  T boxShadow({
    Duration? delay,
    Duration? duration,
    Curve? curve,
    BoxShadow? begin,
    BoxShadow? end,
    BorderRadius? borderRadius,
  }) =>
      addEffect(BoxShadowEffect(
        delay: delay,
        duration: duration,
        curve: curve,
        begin: begin,
        end: end,
        borderRadius: borderRadius,
      ));
}
