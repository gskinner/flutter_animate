import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../tester_extensions.dart';

void main() {
  testWidgets('swap Logo for a ColoredBox', (tester) async {
    final anim = const FlutterLogo().animate().fadeOut(duration: 500.ms).swap(
          // inherits duration from fadeOut
          builder: (_, __) => const ColoredBox(color: Colors.red).animate().fadeIn(),
        );
    await tester.pumpAnimation(anim);
    expect(find.byType(FlutterLogo), findsOneWidget);
    await tester.pump(500.ms);
    await tester.pump(0.ms); // clear out the callback
    expect(find.byType(ColoredBox), findsOneWidget);
  });

  testWidgets('Fade a logo out and back in using swap()', (tester) async {
    final anim = const FlutterLogo().animate().fadeOut(duration: 500.ms).swap(
          builder: (_, originalChild) => originalChild!.animate().fadeIn(),
        );
    await tester.pumpAnimation(anim);
    tester.expectWidgetValue<FadeTransition>((w) => w.opacity.value, 1, 'opacity');
    await tester.pump(500.ms);
    await tester.pump(0.ms);
    tester.expectWidgetValue<FadeTransition>((w) => w.opacity.value, 0, 'opacity');
    await tester.pump(500.ms);
    await tester.pump(0.ms);
    tester.expectWidgetValue<FadeTransition>((w) => w.opacity.value, 1, 'opacity');
  });
}
