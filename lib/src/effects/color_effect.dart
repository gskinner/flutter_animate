import 'package:flutter/widgets.dart';

import '../../flutter_animate.dart';

/// An effect that animates between two colors, composited with the target with
/// the specified [BlendMode].
///
/// See also: [TintEffect], which provides a simpler interface for single color
/// tints.
///
/// [blendMode] lets you adjust how the color fill is composited. It defaults to
/// [BlendMode.color]. Note that most blend modes in Flutter (including `color`)
/// do not respect the alpha channel correctly. See [BlendMode.srcATop] or
/// [BlendMode.srcIn] for options that do maintain alpha.
///
/// For example, this would animate from red to blue with a `multiply` blend:
///
/// ```
/// Image.asset('assets/rainbow.jpg').animate()
///   .color(begin: Colors.red, end: Colors.blue, blendMode: BlendMode.multiply)
/// ```
@immutable
class ColorEffect extends Effect<Color?> {
  static const Color? neutralValue = null;
  static const Color defaultValue = Color(0x800099FF);
  static const BlendMode defaultBlendMode = BlendMode.color;

  const ColorEffect({
    Duration? delay,
    Duration? duration,
    Curve? curve,
    Color? begin,
    Color? end,
    this.blendMode,
  }) : super(
          delay: delay,
          duration: duration,
          curve: curve,
          begin: begin ?? neutralValue,
          end: end ?? (begin == null ? defaultValue : neutralValue),
        );

  final BlendMode? blendMode;

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
      builder: (_, __) {
        Color color = ColorTween(begin: begin, end: end).evaluate(animation) ??
            const Color(0x00000000);
        return ColorFiltered(
          colorFilter: ColorFilter.mode(color, blendMode ?? defaultBlendMode),
          child: child,
        );
      },
    );
  }
}

extension ColorEffectExtension<T> on AnimateManager<T> {
  /// Adds a [color] extension to [AnimateManager] ([Animate] and [AnimateList]).
  T color({
    Duration? delay,
    Duration? duration,
    Curve? curve,
    Color? begin,
    Color? end,
    BlendMode? blendMode,
  }) =>
      addEffect(ColorEffect(
        delay: delay,
        duration: duration,
        curve: curve,
        begin: begin,
        end: end,
        blendMode: blendMode,
      ));
}
