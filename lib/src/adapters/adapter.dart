import 'package:flutter/widgets.dart';

/// Adapters provide a mechanism to drive an animation from an arbitrary source.
/// For example, synchronizing an animation with a scroll, controlling
/// an animation with a slider input, or progressing an animation based on
/// the time of day.
///
/// Adapters must expose an `init` method which accepts the
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

  // this is called by Animate to associate the AnimationController.
  void attach(AnimationController controller) => config(controller, 0);

  // disassociates the controller, which also allows the adapter to be re-attached.
  @mustCallSuper
  void detach() => _controller = null;

  // called by Adapter subclasses to attach the controller, and set an initial value.
  void config(AnimationController controller, double value) {
    assert(_controller == null, 'An adapter was assigned twice.');
    _controller = controller;
    _controller?.value = value;
  }

  // called by Adapter subclasses to update the value.
  void updateValue(double value) {
    _controller?.animateTo(value, duration: animated ? null : Duration.zero);
  }
}
