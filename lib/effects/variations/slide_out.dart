import 'package:flutter/widgets.dart';

import '../../flutter_animate.dart';

/*
TODO:
SlideOutDown
SlideOutLeft
SlideOutRight
*/
@immutable
class SlideOutUpEffect extends Effect with CompositeEffectMixin {
  const SlideOutUpEffect({this.endY, super.delay, super.duration, super.curve});
  static const defaultEndY = .2;
  final double? endY;

  @override
  List<Effect> get effects => [
        SlideEffect(begin: Offset.zero, end: Offset(0, endY ?? defaultEndY)),
      ];
}

extension SlideOutExtensions<T> on AnimateManager<T> {
  T slideOutUp({double? endY, Duration? delay, Duration? duration, Curve? curve}) =>
      addEffect(SlideOutUpEffect(endY: endY, delay: delay, duration: duration, curve: curve));
}
