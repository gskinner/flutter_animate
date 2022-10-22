import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_test/flutter_test.dart';

import '../tester_extensions.dart';

void main() {
  testWidgets('custom padding tween', (tester) async {
    final animation = const SizedBox().animate().custom(
          duration: 1.seconds,
          end: 40,
          builder: (_, value, child) {
            return Padding(padding: EdgeInsets.all(value), child: child);
          },
        );

    // check halfway
    await tester.pumpAnimation(animation, initialDelay: 500.ms);
    tester.expectWidgetWithDouble<Padding>((ft) {
      return (ft.padding as EdgeInsets).top;
    }, 20, 'padding');

    // check end
    await tester.pump(500.ms);
    tester.expectWidgetWithDouble<Padding>((ft) {
      return (ft.padding as EdgeInsets).top;
    }, 40, 'padding');
  });
}
