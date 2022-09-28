import 'package:flutter/widgets.dart';

import '../flutter_animate.dart';

// TODO: maybe add a `transformer` (TBD) function as an optional named param to modify the value.

/// Drives an [Animate] animation from a [ValueNotifier]. The value from the
/// notifier should be in the range `0-1`.
@immutable
class ValueNotifierAdapter extends Adapter {
  ValueNotifierAdapter(this.notifier, {this.duration});

  final ValueNotifier<double> notifier;

  // currently duplicated here and in ChangeNotifierAdapter:
  /// Controls how the adapter animates to a new value:
  ///
  /// - `null` (default) will calculate the duration automatically based on the value change and the total animation duration
  /// - [Duration.zero] (or `0.ms`) will skip animation, jumping directly to the new value
  /// - set a animation duration that will be used for all changes
  final Duration? duration;

  @override
  void init(AnimationController controller) {
    controller.value = notifier.value;
    notifier.addListener(() {
      controller.animateTo(notifier.value, duration: duration);
    });
  }
}
