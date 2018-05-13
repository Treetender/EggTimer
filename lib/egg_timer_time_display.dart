import 'package:flutter/material.dart';

class EggTimerTimeDisplay extends StatefulWidget {

  final Duration displayTime;

  EggTimerTimeDisplay({
    this.displayTime = const Duration(seconds: 0)
  });

  @override
  _EggTimerTimeDisplayState createState() => new _EggTimerTimeDisplayState();
}

class _EggTimerTimeDisplayState extends State<EggTimerTimeDisplay> {

  String _currentTime;

  void setDisplayTime(Duration time) {
    setState(() => currentTime = time);
  }

  String _displayTimeAsString(Duration time) {

    int seconds = time.inSeconds.remainder(Duration.secondsPerMinute);
    var displaySeconds = seconds < 10 ? '0$seconds' : '$seconds';

    if (time.inMinutes < 10) {
      return '0${time.inMinutes}:$displaySeconds';
    }

    return '${time.inMinutes}:$displaySeconds';
  }

  get currentTime => _currentTime;

  set currentTime(Duration newTime) {
    _currentTime = _displayTimeAsString(newTime);
  }

  @override
  void initState() {
    super.initState();
    currentTime = widget.displayTime;
  }

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: new Text(
        currentTime,
        textAlign: TextAlign.center,
        style: const TextStyle(
            fontSize: 150.0,
            color: Colors.black,
            fontFamily: 'BebasNeue',
            fontWeight: FontWeight.bold,
            letterSpacing: 10.0
            ),
      ),
    );
  }
}
