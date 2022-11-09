import 'package:flutter/widgets.dart';

import '../../flutter_animate.dart';

@immutable
class SlideOutUpEffect extends CompositeEffect {
  const SlideOutUpEffect({this.endY, super.delay, super.duration, super.curve});
  static const defaultEndY = .2;
  final double? endY;

  @override
  List<Effect> get effects => [
        SlideEffect(begin: Offset.zero, end: Offset(0, endY ?? defaultEndY)),
      ];
}

/*
TODO:
SlideOutDown
SlideOutLeft
SlideOutRight
*/

extension SlideOutExtensions<T> on AnimateManager<T> {
  T slideOutUp({double? endY, Duration? delay, Duration? duration, Curve? curve}) =>
      addEffect(SlideOutUpEffect(endY: endY, delay: delay, duration: duration, curve: curve));
}
