import 'package:flutter/widgets.dart';

import '../../flutter_animate.dart';

/*
TODO:
 FadeInDown
 FadeInLeft
 FadeInRight
*/

@immutable
class FadeInEffect extends Effect with CompositeEffectMixin {
  const FadeInEffect({super.delay, super.duration, super.curve});

  @override
  List<Effect> get effects => const [FadeEffect(begin: 0, end: 1)];
}

@immutable
class FadeInUpEffect extends Effect with CompositeEffectMixin {
  const FadeInUpEffect({this.beginY, super.delay, super.duration, super.curve});

  final double? beginY;

  @override
  List<Effect> get effects => [
        const FadeInEffect(),
        SlideInUpEffect(beginY: beginY),
      ];
}

extension FadeInEffectExtensions<T> on AnimateManager<T> {
  T fadeIn({Duration? delay, Duration? duration, Curve? curve}) =>
      addEffect(FadeInEffect(delay: delay, duration: duration, curve: curve));

  T fadeInUp({double? beginY, Duration? delay, Duration? duration, Curve? curve}) =>
      addEffect(FadeInUpEffect(beginY: beginY, delay: delay, duration: duration, curve: curve));
}
