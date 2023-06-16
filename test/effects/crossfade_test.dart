import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../tester_extensions.dart';

void main() {
  testWidgets('CrossfadeEffect: core', (tester) async {
    Widget beginChild = const FlutterLogo(), endChild = const Placeholder();
    final anim = beginChild.animate().crossfade(
          duration: 1000.ms,
          delay: 0.ms,
          builder: (_) => endChild,
        );

    // At begin, expect beginChild is 100% opaque, endChild is 0%
    await tester.pumpAnimation(anim);
    tester.expectWidgetWithDouble<FadeTransition>(
      (o) => o.opacity.value,
      1,
      'beginChild opacity @ 0%',
      findFirst: true,
    );
    tester.expectWidgetWithDouble<FadeTransition>(
      (o) => o.opacity.value,
      0,
      'endChild opacity @ 0%',
      findFirst: false,
    );

    // At middle, expect beginChild is 50% opaque, endChild is 50%
    await tester.pump(500.ms);
    tester.expectWidgetWithDouble<FadeTransition>(
      (o) => o.opacity.value,
      0.5,
      'beginChild opacity @ 50%',
      findFirst: true,
    );
    tester.expectWidgetWithDouble<FadeTransition>(
      (o) => o.opacity.value,
      0.5,
      'endChild opacity @ 50%',
      findFirst: false,
    );

    // At end, expect beginChild is 0% opaque, endChild is 100%
    await tester.pump(500.ms);
    tester.expectWidgetWithDouble<FadeTransition>(
      (o) => o.opacity.value,
      0,
      'beginChild opacity @ 100%',
      findFirst: true,
    );
    tester.expectWidgetWithDouble<FadeTransition>(
      (o) => o.opacity.value,
      1,
      'endChild opacity @ 100%',
      findFirst: false,
    );
  });
}
