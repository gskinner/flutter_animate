import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../tester_extensions.dart';

void main() {
  testWidgets('basic tint', (tester) async {
    final animation = const FlutterLogo().animate().tint(
          duration: 1.seconds,
          color: Colors.blue,
          begin: 0,
          end: 1,
        );
    // Check halfway
    await tester.pumpAnimation(animation, initialDelay: 500.ms);
    // create a colorFilter and compare to the one in the widget tree, they should equal
    var filter = ColorFilter.matrix(TintEffect.getTintMatrix(.5, Colors.blue));
    tester.expectWidgetWithBool<ColorFiltered>(
      (ft) => ft.colorFilter == filter,
      true,
      'color filter matrix',
    );
  });
}
