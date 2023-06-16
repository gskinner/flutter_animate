import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../tester_extensions.dart';

void main() {
  testWidgets('BlurEffect: blur', (tester) async {
    final animation = const FlutterLogo().animate().blur(
          begin: Offset.zero,
          end: const Offset(_blurAmt, _blurAmt),
          duration: 1000.ms,
        );

    // Check halfway:
    await tester.pumpAnimation(animation, initialDelay: 500.ms);
    _verifyBlur(tester, _blurAmt / 2, _blurAmt / 2);
  });

  testWidgets('BlurEffect: blurXY', (tester) async {
    final animation = const FlutterLogo().animate().blurXY(
          end: _blurAmt,
          duration: 1000.ms,
        );

    // Check halfway:
    await tester.pumpAnimation(animation, initialDelay: 500.ms);
    _verifyBlur(tester, _blurAmt / 2, _blurAmt / 2);
  });

  testWidgets('BlurEffect: blurX', (tester) async {
    final animation = const FlutterLogo().animate().blurX(
          end: _blurAmt,
          duration: 1000.ms,
        );

    // Check halfway:
    await tester.pumpAnimation(animation, initialDelay: 500.ms);
    _verifyBlur(tester, _blurAmt / 2, 0);
  });

  testWidgets('BlurEffect: blurY', (tester) async {
    final animation = const FlutterLogo().animate().blurY(
          end: _blurAmt,
          duration: 1000.ms,
        );

    // Check halfway:
    await tester.pumpAnimation(animation, initialDelay: 500.ms);
    _verifyBlur(tester, 0, _blurAmt / 2);
  });
}

_verifyBlur(WidgetTester tester, double x, double y) async {
  expect(
    tester.widget(find.byType(ImageFiltered).last),
    isA<ImageFiltered>().having(
        (o) => (o.imageFilter as dynamic).sigmaX, 'sigmaX', x),
  );
  expect(
    tester.widget(find.byType(ImageFiltered).last),
    isA<ImageFiltered>().having(
        (o) => (o.imageFilter as dynamic).sigmaY, 'sigmaY', y),
  );
}

const double _blurAmt = 10;
