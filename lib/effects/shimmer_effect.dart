import 'dart:math';

import 'package:flutter/widgets.dart';

import '../flutter_animate.dart';

/// An effect that enables gradient effects, such as the shimmer loading effect
/// [popularized by facebook](https://facebook.github.io/shimmer-android/).
///
/// By default it animates a simple 50% white gradient clipped by the child content.
/// However it provides a large amount of customization, including changing the
/// gradient angle, the gradient colors / stops, and specifying the blend mode.
///
/// If `colors` is not specified then it will use `color` to build one:
/// `[transparent, color, transparent]`.
///
/// `blendMode` lets you adjust how the gradient fill is composited. It defaults to
/// [BlendMode.srcATop], which layers the fill over the child, using the child's
/// alpha (ie. the child acts as a mask). Other interesting options include:
///
/// * [BlendMode.srcIn] which uses the child as a mask
/// * [BlendMode.srcOver] layers the gradient fill over the child (no masking)
/// * [BlendMode.dstOver] layers the gradient fill under the child (no masking)
@immutable
class ShimmerEffect extends BeginEndEffect<double> {
  static const Color defaultColor = Color(0x80FFFFFF);
  static const double defaultSize = 1;
  static const double defaultAngle = pi / 12;
  static const BlendMode defaultBlendMode = BlendMode.srcATop;

  const ShimmerEffect({
    Duration? delay,
    Duration? duration,
    Curve? curve,
    this.color,
    this.colors,
    this.stops,
    this.size,
    this.angle,
    this.blendMode,
  }) : super(
          delay: delay,
          duration: duration,
          curve: curve,
          begin: 0,
          end: 1,
        );

  final Color? color;
  final List<Color>? colors;
  final List<double>? stops;
  final double? size;
  final double? angle;
  final BlendMode? blendMode;

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
      builder: (_, __) {
        LinearGradient gradient = _buildGradient(animation.value);
        return ShaderMask(
          blendMode: blendMode ?? defaultBlendMode,
          shaderCallback: (bounds) => gradient.createShader(bounds),
          child: child,
        );
      },
    );
  }

  LinearGradient _buildGradient(double value) {
    final Color col = color ?? defaultColor, transparent = col.withOpacity(0);
    final List<Color> cols = colors ?? [transparent, col, transparent];

    return LinearGradient(
      colors: cols,
      stops: stops,
      transform: _SweepingGradientTransform(
        ratio: value,
        angle: angle ?? defaultAngle,
        scale: size ?? defaultSize,
      ),
    );
  }
}

extension ShimmerEffectExtensions<T> on AnimateManager<T> {
  /// Adds a [shimmer] extension to [AnimateManager] ([Animate] and [AnimateList]).
  T shimmer({
    Duration? delay,
    Duration? duration,
    Curve? curve,
    Color? color,
    List<Color>? colors,
    List<double>? stops,
    double? size,
    double? angle,
    BlendMode? blendMode,
  }) =>
      addEffect(ShimmerEffect(
        delay: delay,
        duration: duration,
        curve: curve,
        color: color,
        colors: colors,
        stops: stops,
        size: size,
        angle: angle,
        blendMode: blendMode,
      ));
}

class _SweepingGradientTransform extends GradientTransform {
  const _SweepingGradientTransform({
    required this.ratio,
    required this.angle,
    required this.scale,
  });

  final double angle;
  final double ratio;
  final double scale;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    // minimum width / height to avoid infinity errors:
    double w = max(0.01, bounds.width), h = max(0.01, bounds.height);

    // calculate the radius of the rect:
    double r = (cos(angle) * w).abs() + (sin(angle) * h).abs();

    // set up the transformation matrices:
    Matrix4 transformMtx = Matrix4.identity()
      ..rotateZ(angle)
      ..scale(r / w * scale);

    double range = w * (1 + scale) / scale;
    Matrix4 translateMtx = Matrix4.identity()..translate(range * (ratio - 0.5));

    // Convert from [-1 - +1] to [0 - 1], & find the pixel location of the gradient center:
    Offset pt = Offset(bounds.left + w * 0.5, bounds.top + h * 0.5);

    // This offsets the draw position to account for the widget's position being
    // multiplied against the transformation:
    List<double> loc = transformMtx.applyToVector3Array([pt.dx, pt.dy, 0.0]);
    double dx = pt.dx - loc[0], dy = pt.dy - loc[1];

    return Matrix4.identity()
      ..translate(dx, dy, 0.0) // center origin
      ..multiply(transformMtx) // rotate and scale
      ..multiply(translateMtx); // translate
  }
}
