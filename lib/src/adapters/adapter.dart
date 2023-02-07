import 'dart:math';

import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

/// Adapters provide a mechanism to drive an animation from an arbitrary source.
/// For example, synchronizing an animation with a scroll, controlling
/// an animation with a slider input, or progressing an animation based on
/// the time of day.
///
/// Adapters must expose an `attach` method which accepts the
/// [AnimationController] used by an [Animate] instance, and adds the logic
/// to drive it from an external source by updating its `value` (0-1). See the
/// included adapters for implementation examples.
abstract class Adapter {
  Adapter({bool? animated}) : animated = animated ?? false;

  /// Indicates whether the adapter should animate to new values. If `false`, it
  /// will jump to the new value, if `true` it will animate to the value using a
  /// duration calculated from the animation's total duration and the value change.
  /// Defaults to `false`.
  final bool animated;

  AnimationController? _controller;

  // properties to support animated:
  Ticker? _ticker;
  double _target = 0;
  int _prevT = 0;

  // this is called by Animate to associate the AnimationController.
  // implementers must call config.
  void attach(AnimationController controller) => config(controller, 0);

  // disassociates the controller, which also allows the adapter to be re-attached.
  @mustCallSuper
  void detach() {
    _controller = null;
    _ticker?.stop();
  }

  // called by implementers to attach the controller, and set an initial value.
  void config(AnimationController controller, double value) {
    assert(_controller == null, 'An adapter was assigned twice.');
    _controller = controller;
    _controller?.value = value;
    _ticker = Ticker(_tick);
  }

  // called by implementers to update the value.
  void updateValue(double value) {
    AnimationController controller = _controller!;

    if (!animated) {
      controller.value = value;
    } else if (value != controller.value) {
      Ticker ticker = _ticker!;
      _target = value;
      _prevT = DateTime.now().microsecondsSinceEpoch;
      if (!ticker.isActive) ticker.start();
    }
  }

  void _tick(_) {
    // The first tick from a Ticker always has a zero duration, which causes
    // animateTo to lock or stutter when changing values repeatedly. so this
    // uses a custom implementation to animate between values.
    AnimationController controller = _controller!;

    int t = DateTime.now().microsecondsSinceEpoch;
    double d = (t - _prevT) / controller.duration!.inMicroseconds;
    double val = controller.value;

    if (val < _target) {
      val = min(_target, val + d);
    } else {
      val = max(_target, val - d);
    }

    _prevT = t;
    controller.value = val;
    if (val == _target) _ticker!.stop();
  }
}
