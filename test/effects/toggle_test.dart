import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../tester_extensions.dart';

void main() {
  testWidgets('ToggleEffect: core', (tester) async {
    final animation = Animate().toggle(
        duration: 1000.ms,
        builder: (_, value, __) {
          return Opacity(opacity: value ? 0 : 1, child: const FlutterLogo());
        });

    // Should start with opacity of 0
    await tester.pumpWidget(animation);
    tester.expectWidgetWithDouble<Opacity>(
      (w) => w.opacity,
      0,
      'opacity @ 0ms',
    );

    // After 500ms opacity should still be 0
    await tester.pumpAnimation(animation, initialDelay: 500.ms);
    tester.expectWidgetWithDouble<Opacity>(
      (w) => w.opacity,
      0,
      'opacity @ 500ms',
    );

    // After another 500ms opacity should be 1
    await tester.pumpAnimation(animation, initialDelay: 500.ms);
    tester.expectWidgetWithDouble<Opacity>(
      (w) => w.opacity,
      1,
      'opacity @ 1000ms',
    );
  });
}
