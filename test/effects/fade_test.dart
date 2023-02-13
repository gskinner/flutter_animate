import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../tester_extensions.dart';

void main() {
  testWidgets('FadeEffect: core', (tester) async {
    final animation = const FlutterLogo().animate().fade(duration: 1000.ms);

    // check halfway
    await tester.pumpAnimation(animation, initialDelay: 500.ms);
    tester.expectWidgetWithDouble<FadeTransition>(
      (o) => o.opacity.value,
      0.5,
      'opacity @ 500ms',
    );
  });
}
