import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../tester_extensions.dart';

void main() {
  testWidgets('BoxShadowEffect: core', (tester) async {
    BoxShadow? begin;
    BoxShadow end = const BoxShadow(blurRadius: 32, color: Colors.red);
    BorderRadius borderRadius = BorderRadius.circular(8);

    // uses a Placeholder instead of FlutterLogo because the latter apparently has its own DecoratedBox
    final animation = const Placeholder().animate().boxShadow(
          duration: 1000.ms,
          borderRadius: borderRadius,
          begin: begin,
          end: end,
        );

    // Check middle:
    await tester.pumpAnimation(animation, initialDelay: 500.ms);
    var expected = BoxShadow.lerp(begin, end, 0.5);
    tester.expectWidgetWithBool<DecoratedBox>(
      (o) => (o.decoration as BoxDecoration).boxShadow?.first == expected,
      true,
      'decoration.boxShadow @ 500ms',
    );
    tester.expectWidgetWithBool<DecoratedBox>(
      (o) => (o.decoration as BoxDecoration).borderRadius == borderRadius,
      true,
      'decoration.borderRadius @ 500ms',
    );
  });
}
