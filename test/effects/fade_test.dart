import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../tester_extensions.dart';

void main() {
  testWidgets('basic fade', (tester) async {
    final animation = const FlutterLogo().animate().fade(duration: 1.seconds);
    // check halfway
    await tester.pumpAnimation(animation, initialDelay: 500.ms);
    tester.expectWidgetWithDouble<FadeTransition>((ft) {
      return ft.opacity.value;
    }, .5, 'opacity');
  });
}
