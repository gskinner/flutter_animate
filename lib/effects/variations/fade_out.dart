import 'package:flutter/widgets.dart';

import '../../flutter_animate.dart';

/* 
TODO: 
FadeOutDown
FadeOutLeft
FadeOutRight
*/

@immutable
class FadeOutEffect extends Effect with CompositeEffectMixin {
  const FadeOutEffect({super.delay, super.duration, super.curve});

  @override
  List<Effect> get effects => const [FadeEffect(begin: 1, end: 0)];
}

@immutable
class FadeOutUpEffect extends Effect with CompositeEffectMixin {
  const FadeOutUpEffect({this.endY, super.delay, super.duration, super.curve});

  final double? endY;

  @override
  List<Effect> get effects => [const FadeOutEffect(), SlideOutUpEffect(endY: endY)];
}

extension FadeOutEffectExtensions<T> on AnimateManager<T> {
  T fadeOut({Duration? delay, Duration? duration, Curve? curve}) =>
      addEffect(FadeOutEffect(delay: delay, duration: duration, curve: curve));

  T fadeOutUp({double? endY, Duration? delay, Duration? duration, Curve? curve}) =>
      addEffect(FadeOutUpEffect(endY: endY, delay: delay, duration: duration, curve: curve));
}
