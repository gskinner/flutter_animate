import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '_utils.dart';

void main() {
  /// Checks that callbacks do get called, and that they get called at the correct time
  testWidgets('test callback', (tester) async {
    int callbackCount = 0;
    final animation = const FlutterLogo()
        .animate()
        .fadeIn(duration: 1.seconds)
        // Register a callback halfway, that will look for FadeTransition @ .5
        .callback(
            duration: .5.seconds,
            callback: (_) {
              callbackCount++;
              // Make sure tween is where we would expect it
              expect(
                tester.widget(find.byType(FadeTransition).last),
                isA<FadeTransition>().having((ft) => ft.opacity.value, 'opacity', .5),
              );
            })
        // Register another callback at the end
        .callback(duration: 1.seconds, callback: (_) => callbackCount++);

    await pumpAnimation(tester, animation, .5.seconds);
    // Need to pump twice to let both callbacks fire
    await tester.pump(.5.seconds);

    // Expect correct callbackCount value
    expect(callbackCount, 2);
  });
}
