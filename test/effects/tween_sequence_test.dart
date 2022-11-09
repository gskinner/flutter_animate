import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../tester_extensions.dart';

void main() {
  testWidgets('fade in, out, in ', (tester) async {
    final animation = const FlutterLogo().animate().tweenSequence(
          duration: 1.5.seconds,
          sequence: TweenSequence<double>([
            TweenSequenceItem(tween: Tween(begin: 0, end: 1), weight: .5),
            TweenSequenceItem(tween: Tween(begin: 1, end: 0), weight: .5),
            TweenSequenceItem(tween: Tween(begin: 0, end: 1), weight: .5),
          ]),
          builder: (_, double value, Widget child) {
            return Opacity(opacity: value, child: child);
          },
        );
    // check start
    await tester.pumpAnimation(animation);
    tester.expectWidgetWithDouble<Opacity>((ft) => ft.opacity, 0, 'opacity');
    // check 1/3
    await tester.pump(500.ms);
    tester.expectWidgetWithDouble<Opacity>((ft) => ft.opacity, 1, 'opacity');
    // check 2/3
    await tester.pump(500.ms);
    tester.expectWidgetWithDouble<Opacity>((ft) => ft.opacity, 0, 'opacity');
    // check end
    await tester.pump(500.ms);
    tester.expectWidgetWithDouble<Opacity>((ft) => ft.opacity, 1, 'opacity');
  });
}
