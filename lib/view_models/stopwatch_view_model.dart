import 'dart:async';

import 'package:flutter/cupertino.dart';

class StopwatchViewModel {
  final Stopwatch _stopwatch;
  final ValueNotifier<bool> running;
  final ValueNotifier<Duration> elapsed;
  final ValueNotifier<List<Duration>> counters;

  late Timer _timer;

  StopwatchViewModel()
      : _stopwatch = Stopwatch(),
        running = ValueNotifier(false),
        elapsed = ValueNotifier(Duration.zero),
        counters = ValueNotifier([]);

  void start() {
    const duration = Duration(milliseconds: 10);
    _timer = Timer.periodic(duration, (timer) {
      elapsed.value = _stopwatch.elapsed;
    });
    _stopwatch.start();
    running.value = true;
  }

  void stop() {
    _stopwatch.stop();
    _timer.cancel();
    running.value = false;
  }

  void reset() {
    _stopwatch.reset();
    elapsed.value = _stopwatch.elapsed;
    counters.value = [];
  }

  void count() {
    counters.value = [...counters.value, elapsed.value];
  }
}
