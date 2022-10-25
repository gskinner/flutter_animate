/// Adds extensions to num (ie. int & double) to make creating durations simple:
///
/// ```
/// 200.ms // equivalent to Duration(milliseconds: 200)
/// 3.seconds // equivalent to Duration(milliseconds: 3000)
/// 1.5.days // equivalent to Duration(hours: 36)
/// ```
extension NumDurationExtensions on num {
  Duration get microseconds => Duration(microseconds: round());
  Duration get milliseconds => (this * 1000).microseconds;
  Duration get seconds => (this * 1000).milliseconds;
  Duration get minutes => (this * 60).seconds;
  Duration get hours => (this * 60).minutes;
  Duration get days => (this * 24).hours;
  Duration get ms => milliseconds;
}
