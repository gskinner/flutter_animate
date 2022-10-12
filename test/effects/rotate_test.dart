import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../tester_extensions.dart';

void main() {
  testWidgets('basic rotation', (tester) async {
    final animation = const FlutterLogo().animate().rotate(
          duration: 1.seconds,
          end: 2,
        );
    await tester.pumpAnimation(animation, initialDelay: 500.ms);
    // check halfway
    tester.expectWidgetValue<RotationTransition>((w) => w.turns.value, 1, 'turns');
  });
}
