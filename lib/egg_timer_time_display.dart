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

  String _displayTimeAsString() {

    final seconds = widget.displayTime.inSeconds.remainder(Duration.secondsPerMinute);
    final displaySeconds = seconds < 10 ? '0$seconds' : '$seconds';

    if (widget.displayTime.inMinutes < 10) {
      return '0${widget.displayTime.inMinutes}:$displaySeconds';
    }

    return '${widget.displayTime.inMinutes}:$displaySeconds';
  }

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: new Text(
        _displayTimeAsString(),
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
