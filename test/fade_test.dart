import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '_utils.dart';

void main() {
  testWidgets('test fade', (tester) async {
    final animation = const FlutterLogo().animate().fade(duration: 1000.ms);
    await pumpAnimation(tester, animation, 500.ms);
    // check halfway
    expect(
      tester.widget(find.byType(FadeTransition).last),
      isA<FadeTransition>().having((ft) => ft.opacity.value, 'opacity', .5),
    );
  });
}
