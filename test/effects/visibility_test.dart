import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_test/flutter_test.dart';

import '../tester_extensions.dart';

void main() {
  testWidgets('visibility test, maintain = true', (tester) async {
    final animation = const FlutterLogo()
        .animate()
        .visibility(duration: 1.seconds, maintain: true);
    // check halfway
    await tester.pumpAnimation(animation, initialDelay: 500.ms);
    tester.expectWidgetWithBool<Visibility>(
        (ft) => ft.visible, false, 'visibility');
    tester.expectWidgetWithBool<Visibility>(
        (ft) => ft.maintainAnimation, true, 'maintainSize');
    tester.expectWidgetWithBool<Visibility>(
        (ft) => ft.maintainInteractivity, true, 'maintainInteractivity');
    tester.expectWidgetWithBool<Visibility>(
        (ft) => ft.maintainSemantics, true, 'maintainSemantics');
    tester.expectWidgetWithBool<Visibility>(
        (ft) => ft.maintainSize, true, 'maintainSize');
    tester.expectWidgetWithBool<Visibility>(
        (ft) => ft.maintainState, true, 'maintainState');

    // check end
    await tester.pump(500.ms);
    tester.expectWidgetWithBool<Visibility>(
        (ft) => ft.visible, true, 'visibility');
  });

  testWidgets('visibility test, maintain = false', (tester) async {
    final animation = const FlutterLogo()
        .animate()
        .visibility(duration: 1.seconds, maintain: false);
    await tester.pumpAnimation(animation);
    tester.expectWidgetWithBool<Visibility>(
        (ft) => ft.maintainSize, false, 'maintainSize');
    tester.expectWidgetWithBool<Visibility>(
        (ft) => ft.maintainInteractivity, false, 'maintainInteractivity');
    tester.expectWidgetWithBool<Visibility>(
        (ft) => ft.maintainSemantics, false, 'maintainSemantics');
    tester.expectWidgetWithBool<Visibility>(
        (ft) => ft.maintainSize, false, 'maintainSize');
    tester.expectWidgetWithBool<Visibility>(
        (ft) => ft.maintainState, false, 'maintainState');
  });
}
