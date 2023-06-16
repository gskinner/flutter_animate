import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../tester_extensions.dart';

void main() {
  testWidgets('SaturateEffect: saturate', (tester) async {
    final animation = const FlutterLogo().animate().saturate(duration: 1000.ms);

    // Check 75% through:
    await tester.pumpAnimation(animation, initialDelay: 750.ms);
    _verifySaturate(tester, 0.75);
  });

  testWidgets('SaturateEffect: desaturate', (tester) async {
    final animation =
        const FlutterLogo().animate().desaturate(duration: 1000.ms);

    // Check 75% through:
    await tester.pumpAnimation(animation, initialDelay: 750.ms);
    _verifySaturate(tester, 0.25);
  });
}

_verifySaturate(WidgetTester tester, double amt) async {
  // Create a colorFilter and compare to the one in the widget tree, they should equal
  ColorFilter filter = ColorFilter.matrix(SaturateEffect.getColorMatrix(amt));
  tester.expectWidgetWithBool<ColorFiltered>(
      (o) => o.colorFilter == filter, true, 'colorFilter');
}
