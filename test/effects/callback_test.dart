import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../tester_extensions.dart';

void main() {
  /// Checks that callbacks do get called, and that they get called at the correct time
  testWidgets('increment callback count twice while fading', (tester) async {
    int callbackCount = 0;
    final animation = const FlutterLogo()
        .animate()
        .fadeIn(duration: 1.seconds)
        // Register a callback halfway, that will look for FadeTransition @ .5
        .callback(duration: .5.seconds, callback: (_) => callbackCount++)
        // Register another callback at the end
        .callback(duration: 1.seconds, callback: (_) => callbackCount++);

    // Need to pump twice to let callbacks fire
    await tester.pumpAnimation(animation, initialDelay: 500.ms);
    expect(callbackCount, 1);
    await tester.pump(500.ms);
    expect(callbackCount, 2);
  });
}
