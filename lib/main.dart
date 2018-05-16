import 'package:eggtimer/egg_timer.dart';
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

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() {
    return new _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  final EggTimer eggTimer;
  
  _MyAppState() :
    eggTimer = new EggTimer(maxTime: const Duration(minutes: 35));
  

  _onTimeSelected(Duration newTime) {
    setState(() { 
      eggTimer.currentTime = newTime; 
    });
  }

  _onResetPressed() {
 
  }

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
                new EggTimerTimeDisplay(
                  displayTime: eggTimer.currentTime,
                ),
                new EggTimerDial(
                  currentTime: eggTimer.currentTime,
                  maxTime: eggTimer.maxTime,
                  ticksPerSection: 5,
                  onTimeSelected: _onTimeSelected,
                ),
                new Expanded(
                  child: new Container(),
                ),
                new EggTimerControls(
                  onReset: _onResetPressed(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}


