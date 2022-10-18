import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../tester_extensions.dart';

void main() {
  testWidgets('toggle an opacity widget from 0 to 1', (tester) async {
    final animation = Animate().toggle(
        duration: 1.seconds,
        builder: (_, value, __) {
          return Opacity(opacity: value ? 0 : 1, child: const FlutterLogo());
        });
    // After 500ms opacity should still be 0
    await tester.pumpAnimation(animation, initialDelay: 500.ms);
    tester.expectWidgetWithDouble<Opacity>((w) => w.opacity, 0, 'opacity');
    // After another 500ms opacity should be 1
    await tester.pumpAnimation(animation, initialDelay: 500.ms);
    tester.expectWidgetWithDouble<Opacity>((w) => w.opacity, 1, 'opacity');
  });
}
