import 'package:flutter/widgets.dart';

import '../flutter_animate.dart';

/// Effect that allows you to toggle the behavior of a builder function at a certain
/// point in time.
///
/// ```
/// Animate().toggle(duration: 500.ms, builder: (_, value, __) =>
///   Text('${value ? "Before Delay" : "After Delay"}'))
/// ```
///
/// This is also useful for triggering animation in "Animated" widgets.
///
/// ```
/// foo.animate().toggle(duration: 500.ms, builder: (_, value, child) =>
///   AnimatedOpacity(opacity: value ? 0 : 1, child: child))
/// ```
///
/// The child of `Animate` is passed through to the builder in the `child` param
/// (possibly already wrapped by prior effects).
@immutable
class ToggleEffect extends Effect {
  const ToggleEffect({
    Duration? delay,
    Duration? duration,
    required this.builder,
  }) : super(
          delay: delay,
          duration: duration,
        );

  final ToggleEffectBuilder builder;

  @override
  Widget build(
    BuildContext context,
    Widget child,
    AnimationController controller,
    EffectEntry entry,
  ) {
    double ratio = getEndRatio(controller, entry);
    return getToggleBuilder(
      animation: controller,
      child: child,
      toggle: () => controller.value < ratio,
      builder: builder,
    );
  }
}

extension ToggleEffectExtensions<T> on AnimateManager<T> {
  /// Adds a [toggle] extension to [AnimateManager] ([Animate] and [AnimateList]).
  T toggle({
    Duration? delay,
    Duration? duration,
    required ToggleEffectBuilder builder,
  }) =>
      addEffect(ToggleEffect(
        delay: delay,
        duration: duration,
        builder: builder,
      ));
}

typedef ToggleEffectBuilder = Widget Function(
  BuildContext context,
  bool value,
  Widget child,
);
