import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_test/flutter_test.dart';

extension TesterExtensions on WidgetTester {
  /// For some reason, these animations need an extra `pump(0.ms);` to properly start.
  /// This eases that boilerplate a bit. Also adds a convenience method for an initial wait time, which is common.
  Future<void> pumpAnimation(Widget child, {Duration? initialDelay}) async {
    await pumpWidget(child);
    await pump(0.ms);
    if (initialDelay != null) {
      await pump(initialDelay);
    }
  }

  /// Wraps the built-in `expect(..., ...)` call to make tests more succinct
  expectWidgetWithDouble<T>(
    double Function(T w) getValue,
    double expectedValue,
    String debugTitle, {
    bool findFirst = false,
  }) {
    expect(
      widget(findFirst ? find.byType(T).first : find.byType(T).last),
      isA<T>().having((t) => getValue(t), debugTitle, expectedValue),
    );
  }

  /// Wraps the built-in `expect(..., ...)` call to make tests more succinct
  expectWidgetWithBool<T>(
    bool Function(T w) getValue,
    bool expectedValue,
    String debugTitle, {
    bool findFirst = false,
  }) {
    expect(
      widget(findFirst ? find.byType(T).first : find.byType(T).last),
      isA<T>().having((t) => getValue(t), debugTitle, expectedValue),
    );
  }
}
