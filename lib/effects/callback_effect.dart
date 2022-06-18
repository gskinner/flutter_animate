import 'package:flutter/widgets.dart';

import '../flutter_animate.dart';

// TODO: this should be updated to work with reverse & repeat.

/// Effect that calls a callback function at a particular point in the animation.
/// For example:
///
/// ```
/// Text("Hello").animate().fadeIn(duration: 600.ms)
///  .callback(duration: 300.ms, callback: () => print('halfway'))
/// ```
@immutable
class CallbackEffect extends Effect<void> {
  const CallbackEffect({
    Duration? delay,
    Duration? duration,
    required this.callback,
  }) : super(
          delay: delay,
          duration: duration,
        );

  final VoidCallback callback;

  @override
  Widget build(
    BuildContext context,
    Widget child,
    AnimationController controller,
    EffectEntry entry,
  ) {
    // instead of setting up an animation, we can optimize a bit to calculate the callback time once:
    double ratio = getEndRatio(controller, entry);
    bool isComplete = false;
    controller.addListener(() {
      if (!isComplete && controller.value >= ratio) {
        isComplete = true;
        callback();
      }
    });
    return child;
  }
}

extension CallbackEffectExtensions<T> on AnimateManager<T> {
  /// Adds a `.callback()` extension to [AnimateManager] ([Animate] and [AnimateList]).
  T callback({
    Duration? delay,
    Duration? duration,
    required VoidCallback callback,
  }) =>
      addEffect(CallbackEffect(
        delay: delay,
        duration: duration,
        callback: callback,
      ));
}
