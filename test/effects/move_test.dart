import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../tester_extensions.dart';

void main() {
  testWidgets('MoveEffect: move', (tester) async {
    final animation = const FlutterLogo().animate().move(
          duration: 1000.ms,
          end: const Offset(_moveAmt, _moveAmt),
        );

    // check halfway
    await tester.pumpAnimation(animation, initialDelay: 500.ms);
    _verifyMove(tester, _moveAmt / 2,  _moveAmt / 2);
  });

  testWidgets('MoveEffect: moveX', (tester) async {
    final animation = const FlutterLogo().animate().moveX(
          duration: 1000.ms,
          end: _moveAmt,
        );

    // check halfway
    await tester.pumpAnimation(animation, initialDelay: 500.ms);
    _verifyMove(tester, _moveAmt / 2,  0);
  });

  testWidgets('MoveEffect: moveY', (tester) async {
    final animation = const FlutterLogo().animate().moveY(
          duration: 1000.ms,
          end: _moveAmt,
        );

    // check halfway
    await tester.pumpAnimation(animation, initialDelay: 500.ms);
    _verifyMove(tester, 0, _moveAmt / 2);
  });
}

_verifyMove(WidgetTester tester, double x, double y) async {
    tester.expectWidgetWithDouble<Transform>(
        (o) => o.transform.getTranslation().x, x, 'x');
    tester.expectWidgetWithDouble<Transform>(
        (o) => o.transform.getTranslation().y, y, 'y');
}

const double _moveAmt = 100;
