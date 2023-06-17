import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'tester_extensions.dart';

void main() {
  testWidgets('AnimateList: core', (tester) async {
    var items = const <Widget>[Spacer(), FlutterLogo(), FlutterLogo()];
    items = items.animate(
      effects: [FadeEffect(duration: 1000.ms)],
      interval: AnimateList.defaultInterval,
    );

    var widget = Column(children: items);
    await tester.pumpAnimation(widget, initialDelay: 500.ms);

    // this should find two Animate instances, because Spacer is in AnimateList.ignoreTypes:
    expect(
      find.byType(Animate),
      findsNWidgets(2),
      reason: 'correct item count',
    );

    // verify that the animations are running:
    tester.expectWidgetWithDouble<FadeTransition>(
        (o) => o.opacity.value, 0.5, 'opacity');

    // test list functions:
    expect(items[0], isA<Spacer>(), reason: 'get item');
    expect(items.length, 3, reason: 'get length');
    items.length = 2;
    expect(items.length, 2, reason: 'set length');
  });
}
