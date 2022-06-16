import 'package:flutter/widgets.dart';

import '../flutter_animate.dart';
// TODO: catch issues with things like unbounded scrolling
// TODO: simplify setting a begin/end based on position of items in scroll?

/// Drives an [Animate] animation from a [ScrollController]. [begin] and [end]
/// allow you to specify a pixel range for the scroll to update the animation
/// within. They default to `minScrollExtent` and `maxScrollExtent` respectively.
///
/// For example, this starts fading/sliding in the text once the list scrolls to
/// 100px, and finishes when it reaches the end of the scroll:
///
/// ```
/// ListView(
///   controller: scrollController,
///   children: items,
/// );
/// Text("Hello").animate(
///   adapter: ScrollAdapter(scrollController, begin: 100)
/// ).fadeIn().slide();
/// ```
@immutable
class ScrollAdapter extends ChangeNotifierAdapter {
  ScrollAdapter(ScrollController scrollController, {this.begin, this.end})
      : super(scrollController, () {
          ScrollPosition pos = scrollController.position;
          double min = pos.minScrollExtent, max = pos.maxScrollExtent;
          double minPx = _getPx(begin, min, max, min);
          double maxPx = _getPx(end, min, max, max);
          return (pos.pixels - minPx) / (maxPx - minPx);
        });

  final double? begin;
  final double? end;
}

double _getPx(double? val, double min, double max, double deflt) {
  if (val == null) return deflt;
  if (val <= 0) return max + val;
  return min + val;
}
