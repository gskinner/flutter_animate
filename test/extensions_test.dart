import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_animate/flutter_animate.dart';

void main() {
  test('NumDurationExtensions', () async {
    expect(100.microseconds, const Duration(microseconds: 100));
    expect(100.milliseconds, const Duration(milliseconds: 100));
    expect(100.seconds, const Duration(seconds: 100));
    expect(100.minutes, const Duration(minutes: 100));
    expect(100.hours, const Duration(hours: 100));
    expect(100.days, const Duration(days: 100));
  });

  test('OffsetCopyWithExtensions', () async {
    var offset = const Offset(10, 0);
    expect(offset.copyWith(dx: 100, dy: 100), const Offset(100, 100));
  });
}
