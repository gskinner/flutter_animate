import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../tester_extensions.dart';

void main() {
  testWidgets('FlipEffect: core', (tester) async {
    Axis direction = Axis.vertical;
    double perspective = 2;
    final animation = const FlutterLogo().animate().flip(
          duration: 1000.ms,
          direction: direction,
          perspective: perspective,
          begin: 0,
          end: 1,
        );

    // Check halfway,
    await tester.pumpAnimation(animation, initialDelay: 500.ms);
    // Create a matrix and compare to the one in the widget tree
    var mtx = FlipEffect.getTransformMatrix(0.5, direction, perspective);
    tester.expectWidgetWithBool<Transform>(
        (o) => o.transform == mtx, true, 'transform @ 500ms');
  });
}
