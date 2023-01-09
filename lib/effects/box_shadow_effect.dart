import 'package:flutter/widgets.dart';

import '../flutter_animate.dart';

/// An effect to apply an animated rectangular drop shadow (via [DecoratedBox]).
/// The [begin] and [end] parameters accept [BoxShadow] instances to animate between.
/// You can also specify a [borderRadius] that defines rounded corners for the shadow.
///
/// See also: [ElevationEffect] for simpler animated shadows based on elevation.
@immutable
class BoxShadowEffect extends Effect<BoxShadow> {
  static const BoxShadow neutralValue = BoxShadow(color: Color(0x00000000));
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
    Animation<BoxShadow> animation = _buildAnimation(controller, entry);
    return getOptimizedBuilder<BoxShadow>(
      animation: animation,
      builder: (_, __) => DecoratedBox(
        decoration: BoxDecoration(
          boxShadow: [animation.value],
          borderRadius: borderRadius,
        ),
        child: child,
      ),
    );
  }

  Animation<BoxShadow> _buildAnimation(
    AnimationController controller,
    EffectEntry entry,
  ) {
    return entry
        .buildAnimation(controller)
        .drive(_BoxShadowTween(begin: begin, end: end));
  }
}

class _BoxShadowTween extends Tween<BoxShadow> {
  /// Creates a box shadow tween.
  _BoxShadowTween({begin, end}) : super(begin: begin, end: end);

  /// Returns the value this variable has at the given animation clock value.
  @override
  BoxShadow lerp(double t) => BoxShadow.lerp(begin, end, t)!;
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
