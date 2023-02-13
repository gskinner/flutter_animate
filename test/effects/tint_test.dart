import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../tester_extensions.dart';

void main() {
  testWidgets('TintEffect: core', (tester) async {
    Color color = Colors.blue;
    final animation = const FlutterLogo().animate().tint(
          duration: 1000.ms,
          color: color,
          begin: 0,
          end: 1,
        );

    // Check halfway
    await tester.pumpAnimation(animation, initialDelay: 500.ms);
    // create a colorFilter to compare to the one in the widget tree
    var expectedFilter =
        ColorFilter.matrix(TintEffect.getTintMatrix(0.5, color));
    tester.expectWidgetWithBool<ColorFiltered>(
        (o) => o.colorFilter == expectedFilter, true, 'colorFilter @ 500ms');
  });
}
