import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../tester_extensions.dart';

void main() {
  testWidgets('ScaleEffect: core', (tester) async {
    final animation = const FlutterLogo().animate().scale(
          duration: 1000.ms,
          begin: Offset.zero,
          end: const Offset(0.5, 2),
        );

    // Check halfway,
    await tester.pumpAnimation(animation, initialDelay: 500.ms);
    Matrix4 expectedMatrix = Transform.scale(scaleX: .25, scaleY: 1).transform;
    tester.expectWidgetWithBool<Transform>(
        (o) => o.transform == expectedMatrix, true, 'scale @ 500ms');
  });
}
