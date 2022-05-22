import 'package:flutter/widgets.dart';

import '../flutter_animate.dart';

// TODO: possibly add other properties of visibility as params?

/// Effect that toggles the visibility of the target (via [Visibility]).
/// Defaults to `begin=false, end=true`.
/// 
/// The `maintain` parameter is assigned to the [Visibility] properties 'maintainSize`,
/// `maintainAnimation`, `maintainState`, and `maintainSemantics`.
@immutable
class VisibilityEffect extends Effect<bool> {
  const VisibilityEffect({
    Duration? delay,
    Duration? duration,
    bool end = true,
    this.maintain = true,
  }) : super(
          delay: delay,
          duration: duration,
          begin: !end,
          end: end,
        );

  final bool maintain;

  @override
  Widget build(BuildContext context, Widget child,
      AnimationController controller, EffectEntry entry) {
    // instead of setting up an animation, we can optimize a bit to calculate the callback time once:
    double ratio = getEndRatio(controller, entry);

    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) => Visibility(
        visible: begin! == (controller.value < ratio),
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
  /// Adds a `.visibility()` extension to [AnimateManager] ([Animate] and [AnimateList]).
  T visibility({
    Duration? delay,
    Duration? duration,
    bool maintain = true,
    bool end = false,
  }) =>
      addEffect(VisibilityEffect(
        delay: delay,
        duration: duration,
        end: end,
        maintain: maintain,
      ));

  /// Adds a `.show()` extension to [AnimateManager] ([Animate] and [AnimateList]).
  /// This creates a [VisibilityEffect] with `end=true`
  T show({
    Duration? delay,
    Duration? duration,
    bool maintain = true,
  }) =>
      addEffect(VisibilityEffect(
        delay: delay,
        duration: duration,
        end: true,
        maintain: maintain,
      ));

  /// Adds a `.hide()` extension to [AnimateManager] ([Animate] and [AnimateList]).
  /// This creates a [VisibilityEffect] with `end=false`
  T hide({
    Duration? delay,
    Duration? duration,
    bool maintain = true,
  }) =>
      addEffect(VisibilityEffect(
        delay: delay,
        duration: duration,
        end: false,
        maintain: maintain,
      ));
}
