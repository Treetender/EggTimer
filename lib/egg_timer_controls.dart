import 'package:eggtimer/egg_timer.dart';
import 'package:eggtimer/egg_timer_button.dart';
import 'package:flutter/material.dart';

class EggTimerControls extends StatefulWidget {
  final EggTimerState eggTimerState;
  final Function() onPause;
  final Function() onResume;
  final Function() onRestart;
  final Function() onReset;

  const EggTimerControls({
    this.eggTimerState,
    this.onPause,
    this.onReset,
    this.onRestart,
    this.onResume,
  });

  @override
  _EggTimerControlsState createState() => new _EggTimerControlsState();
}

class _EggTimerControlsState extends State<EggTimerControls> 
  with TickerProviderStateMixin {

  AnimationController pauseResumeSlideController;
  AnimationController restartResetFadeController;

  @override
    void initState() {
      super.initState();

      pauseResumeSlideController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 150),
      )
      ..addListener(() => setState(() {}));
      pauseResumeSlideController.value = 1.0;

      restartResetFadeController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 150),
      )
      ..addListener(() => setState(() {}));
      restartResetFadeController.value = 1.0;
    }

  @override
    void dispose() {
      pauseResumeSlideController.dispose();
      restartResetFadeController.dispose();
      
      super.dispose();
    }

  @override
  Widget build(BuildContext context) {
    switch (widget.eggTimerState) {
      case EggTimerState.ready:
        pauseResumeSlideController.forward();
        restartResetFadeController.forward();
        break;
      case EggTimerState.running:
        pauseResumeSlideController.reverse();
        restartResetFadeController.forward();
        break;
      case EggTimerState.paused:
        pauseResumeSlideController.reverse();
        restartResetFadeController.reverse();
        break;
    }

    return new Column(
      children: [
        new Opacity(
          opacity: 1.0 - restartResetFadeController.value,
          child: new Row(
            children: [
              new EggTimerButton(
                icon: Icons.refresh,
                text: 'RESTART',
                onPressed: widget.onRestart,
              ),
              new Expanded(child: new Container()),
              new EggTimerButton(
                icon: Icons.arrow_back,
                text: 'RESET',
                onPressed: widget.onReset,
              ),
            ],
          ),
        ),
        new Transform(
          transform: Matrix4.translationValues(
            0.0, 
            100 * pauseResumeSlideController.value, 
            0.0),
          child: new EggTimerButton(
            icon: widget.eggTimerState == EggTimerState.running 
            ? Icons.pause 
            : Icons.play_arrow,
            text: widget.eggTimerState == EggTimerState.running
            ? 'PAUSE'
            : 'RESUME',
            onPressed: widget.eggTimerState == EggTimerState.running
            ? widget.onPause
            : widget.onResume,
          ),
        ),
      ],
    );
  }
}
