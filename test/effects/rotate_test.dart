import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../tester_extensions.dart';

void main() {
  // TODO: Test alignment

  testWidgets('RotateEffect: core', (tester) async {
    final animation = const FlutterLogo().animate().rotate(
          duration: 1000.ms,
          end: 2,
        );

    // check halfway
    await tester.pumpAnimation(animation, initialDelay: 500.ms);
    tester.expectWidgetWithDouble<RotationTransition>(
        (o) => o.turns.value, 1, 'turns @ 500ms');
  });
}
