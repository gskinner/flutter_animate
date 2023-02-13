import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../tester_extensions.dart';

void main() {
  testWidgets('ColorEffect: core', (tester) async {
    BlendMode blend = BlendMode.colorDodge;
    Color begin = Colors.blue, end = Colors.red;

    final animation = const FlutterLogo().animate().color(
          duration: 1000.ms,
          blendMode: blend,
          begin: begin,
          end: end,
        );

    // Check begin:
    await tester.pumpAnimation(animation);
    tester.expectWidgetWithBool<ColorFiltered>(
      (o) => o.colorFilter == ColorFilter.mode(begin, blend),
      true,
      'colorFilter @ 0ms',
    );

    // Check end:
    await tester.pump(1000.ms);
    tester.expectWidgetWithBool<ColorFiltered>(
      (o) => o.colorFilter == ColorFilter.mode(end, blend),
      true,
      'colorFilter @ 1000ms',
    );
  });
}
