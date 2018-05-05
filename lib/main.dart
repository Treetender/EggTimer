import 'package:eggtimer/egg_timer_controls.dart';
import 'package:eggtimer/egg_timer_dial.dart';
import 'package:flutter/material.dart';

import 'egg_timer_time_display.dart';

import 'package:fluttery/animations.dart';
import 'package:fluttery/framing.dart';
import 'package:fluttery/gestures.dart';

const Color GRADIENT_TOP = const Color(0xFFF5F5F5);
const Color GRADIENT_BOTTOM = const Color(0xFFE8E8E8);

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Egg Timer',
      theme: new ThemeData(
        fontFamily: 'BebasNeue',
      ),
      home: new Scaffold(
        body: new Container(
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [GRADIENT_TOP, GRADIENT_BOTTOM],
            ),
          ),
          child: new Center(
            child: new Column(
              children: [
                new EggTimerTimeDisplay(),
                new EggTimerDial(
                  topGradient: GRADIENT_TOP,
                  bottomGradient: GRADIENT_BOTTOM,
                  currentTime: const Duration(seconds: 0),
                  maxTime: const Duration(minutes: 35),
                  ticksPerSection: 5,
                ),
                new Expanded(
                  child: new Container(),
                ),
                new EggTimerControls()
              ],
            ),
          ),
        ),
      ),
    );
  }
}


