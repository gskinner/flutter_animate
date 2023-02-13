import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_test/flutter_test.dart';

import '../tester_extensions.dart';

void main() {
  testWidgets('VisibilityEffect: maintain = true', (tester) async {
    final animation = const FlutterLogo()
        .animate()
        .visibility(duration: 1000.ms, maintain: true);

    // check halfway
    await tester.pumpAnimation(animation, initialDelay: 500.ms);
    tester.expectWidgetWithBool<Visibility>(
        (o) => o.visible, false, 'visibility @ 500ms');
    tester.expectWidgetWithBool<Visibility>(
        (o) => o.maintainAnimation, true, 'maintainSize');
    tester.expectWidgetWithBool<Visibility>(
        (o) => o.maintainInteractivity, true, 'maintainInteractivity');
    tester.expectWidgetWithBool<Visibility>(
        (o) => o.maintainSemantics, true, 'maintainSemantics');
    tester.expectWidgetWithBool<Visibility>(
        (o) => o.maintainSize, true, 'maintainSize');
    tester.expectWidgetWithBool<Visibility>(
        (o) => o.maintainState, true, 'maintainState');

    // check end
    await tester.pump(500.ms);
    tester.expectWidgetWithBool<Visibility>(
        (o) => o.visible, true, 'visibility @ 1000ms');
  });

  testWidgets('VisibilityEffect: maintain = false', (tester) async {
    final animation = const FlutterLogo()
        .animate()
        .visibility(duration: 1.seconds, maintain: false);

    await tester.pumpAnimation(animation);
    tester.expectWidgetWithBool<Visibility>(
        (o) => o.maintainSize, false, 'maintainSize');
    tester.expectWidgetWithBool<Visibility>(
        (o) => o.maintainInteractivity, false, 'maintainInteractivity');
    tester.expectWidgetWithBool<Visibility>(
        (o) => o.maintainSemantics, false, 'maintainSemantics');
    tester.expectWidgetWithBool<Visibility>(
        (o) => o.maintainSize, false, 'maintainSize');
    tester.expectWidgetWithBool<Visibility>(
        (o) => o.maintainState, false, 'maintainState');
  });
}
