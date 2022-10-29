import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../tester_extensions.dart';

void main() {
  testWidgets('slide variations', (tester) async {
    final slideInUp = const FlutterLogo().animate().slideInUp(duration: 1.seconds, beginY: -1);
    await tester.pumpAnimation(slideInUp, initialDelay: 750.ms);
    tester.expectWidgetWithDouble<SlideTransition>((ft) => ft.position.value.dy, -.25, 'slide');

    final slideOutUp = const FlutterLogo().animate(key: const ValueKey(1)).slideOutUp(duration: 1.seconds, endY: 1);
    await tester.pumpAnimation(slideOutUp, initialDelay: 750.ms);
    tester.expectWidgetWithDouble<SlideTransition>((ft) => ft.position.value.dy, .75, 'slide');
  });
}
