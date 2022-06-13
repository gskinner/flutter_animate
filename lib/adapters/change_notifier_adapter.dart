import 'package:flutter/widgets.dart';

import '../flutter_animate.dart';

/// Drives an [Animate] animation from a [ChangeNotifier]. The [valueGetter]
/// should provide a value in the range `0-1` when a change occurs.
@immutable
class ChangeNotifierAdapter extends Adapter {
  ChangeNotifierAdapter(this.notifier, this.valueGetter);

  final ChangeNotifier notifier;
  final ValueGetter<double> valueGetter;

  @override
  void init(AnimationController controller) {
    notifier.addListener(() {
      controller.value = valueGetter();
    });
  }
}
