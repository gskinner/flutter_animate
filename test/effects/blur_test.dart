import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../tester_extensions.dart';

void main() {
  testWidgets('basic blur', (tester) async {
    const double blurAmt = 10;
    final animation = const FlutterLogo()
        .animate()
        .blur(begin: Offset.zero, end: const Offset(blurAmt, blurAmt), duration: 1.seconds);
    // Check halfway,
    await tester.pumpAnimation(animation, initialDelay: 500.ms);
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
