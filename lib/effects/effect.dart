import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import '../flutter_animate.dart';

/// Class that defines the required interface and helper methods for
/// all effect classes. Look at the various effects for examples of how
/// to build new reusable effects. One-off effects can be implemented with
/// [CustomEffect].
///
/// It can be instantiated and added to Animate, but has no visual effect.
@immutable
class Effect<T> {
  /// The specified delay for the effect. If null, will use the delay from the
  /// previous effect, or [Duration.zero] if this is the first effect.
  final Duration? delay;

  /// The specified duration for the effect. If null, will use the duration from the
  /// previous effect, or [Animate.defaultDuration] if this is the first effect.
  final Duration? duration;

  /// The specified curve for the effect. If null, will use the curve from the
  /// previous effect, or [Animate.defaultCurve] if this is the first effect.
  final Curve? curve;

  /// The begin value for the effect. If null, effects should use a reasonable
  /// default value when appropriate.
  final T? begin;

  /// The end value for the effect. If null, effects should use a reasonable
  /// default value when appropriate.
  final T? end;

  const Effect({this.delay, this.duration, this.curve, this.begin, this.end});

  /// Builds the widgets necessary to implement the effect, based on the
  /// provided [AnimationController] and [EffectEntry].
  Widget build(
    BuildContext context,
    Widget child,
    AnimationController controller,
    EffectEntry entry,
  ) {
    return child;
  }

  /// Returns an animation based on the controller, entry, and begin/end values.
  Animation<T> buildAnimation(
    AnimationController controller,
    EffectEntry entry,
  ) {
    return entry
        .buildAnimation(controller)
        .drive(Tween<T>(begin: begin, end: end));
  }

  /// Returns a ratio corresponding to the beginning of the specified entry.
  double getBeginRatio(AnimationController controller, EffectEntry entry) {
    int ms = controller.duration?.inMilliseconds ?? 0;
    return ms == 0 ? 0 : entry.begin.inMilliseconds / ms;
  }

  /// Returns a ratio corresponding to the end of the specified entry.
  double getEndRatio(AnimationController controller, EffectEntry entry) {
    int ms = controller.duration?.inMilliseconds ?? 0;
    return ms == 0 ? 0 : entry.end.inMilliseconds / ms;
  }

  /// Check if the animation is currently running / active.
  bool isAnimationActive(Animation animation) {
    AnimationStatus status = animation.status;
    return status == AnimationStatus.forward ||
        status == AnimationStatus.reverse;
  }

  /// Returns an optimized [AnimatedBuilder] that doesn't
  /// rebuild if the value hasn't changed.
  AnimatedBuilder getOptimizedBuilder<U>({
    required ValueListenable<U> animation,
    Widget? child,
    required TransitionBuilder builder,
  }) {
    U? value;
    Widget? widget;
    return AnimatedBuilder(
      animation: animation,
      builder: (ctx, _) {
        if (animation.value != value) widget = null;
        value = animation.value;
        return widget = widget ?? builder(ctx, child);
      },
    );
  }

  /// Returns an [AnimatedBuilder] that rebuilds when the
  /// boolean value returned by the `toggle` function changes.
  AnimatedBuilder getToggleBuilder({
    required ValueListenable<double> animation,
    required Widget child,
    required bool Function() toggle,
    required ToggleEffectBuilder builder,
  }) {
    ValueNotifier<bool> notifier = ValueNotifier<bool>(toggle());
    animation.addListener(() => notifier.value = toggle());
    return AnimatedBuilder(
      animation: notifier,
      builder: (ctx, _) => builder(ctx, notifier.value, child),
    );
  }
}

extension EffectExtensions<T> on AnimateManager<T> {
  /// Adds an [effect] extension to [AnimateManager] ([Animate] and [AnimateList]).
  T effect({
    Duration? delay,
    Duration? duration,
    Curve? curve,
    double? begin,
    double? end,
  }) =>
      addEffect(Effect(
        delay: delay,
        duration: duration,
        curve: curve,
        begin: begin,
        end: end,
      ));
}
