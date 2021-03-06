import 'dart:math';

import 'package:eggtimer/egg_timer.dart';
import 'package:eggtimer/egg_timer_knob.dart';
import 'package:flutter/material.dart';
import 'package:fluttery/gestures.dart';

class EggTimerDial extends StatefulWidget {

  final Color topGradient = const Color(0xFFF5F5F5);
  final Color bottomGradient = const Color(0xFFE8E8E8);

  final EggTimerState eggTimerState;
  final Duration currentTime;
  final Duration maxTime;
  final int ticksPerSection;

  final Function(Duration) onTimeSelected;
  final Function(Duration) onDialStopTurning;

  const EggTimerDial({
    this.currentTime = const Duration(minutes: 0),
    this.maxTime = const Duration(minutes: 35),
    this.ticksPerSection = 5,
    this.onTimeSelected,
    this.onDialStopTurning,
    this.eggTimerState,
  });

  @override
  State<StatefulWidget> createState() => new _EggTimerDialState();
}

class _EggTimerDialState extends State<EggTimerDial> with SingleTickerProviderStateMixin {

  static const RESET_SPEED_PERCENT_PER_SECOND = 4;

  EggTimerState prevEggTimerState;
  double prevRotationPercent = 0.0;
  AnimationController resetToZeroController;
  Animation resettingAnimation;

  _rotationPercent() => widget.currentTime.inSeconds / widget.maxTime.inSeconds;

  @override
    void initState() {
      super.initState();

      resetToZeroController = new AnimationController(vsync: this);
    }

  @override
    void dispose() {
      resetToZeroController.dispose();
      super.dispose();
    }

  @override
  Widget build(BuildContext context) {
    
    if (widget.currentTime.inSeconds == 0 && prevEggTimerState != EggTimerState.ready) {
      resettingAnimation = new Tween(
        begin: prevRotationPercent,
        end: 0.0
      ).animate(resetToZeroController)
      ..addListener(() => setState(() {}))
      ..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            setState(() => resettingAnimation = null);
          }
      });
      resetToZeroController.duration = Duration(
        milliseconds: ((prevRotationPercent / RESET_SPEED_PERCENT_PER_SECOND) * 1000).round()
      );
      resetToZeroController.forward(from: 0.0);
    }

    prevEggTimerState = widget.eggTimerState;
    prevRotationPercent = _rotationPercent();

    return new DialTurnGestureDetector(
      currentTime: widget.currentTime,
      maxTime: widget.maxTime,
      onTimeSelected: widget.onTimeSelected,
      onDialStopTurning: widget.onDialStopTurning,
      child: Container(
      width: double.infinity,
      child: new Padding(
        padding: const EdgeInsets.only(left: 45.0, right: 45.0),
        child: new AspectRatio(
            aspectRatio: 1.0,
            child: new Container(
                decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: new LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [widget.topGradient, widget.bottomGradient],
                    ),
                    boxShadow: [
                      new BoxShadow(
                        color: const Color(0x44000000),
                        blurRadius: 2.0,
                        spreadRadius: 1.0,
                        offset: const Offset(0.0, 1.0),
                      )
                    ]),
                child: new Stack(
                  children: <Widget>[
                    new Container(
                      width: double.infinity,
                      height: double.infinity,
                      padding: const EdgeInsets.all(55.0),
                      child: new CustomPaint(
                        painter: new TickPainter(
                          tickCount: widget.maxTime.inMinutes,
                          ticksPerSection: widget.ticksPerSection
                        ),
                      ),
                    ),
                    new Padding(
                      padding: const EdgeInsets.all(65.0),
                      child: new EggTimerKnob(
                        topGradient: widget.topGradient,
                        bottomGradient: widget.bottomGradient,
                        rotationPercent: resettingAnimation == null 
                          ? _rotationPercent()
                          : resettingAnimation.value,
                      ),
                    ),
                  ],
                )
              )
            ),
      ),
    )
    );
  }
}

