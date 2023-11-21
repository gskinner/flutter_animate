import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../tester_extensions.dart';

void main() {
  testWidgets('AlignEffect: align', (tester) async {
    final animation = const FlutterLogo().animate().align(
          duration: 1000.ms,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );

    // check halfway
    await tester.pumpAnimation(animation, initialDelay: 500.ms);
    tester.expectWidgetWithDouble<Align>(
        (o) => (o.alignment as Alignment).x, 0.0, 'x');
    tester.expectWidgetWithDouble<Align>(
        (o) => (o.alignment as Alignment).y, 0.0, 'y');
  });
}

_verifyMove(WidgetTester tester, double x, double y) async {
  tester.expectWidgetWithDouble<Transform>(
      (o) => o.transform.getTranslation().x, x, 'x');
  tester.expectWidgetWithDouble<Transform>(
      (o) => o.transform.getTranslation().y, y, 'y');
}

const double _moveAmt = 100;
