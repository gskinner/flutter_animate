import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../tester_extensions.dart';

void main() {
  testWidgets('basic scale', (tester) async {
    final animation = const FlutterLogo().animate().scale(duration: 1.seconds);
    // Check halfway,
    await tester.pumpAnimation(animation, initialDelay: 500.ms);
    tester.expectWidgetWithDouble<ScaleTransition>((w) => w.scale.value, .5, 'scale');
  });
}
