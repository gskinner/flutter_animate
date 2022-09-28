import 'package:flutter/widgets.dart';

import '../flutter_animate.dart';

/// Drives an [Animate] animation from a [ChangeNotifier]. The [valueGetter]
/// should provide a value in the range `0-1` when a change occurs.
@immutable
class ChangeNotifierAdapter extends Adapter {
  ChangeNotifierAdapter(this.notifier, this.valueGetter, {this.duration});

  final ChangeNotifier notifier;
  final ValueGetter<double> valueGetter;

  // currently duplicated here and in ValueNotifierAdapter:
  /// Controls how the adapter animates to a new value:
  ///
  /// - `null` (default) will calculate the duration automatically based on the value change and the total animation duration
  /// - [Duration.zero] (or `0.ms`) will skip animation, jumping directly to the new value
  /// - set a animation duration that will be used for all changes
  final Duration? duration;

  @override
  void init(AnimationController controller) {
    notifier.addListener(() {
      controller.animateTo(valueGetter(), duration: duration);
    });
  }
}
