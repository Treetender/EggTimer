import 'dart:async';

class EggTimer {
  final Duration maxTime;
  final Stopwatch stopwatch = Stopwatch();
  final Function onTimerUpdate;

  EggTimerState state = EggTimerState.ready;
  Duration _currentTime = const Duration(seconds: 0);
  Duration lastStartTime = const Duration(seconds: 0);

  EggTimer({
    this.maxTime,
    this.onTimerUpdate,
  });

  get currentTime => _currentTime;

  set currentTime(newTime) {
    if (state == EggTimerState.ready) {
      _currentTime = newTime;
      lastStartTime = currentTime;
    }
  }

  resume() {
    if (state != EggTimerState.running) {
      state = EggTimerState.running;
      stopwatch.start();

      _tick();
    }
  }

  pause() {
    if (state == EggTimerState.running) {
      state = EggTimerState.paused;
      stopwatch.stop();

      if (null != onTimerUpdate) {
        onTimerUpdate();
      }
    }
  }

  reset() {
    if (state == EggTimerState.paused) {
      state = EggTimerState.ready;
      _currentTime = const Duration(seconds: 0);
      lastStartTime = currentTime;
      stopwatch.reset();

      if (null != onTimerUpdate) {
        onTimerUpdate();
      }
    }
  }

  restart() {
    if (state == EggTimerState.paused) {
      state = EggTimerState.running;
      _currentTime = lastStartTime;
      stopwatch.reset();
      stopwatch.start();

      _tick();
    }
  }

  _tick() {
    print('Current Time: ${_currentTime.inSeconds}');
    _currentTime = lastStartTime - stopwatch.elapsed;

    if (_currentTime.inSeconds > 0) {
      new Timer(const Duration(seconds: 1), _tick);
    } else {
      state = EggTimerState.ready;
      lastStartTime = const Duration(seconds: 0);
    }

    if (null != onTimerUpdate) {
      onTimerUpdate();
    }
  }
}

enum EggTimerState {
  ready,
  running,
  paused,
}
