import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../tester_extensions.dart';

void main() {
  testWidgets('fade `then` scale', (tester) async {
    final animation = const FlutterLogo().animate().fadeIn(duration: 1.seconds).then().scale();
    // Wait 500ms, check that opacity has started, but scale has not
    await tester.pumpAnimation(animation, initialDelay: 500.ms);
    tester.expectWidgetWithDouble<FadeTransition>((w) => w.opacity.value, .5, 'opacity');
    tester.expectWidgetWithDouble<ScaleTransition>((w) => w.scale.value, 0, 'scale');

    // Wait another 1s and check that scale is now halfway
    await tester.pumpAnimation(animation, initialDelay: 1.seconds);
    tester.expectWidgetWithDouble<ScaleTransition>((w) => w.scale.value, .5, 'scale');
  });
}
