import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../tester_extensions.dart';

void main() {
  testWidgets('basic scale', (tester) async {
    final animation = const FlutterLogo().animate().scale(
          duration: 1.seconds,
          begin: Offset.zero,
          end: const Offset(.5, 2),
        );
    // Check halfway,
    await tester.pumpAnimation(animation, initialDelay: 500.ms);
    tester.expectWidgetWithDouble<Transform>((w) => w.transform.getColumn(0)[0], .25, 'scaleX');
    tester.expectWidgetWithDouble<Transform>((w) => w.transform.getColumn(1)[1], 1, 'scaleY');
  });
}
