import 'dart:async';

class EggTimer {

  final Duration maxTime;
  final Stopwatch stopwatch = Stopwatch();

  EggTimerState state = EggTimerState.ready;
  Duration _currentTime = const Duration(seconds: 0);
  Duration lastStartTime = const Duration(seconds: 0);

  EggTimer({
    this.maxTime,
  });

  get currentTime => _currentTime;

  set currentTime(newTime) {
    if (state == EggTimerState.ready) {
      _currentTime = newTime > maxTime ? newTime - maxTime : newTime;
    }
  }

  resume() {
    state = EggTimerState.running;
    lastStartTime = currentTime;
    stopwatch.start();
    _tick();
  }

  pause() {
    state = EggTimerState.paused;
  }

  _tick() {
    print('Current Time: ${_currentTime.inSeconds}');
    _currentTime = lastStartTime - stopwatch.elapsed;

    if (_currentTime.inSeconds > 0) {
      new Timer(const Duration(seconds: 1), _tick);
    } else {
      state = EggTimerState.ready;
    }
  }

}

enum EggTimerState {
  ready,
  running,
  paused,
}