import 'package:flutter/widgets.dart';

import '../../flutter_animate.dart';

/// Drives an [Animate] animation from a [ChangeNotifier]. The [valueGetter]
/// should provide a value in the range `0-1` when a change occurs.
///
/// See [Adapter] for information on [direction] and [animated].
class ChangeNotifierAdapter extends Adapter {
  ChangeNotifierAdapter(
    this.notifier,
    this.valueGetter, {
    bool? animated,
    Direction? direction,
  }) : super(animated: animated, direction: direction);

  final ChangeNotifier notifier;
  final ValueGetter<double> valueGetter;

  @override
  void attach(AnimationController controller) {
    config(
      controller,
      valueGetter(),
      notifier: notifier,
      listener: () => updateValue(valueGetter()),
    );
  }
}
