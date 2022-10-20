import 'package:flutter/widgets.dart';

import '../flutter_animate.dart';

/// Effect that toggles the visibility of the target (via [Visibility]).
/// Defaults to `end=true`.
///
/// The `maintain` parameter is assigned to the [Visibility] properties `maintainSize`,
/// `maintainAnimation`, `maintainState`, and `maintainSemantics`.
@immutable
class VisibilityEffect extends Effect<bool> {
  const VisibilityEffect({
    Duration? delay,
    Duration? duration,
    bool? end,
    bool? maintain,
  })  : maintain = maintain ?? true,
        super(
          delay: delay,
          duration: duration,
          begin: !(end ?? true),
          end: end ?? true,
        );

  final bool maintain;

  @override
  Widget build(BuildContext context, Widget child,
      AnimationController controller, EffectEntry entry) {
    double ratio = getEndRatio(controller, entry);
    return getToggleBuilder(
      animation: controller,
      child: child,
      toggle: () => begin! == (controller.value < ratio),
      builder: (_, b, __) => Visibility(
        visible: b,
        maintainSize: maintain,
        maintainAnimation: maintain,
        maintainState: maintain,
        maintainSemantics: maintain,
        child: child,
      ),
    );
  }
}

extension VisibilityEffectExtensions<T> on AnimateManager<T> {
  /// Adds a [visibility] extension to [AnimateManager] ([Animate] and [AnimateList]).
  T visibility({
    Duration? delay,
    Duration? duration,
    bool? end,
    bool? maintain,
  }) =>
      addEffect(VisibilityEffect(
        delay: delay,
        duration: duration,
        end: end,
        maintain: maintain,
      ));

  /// Adds a [show] extension to [AnimateManager] ([Animate] and [AnimateList]).
  /// This creates a [VisibilityEffect] with `end=true`
  T show({
    Duration? delay,
    Duration? duration,
    bool? maintain,
  }) =>
      addEffect(VisibilityEffect(
        delay: delay,
        duration: duration,
        end: true,
        maintain: maintain,
      ));

  /// Adds a [hide] extension to [AnimateManager] ([Animate] and [AnimateList]).
  /// This creates a [VisibilityEffect] with `end=false`
  T hide({
    Duration? delay,
    Duration? duration,
    bool? maintain,
  }) =>
      addEffect(VisibilityEffect(
        delay: delay,
        duration: duration,
        end: false,
        maintain: maintain,
      ));
}
