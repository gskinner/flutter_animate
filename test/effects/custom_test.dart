import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_test/flutter_test.dart';

import '../tester_extensions.dart';

void main() {
  testWidgets('CustomEffect: core', (tester) async {
    final animation = const SizedBox().animate().custom(
          duration: 1000.ms,
          end: 40,
          builder: (_, value, child) =>
              Padding(padding: EdgeInsets.all(value), child: child),
        );

    // check halfway
    await tester.pumpAnimation(animation, initialDelay: 500.ms);
    tester.expectWidgetWithDouble<Padding>(
        (o) => (o.padding as EdgeInsets).top, 20, 'padding @ 500ms');

    // check end
    await tester.pump(500.ms);
    tester.expectWidgetWithDouble<Padding>(
        (o) => (o.padding as EdgeInsets).top, 40, 'padding @ 1000ms');
  });
}
