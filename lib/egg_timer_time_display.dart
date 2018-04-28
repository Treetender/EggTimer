import 'package:flutter/material.dart';

class EggTimerTimeDisplay extends StatefulWidget {
  @override
  _EggTimerTimeDisplayState createState() => new _EggTimerTimeDisplayState();
}

class _EggTimerTimeDisplayState extends State<EggTimerTimeDisplay> {
  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: new Text(
        '4:20',
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
