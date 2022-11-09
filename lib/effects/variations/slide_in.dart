import 'package:flutter/widgets.dart';

import '../../flutter_animate.dart';

@immutable
class SlideInUpEffect extends CompositeEffect {
  const SlideInUpEffect({this.beginY, super.delay, super.duration, super.curve});
  static const defaultBeginY = -.2;
  final double? beginY;

  @override
  List<Effect> get effects => [
        SlideEffect(begin: Offset(0, beginY ?? defaultBeginY), end: Offset.zero),
      ];
}

/* 
TODO: 
SlideInDown
SlideInLeft
SlideInRight
*/

extension SlideInExtensions<T> on AnimateManager<T> {
  T slideInUp({double? beginY, Duration? delay, Duration? duration, Curve? curve}) =>
      addEffect(SlideInUpEffect(beginY: beginY, delay: delay, duration: duration, curve: curve));
}
