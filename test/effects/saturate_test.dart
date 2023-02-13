import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../tester_extensions.dart';

void main() {
  testWidgets('SaturateEffect: core', (tester) async {
    final animation = const FlutterLogo().animate().saturate(
          duration: 1000.ms,
          begin: 0,
          end: 1,
        );

    // Check halfway,
    await tester.pumpAnimation(animation, initialDelay: 500.ms);
    // Create a colorFilter and compare to the one in the widget tree, they should equal
    ColorFilter filter = ColorFilter.matrix(SaturateEffect.getColorMatrix(0.5));
    tester.expectWidgetWithBool<ColorFiltered>(
        (o) => o.colorFilter == filter, true, 'colorFilter @ 500ms');
  });
}
