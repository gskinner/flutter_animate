import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_test/flutter_test.dart';

import '../tester_extensions.dart';

void main() {
  testWidgets('VisibilityEffect: maintain = true', (tester) async {
    final animation = const FlutterLogo()
        .animate()
        .visibility(duration: 1000.ms, end: true, maintain: true);

    // check halfway
    await tester.pumpAnimation(animation, initialDelay: 500.ms);
    tester.expectWidgetWithBool<Visibility>(
        (o) => o.visible, false, 'visibility @ 50%');

    // check end
    await tester.pump(500.ms);
    _verifyVisibility(tester, true, true);
  });

  testWidgets('VisibilityEffect: maintain = false', (tester) async {
    final animation = const FlutterLogo()
        .animate()
        .visibility(duration: 1.seconds, maintain: false);

    await tester.pumpAnimation(animation);
    _verifyVisibility(tester, false, false);
  });

  testWidgets('VisibilityEffect: hide', (tester) async {
    final animation = const FlutterLogo().animate().hide(duration: 1000.ms);

    // check halfway
    await tester.pumpAnimation(animation, initialDelay: 1000.ms);
    _verifyVisibility(tester, false);
  });

  testWidgets('VisibilityEffect: show', (tester) async {
    final animation = const FlutterLogo().animate().show(duration: 1000.ms);

    // check halfway
    await tester.pumpAnimation(animation, initialDelay: 1000.ms);
    _verifyVisibility(tester, true);
  });
}

_verifyVisibility(WidgetTester tester, bool visible,
    [bool maintain = VisibilityEffect.defaultMaintain]) async {
  tester.expectWidgetWithBool<Visibility>((o) => o.visible, visible, 'visible');
  tester.expectWidgetWithBool<Visibility>(
      (o) => o.maintainAnimation, maintain, 'maintainSize');
  tester.expectWidgetWithBool<Visibility>(
      (o) => o.maintainInteractivity, maintain, 'maintainInteractivity');
  tester.expectWidgetWithBool<Visibility>(
      (o) => o.maintainSemantics, maintain, 'maintainSemantics');
  tester.expectWidgetWithBool<Visibility>(
      (o) => o.maintainSize, maintain, 'maintainSize');
  tester.expectWidgetWithBool<Visibility>(
      (o) => o.maintainState, maintain, 'maintainState');
}
