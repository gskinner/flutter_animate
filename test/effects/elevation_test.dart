import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../tester_extensions.dart';

void main() {
  testWidgets('ElevationEffect: core', (tester) async {
    double begin = 4, end = 32;

    final animation = const FlutterLogo().animate().elevation(
          duration: 1000.ms,
          begin: begin,
          end: end,
        );

    // Check begin:
    await tester.pumpAnimation(animation);
    tester.expectWidgetWithBool<PhysicalModel>(
        (o) => o.elevation == begin, true, 'elevation @ 0ms');

    // Check end:
    await tester.pump(1000.ms);
    tester.expectWidgetWithBool<PhysicalModel>(
        (o) => o.elevation == end, true, 'elevation @ 1000ms');
  });
}
