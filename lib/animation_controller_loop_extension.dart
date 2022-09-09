import 'package:flutter/widgets.dart';

/// Adds a [loop] extension on an AnimationController to allow looping the animation a defined number of times.
/// This extension mirrors the [repeat] method on AnimationController, and stops the animation when
/// the number of loops set by `count` parameter is reached.
/// If no `count` is provided, the animation loops infinitely (as [repeat]).
/// If a `count` is provided, it should be >= 0
///
/// More details on the `count` behavior (when `count` is not null and greater than zero):
///   - the total duration of the animation will respect: `count` * `period` (or `count` * `duration` if no `period` was provided)
///   - if the `reverse` parameter is turned off (`reverse` == `false`), the animation will end at the end of the animation, on the `max` bound
///   - if the `reverse` parameter is turned on (`reverse` == `true`), then:
///     - if `count` is odd: animation will stop at the end of the animation, on the `max` bound
///     - if `count` is even: animation will stop at the begin of the animation, on the `min` bound
///
/// Let's see the following example:
/// ```
///   const Text('Hello World')
///         .animate(
///           onPlay: (controller) => controller.loop(
///             reverse: true,
///             count: 2,
///           ),
///         )
///         .fadeIn();
/// ```
/// Here `reverse` is set to `true`, and `count` is `2`. So the text will fadeIn and then fadeOut (= reverse effect).
///
///
extension AnimationControllerLoopExtension on AnimationController {
  TickerFuture loop({
    int? count,
    bool reverse = false,
    double? min,
    double? max,
    Duration? period,
  }) {
    assert(count == null || count >= 0);

    min ??= lowerBound;
    max ??= upperBound;
    period ??= duration;

    final tickerFuture = repeat(
      min: min,
      max: max,
      reverse: reverse,
      period: period,
    );

    // if a `count` parameter is provided, stop the animation after the animation loops this `count` times.
    // else, loop infinitely
    if (count != null) {
      tickerFuture.timeout(period! * count, onTimeout: () async {
        (reverse && count.isEven) ? animateTo(min!) : animateTo(max!);
      });
    }

    return tickerFuture;
  }
}
