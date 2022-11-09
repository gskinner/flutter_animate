// ignore_for_file: overridden_fields

import 'package:flutter/widgets.dart';

import '../../flutter_animate.dart';

@immutable
class BlurXEffect extends BeginEndEffect<double> with CompositeEffectMixin {
  const BlurXEffect({super.begin, super.end, super.delay, super.duration, super.curve});

  @override
  List<BeginEndEffect> get effects => [
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
/// BlurY
/// BlurXY
