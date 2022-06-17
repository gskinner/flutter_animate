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
  void init(AnimationController controller) {}
}
