import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../tester_extensions.dart';

void main() {
  testWidgets('BlurEffect: blur', (tester) async {
    final Path path = Path() //
      ..lineTo(100, 100);

    final animation = const FlutterLogo().animate().followPath(
          path: path,
          duration: 1000.ms,
        );

    // Check halfway:
    await tester.pumpAnimation(animation, initialDelay: 500.ms);
    var mtx = FollowPathEffect.getMatrix(50, 50, pi / 4);
    tester.expectWidgetWithBool<Transform>(
        (o) => o.transform == mtx, true, 'transform');
  });
}
