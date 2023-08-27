import 'package:flutter/widgets.dart';

import '../../flutter_animate.dart';

/// An effect that crossfades the incoming child (including preceeding effects)
/// with a new widget (via [Stack] and [FadeTransition]). It uses a [builder] so
/// that the effect can be reused, but note that the builder is only called once
/// when the effect initially builds.
///
/// [alignment] adjusts how the widgets are aligned if they are different sizes.
/// Defaults to [Alignment.center].
@immutable
class CrossfadeEffect extends Effect<double> {
  static const Alignment defaultAlignment = Alignment.center;

  const CrossfadeEffect({
    Duration? delay,
    Duration? duration,
    Curve? curve,
    Curve? reverseCurve,
    required this.builder,
    this.alignment,
  }) : super(
          delay: delay,
          duration: duration,
          curve: curve,
          reverseCurve: reverseCurve,
          begin: 0,
          end: 1,
        );

  final WidgetBuilder builder;
  final Alignment? alignment;

  @override
  Widget build(
    BuildContext context,
    Widget child,
    AnimationController controller,
    EffectEntry entry,
  ) {
    Animation<double> animation = buildAnimation(controller, entry);
    return Stack(
      alignment: alignment ?? defaultAlignment,
      children: [
        FadeTransition(opacity: ReverseAnimation(animation), child: child),
        FadeTransition(opacity: animation, child: builder(context)),
      ],
    );
  }
}

extension CrossfadeEffectExtensions<T> on AnimateManager<T> {
  /// Adds a [crossfade] extension to [AnimateManager] ([Animate] and [AnimateList]).
  T crossfade({
    Duration? delay,
    Duration? duration,
    Curve? curve,
    Curve? reverseCurve,
    required WidgetBuilder builder,
    Alignment? alignment,
  }) =>
      addEffect(CrossfadeEffect(
        delay: delay,
        duration: duration,
        curve: curve,
        reverseCurve: reverseCurve,
        builder: builder,
        alignment: alignment,
      ));
}
