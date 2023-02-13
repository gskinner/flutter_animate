import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../tester_extensions.dart';

void main() {
  /// Checks that callbacks do get called, and that they get called at the correct time
  testWidgets('CallbackEffect: callback twice while fading', (tester) async {
    int callbackCount = 0;
    final animation = const FlutterLogo()
        .animate()
        .fadeIn(duration: 1000.ms)
        // Register a callback halfway,
        .callback(duration: 500.ms, callback: (_) => callbackCount++)
        // Register another callback at the end
        .callback(duration: 1000.ms, callback: (_) => callbackCount++);

    await tester.pumpAnimation(animation, initialDelay: 500.ms);
    expect(callbackCount, 1);
    await tester.pump(500.ms);
    expect(callbackCount, 2);
  });
}
