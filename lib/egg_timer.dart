class EggTimer {

  final Duration maxTime;

  EggTimerState state = EggTimerState.ready;
  Duration _currentTime = const Duration(seconds: 0);

  EggTimer({
    this.maxTime,
  });

  get currentTime => _currentTime;

  set currentTime(newTime) {
    if (state == EggTimerState.ready) {
      _currentTime = newTime > maxTime ? newTime - maxTime : newTime;
    }
  }

}

enum EggTimerState {
  ready,
  running,
  paused,
}