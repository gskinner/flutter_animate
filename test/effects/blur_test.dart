import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../tester_extensions.dart';

void main() {
  testWidgets('basic blur', (tester) async {
    const double blurAmt = 10;
    final animation = const FlutterLogo().animate().blur(begin: 0, end: blurAmt, duration: 1.seconds);
    await tester.pumpAnimation(animation, initialDelay: 500.ms);
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
