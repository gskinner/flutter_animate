import 'package:flutter/widgets.dart';

import '../../flutter_animate.dart';

/// Drives an [Animate] animation from a [ValueNotifier]. The value from the
/// notifier should be in the range `0-1`.
class ValueNotifierAdapter extends Adapter {
  ValueNotifierAdapter(this.notifier, {bool? animated})
      : super(animated: animated);

  final ValueNotifier<double> notifier;

  @override
  void attach(AnimationController controller) {
    config(controller, notifier.value);
    notifier.addListener(() => updateValue(notifier.value));
  }
}
