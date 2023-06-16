import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../tester_extensions.dart';

void main() {
  testWidgets('ThenEffect: core', (tester) async {
    final animation =
        const FlutterLogo().animate().fadeIn(duration: 500.ms).then().scale();

    // Wait 500ms, check that opacity has started, but scale has not
    await tester.pumpAnimation(animation, initialDelay: 250.ms);
    tester.expectWidgetWithDouble<FadeTransition>(
        (o) => o.opacity.value, 0.5, 'opacity @ 25%');

    Matrix4 expectedMatrix = Transform.scale(scale: 0).transform;
    tester.expectWidgetWithBool<Transform>(
        (o) => o.transform == expectedMatrix, true, 'scale @ 25%');

    // Wait another 1s and check that scale is now halfway
    await tester.pumpAnimation(animation, initialDelay: 500.ms);
    expectedMatrix = Transform.scale(scale: 0.5).transform;
    tester.expectWidgetWithBool<Transform>(
        (o) => o.transform == expectedMatrix, true, 'scale @ 75%');
  });
}
