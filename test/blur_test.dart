import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '_utils.dart';

void main() {
  testWidgets('test blur', (tester) async {
    const double blurAmt = 10;
    final animation = const FlutterLogo().animate().blur(begin: 0, end: blurAmt, duration: 1000.ms);
    await pumpAnimation(tester, animation, 500.ms);
    // Check halfway,
    expect(
      tester.widget(find.byType(ImageFiltered).last),
      isA<ImageFiltered>().having((ft) => (ft.imageFilter as dynamic).sigmaX, 'sigmaX', blurAmt / 2),
    );
    expect(
      tester.widget(find.byType(ImageFiltered).last),
      isA<ImageFiltered>().having((ft) => (ft.imageFilter as dynamic).sigmaY, 'sigmaY', blurAmt / 2),
    );
  });
}
