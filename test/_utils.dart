import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> pumpAnimation(WidgetTester tester, Widget child, Duration initialDelay) async {
  await tester.pumpWidget(child);
  await tester.pump(0.ms);
  await tester.pump(initialDelay);
}
