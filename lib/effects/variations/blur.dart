// ignore_for_file: overridden_fields

import 'package:flutter/widgets.dart';

import '../../flutter_animate.dart';

//TODO: Impplement this without needing to override begin/end
@immutable
class BlurXEffect extends CompositeEffect {
  const BlurXEffect({this.begin, this.end, super.delay, super.duration, super.curve});

  @override
  final double? begin;

  @override
  final double? end;

  @override
  List<Effect> get effects => [
        BlurEffect(
          begin: Offset(begin ?? BlurEffect.neutralBlur, 0),
          end: Offset(end ?? (begin == null ? BlurEffect.defaultBlur : BlurEffect.neutralBlur), 0),
        )
      ];
}

extension BlurEffectExtensions<T> on AnimateManager<T> {
  T blurX({
    Duration? delay,
    Duration? duration,
    Curve? curve,
    double? begin,
    double? end,
  }) =>
      addEffect(BlurXEffect(delay: delay, duration: duration, curve: curve));
}


/// TODO:
/// FadeInDown
/// FadeInLeft
/// FadeInRight