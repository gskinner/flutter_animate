import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../tester_extensions.dart';

void main() {
  testWidgets('update value as animation plays', (tester) async {
    double value = 0;
    final animation = const FlutterLogo().animate().fadeIn(duration: 1.seconds).listen(callback: (c) {
      value = c;
    });
    // Check value halfway
    await tester.pumpAnimation(animation, initialDelay: 500.ms);
    expect(value, .5);
    // Check at the end
    await tester.pump(500.ms);
    expect(value, 1);
  });
}
