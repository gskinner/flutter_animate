import 'package:flutter/widgets.dart';

import '../flutter_animate.dart';

/// Effect that swaps out the incoming child for a new child at a particular
/// point in time. This includes all preceeding effects. For example, this would
/// fade out `foo`, swap it for `Bar()` (including discarding the `fadeOut` effect)
/// and apply a fade in effect.
///
/// ```
/// foo.animate()
///   .fadeOut(duration: 500.ms)
///   .swap( // inherits duration from fadeOut
///     builder: () => Bar().fadeIn(),
///   )
/// ```
///
/// It uses a builder so that the effect can be reused, but note that the
/// builder is only called once when the effect builds initially.
@immutable
class SwapEffect extends Effect<void> {
  const SwapEffect({
    Duration? delay,
    Duration? duration,
    required this.builder,
  }) : super(
          delay: delay,
          duration: duration,
        );

  final WidgetBuilder builder;

  @override
  Widget build(
    BuildContext context,
    Widget child,
    AnimationController controller,
    EffectEntry entry,
  ) {
    // instead of setting up an animation, we can optimize a bit to calculate the callback time once:
    double ratio = getEndRatio(controller, entry);
    Widget endChild = builder(context);

    // this could use toggleBuilder, but everything is pre-built, so this is simpler:
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) => (controller.value < ratio) ? child : endChild,
    );
  }
}

extension SwapEffectExtensions<T> on AnimateManager<T> {
  /// Adds a `.swap()` extension to [AnimateManager] ([Animate] and [AnimateList]).
  T swap({
    Duration? delay,
    Duration? duration,
    required WidgetBuilder builder,
  }) =>
      addEffect(SwapEffect(
        delay: delay,
        duration: duration,
        builder: builder,
      ));
}
