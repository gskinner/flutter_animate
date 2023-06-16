import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../tester_extensions.dart';

void main() {
  testWidgets('FlipEffect: flip', (tester) async {
    Axis direction = Axis.vertical;
    final animation = const FlutterLogo().animate().flip(
          duration: 1000.ms,
          direction: direction,
          perspective: _perspective,
          begin: 0,
          end: 1,
        );

    // Check halfway,
    await tester.pumpAnimation(animation, initialDelay: 500.ms);
    _verifyPerspective(tester, direction);
  });

  testWidgets('FlipEffect: flipH', (tester) async {
    final animation = const FlutterLogo().animate().flipH(
          duration: 1000.ms,
          perspective: _perspective,
          begin: 0,
          end: 1,
        );

    // Check halfway,
    await tester.pumpAnimation(animation, initialDelay: 500.ms);
    _verifyPerspective(tester, Axis.horizontal);
  });

  testWidgets('FlipEffect: flipV', (tester) async {
    final animation = const FlutterLogo().animate().flipV(
          duration: 1000.ms,
          perspective: _perspective,
          begin: 0,
          end: 1,
        );

    // Check halfway,
    await tester.pumpAnimation(animation, initialDelay: 500.ms);
    _verifyPerspective(tester, Axis.vertical);
  });
}

_verifyPerspective(WidgetTester tester, Axis direction) async {
  var mtx = FlipEffect.getTransformMatrix(0.5, direction, _perspective);
  tester.expectWidgetWithBool<Transform>(
      (o) => o.transform == mtx, true, 'transform');
}

const double _perspective = 2;
