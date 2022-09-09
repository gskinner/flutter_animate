import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '_utils.dart';

void main() {
  testWidgets('test scale', (tester) async {
    final animation = const FlutterLogo().animate().scale(duration: 1000.ms);
    await pumpAnimation(tester, animation, 500.ms);
    // Check halfway,
    expect(
      tester.widget(find.byType(ScaleTransition).last),
      isA<ScaleTransition>().having((ft) => ft.scale.value, 'scale', .5),
    );
  });
}
