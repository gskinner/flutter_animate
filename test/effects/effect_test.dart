import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../tester_extensions.dart';

void main() {
  testWidgets('Effect: inherit duration', (tester) async {
    final animation =
        const FlutterLogo().animate().effect(duration: 1000.ms).moveX(end: 100);

    // check halfway
    await tester.pumpAnimation(animation, initialDelay: 500.ms);
    tester.expectWidgetWithDouble<Transform>(
        (o) => o.transform.getTranslation().x, 50, 'x @ 50%');
  });
}
