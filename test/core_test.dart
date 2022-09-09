import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '_utils.dart';

void main() {
  testWidgets('curved tween', (tester) async {
    const curve = Curves.easeOut;
    final animation = const FlutterLogo().animate().fade(duration: 1000.ms, curve: curve);
    await pumpAnimation(tester, animation, 500.ms);
    // check halfway
    expect(
      tester.widget(find.byType(FadeTransition).last),
      isA<FadeTransition>().having((ft) => ft.opacity.value, 'opacity', curve.transform(.5)),
    );
    // check end
    await tester.pump(500.ms);
    expect(
      tester.widget(find.byType(FadeTransition).last),
      isA<FadeTransition>().having((ft) => ft.opacity.value, 'opacity', curve.transform(1)),
    );
  });

  testWidgets('linear tween', (tester) async {
    final animation = const FlutterLogo().animate().fade(duration: 1000.ms);
    await pumpAnimation(tester, animation, 500.ms);
    // check halfway
    expect(
      tester.widget(find.byType(FadeTransition).last),
      isA<FadeTransition>().having((ft) => ft.opacity.value, 'opacity', .5),
    );
    // check end
    await tester.pump(500.ms);
    expect(
      tester.widget(find.byType(FadeTransition).last),
      isA<FadeTransition>().having((ft) => ft.opacity.value, 'opacity', 1),
    );
  });
}
