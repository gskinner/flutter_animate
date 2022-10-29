import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../tester_extensions.dart';

void main() {
  testWidgets('fade variations', (tester) async {
    final fadeIn = const FlutterLogo().animate().fadeIn(duration: 1.seconds);
    await tester.pumpAnimation(fadeIn, initialDelay: 750.ms);
    tester.expectWidgetWithDouble<FadeTransition>((ft) => ft.opacity.value, .75, 'opacity');

    final fadeInUp = const FlutterLogo().animate(key: const ValueKey(1)).fadeInUp(duration: 1.seconds, beginY: -1);
    await tester.pumpAnimation(fadeInUp, initialDelay: 750.ms);
    tester.expectWidgetWithDouble<FadeTransition>((ft) => ft.opacity.value, .75, 'opacity');
    tester.expectWidgetWithDouble<SlideTransition>((ft) => ft.position.value.dy, -.25, 'slide');

    final fadeOut = const FlutterLogo().animate(key: const ValueKey(2)).fadeOut(duration: 1.seconds);
    await tester.pumpAnimation(fadeOut, initialDelay: 750.ms);
    tester.expectWidgetWithDouble<FadeTransition>((ft) => ft.opacity.value, .25, 'opacity');

    final fadeOutUp = const FlutterLogo().animate(key: const ValueKey(3)).fadeOutUp(duration: 1.seconds, endY: 1);
    await tester.pumpAnimation(fadeOutUp, initialDelay: 750.ms);
    tester.expectWidgetWithDouble<FadeTransition>((ft) => ft.opacity.value, .25, 'opacity');
    tester.expectWidgetWithDouble<SlideTransition>((ft) => ft.position.value.dy, .75, 'slide');
  });
}
