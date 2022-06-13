import 'package:flutter/widgets.dart';

import '../flutter_animate.dart';

// TODO: maybe add a `transformer` (TBD) function as an optional (named?) param to modify the value.

/// Drives an [Animate] animation from a [ValueNotifier]. The value from the
/// notifier should be in the range `0-1`.
@immutable
class ValueNotifierAdapter extends Adapter {
  ValueNotifierAdapter(this.notifier);

  final ValueNotifier<double> notifier;

  @override
  void init(AnimationController controller) {
    controller.value = notifier.value;
    notifier.addListener(() {
      controller.value = notifier.value;
    });
  }
}
