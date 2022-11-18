extension DurationToString on Duration {
  String get minutes => (inMinutes % 60).toString().padLeft(2, '0');
  String get seconds => (inSeconds % 60).toString().padLeft(2, '0');
  String get milliseconds => (inMilliseconds % 1000).toString().padLeft(3, '0');
  String get centiseconds => milliseconds.substring(0, 2);

  String get stopwatchText {
    return '$minutes:$seconds.$centiseconds';
  }
}
