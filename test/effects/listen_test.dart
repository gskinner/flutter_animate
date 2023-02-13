import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../tester_extensions.dart';

void main() {
  testWidgets('ListenEffect: core', (tester) async {
    double value = 0;
    final animation = const FlutterLogo()
        .animate()
        .fadeIn(duration: 1000.ms)
        .listen(callback: (o) => value = o);

    // Check value halfway
    await tester.pumpAnimation(animation, initialDelay: 500.ms);
    expect(value, 0.5);

    // Check at the end
    await tester.pump(500.ms);
    expect(value, 1);
  });
}
