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
          double minPx = begin ?? pos.minScrollExtent;
          double maxPx = end ?? pos.maxScrollExtent;
          return (pos.pixels - minPx) / (maxPx - minPx);
        });

  final double? begin;
  final double? end;
}
