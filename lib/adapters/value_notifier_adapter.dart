import 'package:flutter/widgets.dart';

import '../flutter_animate.dart';

/// Drives an [Animate] animation from a [ValueNotifier]. The value from the
/// notifier should be in the range `0-1`.
@immutable
class ValueNotifierAdapter extends Adapter {
  const ValueNotifierAdapter(this.notifier, {bool? animated})
      : super(animated: animated);

  final ValueNotifier<double> notifier;

  @override
  void init(AnimationController controller) {
    controller.value = notifier.value;
    notifier.addListener(() {
      controller.animateTo(
        notifier.value,
        duration: animated ? null : Duration.zero,
      );
    });
  }
}
