/// Adds extensions to num (ie. int & double) to make creating durations simple:
///
/// ```
/// 200.ms // equivalent to Duration(milliseconds: 200)
/// 3.seconds // equivalent to Duration(milliseconds: 3000)
/// 1.5.days // equivalent to Duration(hours: 36)
/// ```
extension NumDurationExtensions on num {
  Duration get microseconds => Duration(microseconds: round());
  Duration get milliseconds => Duration(microseconds: (this * 1000).round());
  Duration get seconds => Duration(microseconds: (this * 1000 * 1000).round());
  Duration get minutes =>
      Duration(microseconds: (this * 1000 * 1000 * 60).round());
  Duration get hours =>
      Duration(microseconds: (this * 1000 * 1000 * 60 * 60).round());
  Duration get days =>
      Duration(microseconds: (this * 1000 * 1000 * 60 * 60 * 24).round());
  Duration get ms => milliseconds;
}
