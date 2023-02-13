import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../tester_extensions.dart';

void main() {
  testWidgets('SlideEffect: core', (tester) async {
    final animation = const FlutterLogo().animate().slide(
          duration: 1000.ms,
          begin: Offset.zero,
          end: const Offset(1, 2),
        );

    // check halfway
    await tester.pumpAnimation(animation, initialDelay: 500.ms);
    tester.expectWidgetWithDouble<SlideTransition>(
        (o) => o.position.value.dx, 0.5, 'slideX @ 500ms');
    tester.expectWidgetWithDouble<SlideTransition>(
        (o) => o.position.value.dy, 1, 'slideY @ 500ms');
  });
}
