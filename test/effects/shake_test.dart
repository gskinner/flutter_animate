import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../tester_extensions.dart';

void main() {
  // SB: Not sure how much sense it makes to test these more specific "stylized" tween variations.
  // Seems like they quickly become harder to test than the core ones, and will break more frequently as small style tweaks are made.
  // This is not an exhaustive test, it only tests a single position in the effect.
  testWidgets('ShakeEffect: core', (tester) async {
    final animation = const FlutterLogo().animate().shake(
          duration: 1000.ms,
          hz: 2,
          rotation: pi / 36,
          offset: const Offset(10, 10),
        );

    // check 1/8 of the way
    await tester.pumpAnimation(animation, initialDelay: (1 / 8).seconds);
    // check translation
    var matrix = Transform.translate(offset: const Offset(10, 10)).transform;
    tester.expectWidgetWithBool<Transform>(
        (o) => o.transform == matrix, true, 'translation @ 1/8s',
        findFirst: true);

    // check rotation
    matrix = Transform.rotate(angle: pi / 36).transform;
    tester.expectWidgetWithBool<Transform>(
        (o) => o.transform == matrix, true, 'rotation @ 1/8s');
  });
}
