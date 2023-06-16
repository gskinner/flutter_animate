import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../tester_extensions.dart';

void main() {
  testWidgets('ShakeEffect: shake', (tester) async {
    final animation = const FlutterLogo().animate().shake(
          duration: 1000.ms,
          hz: _hz,
          rotation: _rotation,
          offset: const Offset(_translation, _translation),
        );

    // check 1/4 cycle through:
    await tester.pumpAnimation(animation, initialDelay: 250.ms);
    _verifyShake(tester, _translation, _translation, _rotation);
  });

  testWidgets('ShakeEffect: shakeX', (tester) async {
    final animation = const FlutterLogo().animate().shakeX(
          duration: 1000.ms,
          hz: _hz,
          amount: _translation,
        );

    // check 1/4 cycle through:
    await tester.pumpAnimation(animation, initialDelay: 250.ms);
    _verifyShake(tester, _translation, 0, 0);
  });

  testWidgets('ShakeEffect: shakeY', (tester) async {
    final animation = const FlutterLogo().animate().shakeY(
          duration: 1000.ms,
          hz: _hz,
          amount: _translation,
        );

    // check 1/4 cycle through:
    await tester.pumpAnimation(animation, initialDelay: 250.ms);
    _verifyShake(tester, 0, _translation, 0);
  });
}

_verifyShake(WidgetTester tester, double x, double y, double rotation) async {
  // check translation
  Matrix4 matrix;
  if (x != 0 || y != 0) {
    matrix = Transform.translate(offset: Offset(x, y)).transform;
    tester.expectWidgetWithBool<Transform>((o) {
      return o.transform == matrix;
    }, true, 'translation', findFirst: true);
  }

  // check rotation
  if (rotation != 0) {
    matrix = Transform.rotate(angle: rotation).transform;
    tester.expectWidgetWithBool<Transform>(
        (o) => o.transform == matrix, true, 'rotation');
  }
}

const double _hz = 1;
const double _rotation = pi / 36;
const double _translation = 10;
