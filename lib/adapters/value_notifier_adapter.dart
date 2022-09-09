import 'package:flutter/widgets.dart';

import '../flutter_animate.dart';

// TODO: maybe add a `transformer` (TBD) function as an optional (named?) param to modify the value.

/// Drives an [Animate] animation from a [ValueNotifier]. The value from the
/// notifier should be in the range `0-1`.
/// The [Duration] parameter allows to enable or disable the animation, or update the Animation Duration:
/// - set a `null` [Duration] (or leave it empty) to animate and preserve Animation parameters (default behavior) ;
/// - set a zero [Duration] (short with `0.ms`) to disable the Animation ;
/// - set a new [Duration] to update the Animation duration.
@immutable
class ValueNotifierAdapter extends Adapter {
  ValueNotifierAdapter(this.notifier, {this.duration});

  final ValueNotifier<double> notifier;
  final Duration? duration;

  @override
  void init(AnimationController controller) {
    controller.value = notifier.value;
    notifier.addListener(() {
      controller.animateTo(notifier.value, duration: duration);
    });
  }
}
