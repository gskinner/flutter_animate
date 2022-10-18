import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../tester_extensions.dart';

void main() {
  testWidgets('basic move', (tester) async {
    final animation = const FlutterLogo().animate().move(
          duration: 1.seconds,
          begin: Offset.zero,
          end: const Offset(100, 50),
        );
    // check halfway
    await tester.pumpAnimation(animation, initialDelay: 500.ms);
    tester.expectWidgetWithDouble<Transform>((w) => w.transform.getTranslation().x, 50, 'x translation');
    tester.expectWidgetWithDouble<Transform>((w) => w.transform.getTranslation().y, 25, 'y translation');
  });
}
