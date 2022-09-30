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
///
/// Adapters should be immutable, so that they can be shared between animations.
@immutable
class Adapter {
  const Adapter({bool? animated}) : animated = animated ?? false;

  void init(AnimationController controller) {}

  /// Indicates whether the adapter should animate to a new value. If `false`, it
  /// will jump to the new value, if `true` it will animate to the value using a
  /// duration calculated from the animation's total duration and the value change.
  /// Defaults to `false`.
  final bool animated;
}
