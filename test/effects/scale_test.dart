import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../tester_extensions.dart';

void main() {
  testWidgets('ScaleEffect: scale', (tester) async {
    final animation = const FlutterLogo().animate().scale(
          duration: 1000.ms,
          end: const Offset(0.5, 2),
        );

    // Check halfway,
    await tester.pumpAnimation(animation, initialDelay: 500.ms);
    _verifyScale(tester, 0.75, 1.5);
  });

  testWidgets('ScaleEffect: scaleXY', (tester) async {
    final animation =
        const FlutterLogo().animate().scaleXY(duration: 1000.ms, end: 2);

    // Check halfway,
    await tester.pumpAnimation(animation, initialDelay: 500.ms);
    _verifyScale(tester, 1.5, 1.5);
  });

  testWidgets('ScaleEffect: scaleX', (tester) async {
    final animation =
        const FlutterLogo().animate().scaleX(duration: 1000.ms, end: 2);

    // Check halfway,
    await tester.pumpAnimation(animation, initialDelay: 500.ms);
    _verifyScale(tester, 1.5, 1);
  });

  testWidgets('ScaleEffect: scaleY', (tester) async {
    final animation =
        const FlutterLogo().animate().scaleY(duration: 1000.ms, end: 2);

    // Check halfway,
    await tester.pumpAnimation(animation, initialDelay: 500.ms);
    _verifyScale(tester, 1, 1.5);
  });
}

_verifyScale(WidgetTester tester, double x, double y) async {
  Matrix4 expectedMatrix = Transform.scale(scaleX: x, scaleY: y).transform;
  tester.expectWidgetWithBool<Transform>(
      (o) => o.transform == expectedMatrix, true, 'scale');
}