class DialTurnGestureDetector extends StatefulWidget {
  final Duration currentTime;
  final Duration maxTime;
  final Function(Duration) onTimeSelected;
  final Function(Duration) onDialStopTurning;
  final child;

  DialTurnGestureDetector({
    this.child,
    this.currentTime,
    this.maxTime,
    this.onTimeSelected,
    this.onDialStopTurning,
  });

  @override
  _DialTurnGestureDetectorState createState() => new _DialTurnGestureDetectorState();
}

class _DialTurnGestureDetectorState extends State<DialTurnGestureDetector> {
  PolarCoord startDragCoord;
  Duration startDragTime;
  Duration selectedTime;

  _onRadialDragStart(PolarCoord coord) {
     startDragCoord = coord;
     startDragTime = widget.currentTime;
  }

  _onRadialDragUpdate(PolarCoord coord) {
    if (startDragCoord != null) {
      var angleDiff = coord.angle - startDragCoord.angle;
      angleDiff = angleDiff >= 0.0 ? angleDiff : angleDiff + (2 * pi);
      final angleDiffPercent = angleDiff / (2 * pi);
      final timeDiff = (widget.maxTime.inSeconds * angleDiffPercent).round();
      selectedTime = Duration(seconds: (startDragTime.inSeconds + timeDiff));

      widget.onTimeSelected(selectedTime);
    }
  }

  _onRadialDragEnd() {
    widget.onDialStopTurning(selectedTime);
    startDragCoord = null;

  }

  @override
  Widget build(BuildContext context) {
    return RadialDragGestureDetector(
      child: widget.child,
      onRadialDragStart: _onRadialDragStart,
      onRadialDragUpdate: _onRadialDragUpdate,
      onRadialDragEnd: _onRadialDragEnd,
    );
  }
}



class TickPainter extends CustomPainter {
  static const LONG_TICK = 14.0;
  static const SHORT_TICK = 4.0;

  final int tickCount;
  final int ticksPerSection;
  final int ticksInset;
  final Paint tickPaint;
  final TextPainter textPainter;
  final TextStyle textStyle;

  TickPainter({
    this.tickCount = 35,
    this.ticksPerSection = 5,
    this.ticksInset = 0,
  }) : tickPaint = new Paint(),
       textPainter = new TextPainter(
         textAlign: TextAlign.center,
         textDirection: TextDirection.ltr,
       ),
       textStyle = const TextStyle(
         color: Colors.black,
         fontFamily: 'BebasNeue',
         fontSize: 20.0
       ) 
  {
    tickPaint.color = Colors.black;
    tickPaint.strokeWidth = 1.5;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2);

    canvas.save();

    final radius = size.width / 2;

    for(var i = 0; i < tickCount; ++i) {
      final tickLength = i % ticksPerSection == 0 ? LONG_TICK : SHORT_TICK;

      canvas.drawLine(
        new Offset(0.0, -radius), 
        new Offset(0.0, -radius - tickLength),
        tickPaint
      );

      if (i % ticksPerSection == 0) {
        //Paint Text
        canvas.save();
        canvas.translate(0.0, -(size.width / 2) - 30.0);

        textPainter.text = new TextSpan(
          text: '$i',
          style: textStyle,
        );
        //Layout the text
        textPainter.layout();

        // Determine the text quadrant (go go cartesian quadrants)
        final tickPercent = i / tickCount;
        var quadrant;

        if (tickPercent < 0.25) {
          quadrant = 1;
        } else if (tickPercent < 0.5) {
          quadrant = 4;
        } else if (tickPercent < 0.75) {
          quadrant = 3;
        } else {
          quadrant = 2;
        }

        switch (quadrant) {
          case 4:
            canvas.rotate(-pi / 2);
            break;
          case 2:
          case 3:
            canvas.rotate(pi / 2);
            break;
        }

        textPainter.paint(
          canvas, 
          new Offset(
            -textPainter.width / 2, 
            -textPainter.height / 2)
        );

        canvas.restore();
      }

      canvas.rotate(2 * pi / tickCount);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

}