import 'package:flutter/material.dart';

class EggTimerButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final onButtonPressed;

  EggTimerButton({
    this.icon,
    this.text,
    this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return new FlatButton(
      splashColor: const Color(0x22000000),
      onPressed: onButtonPressed,
      child: new Padding(
        padding: const EdgeInsets.all(25.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            new Padding(
              padding: const EdgeInsets.only(right: 3.0),
              child: new Icon(
                icon, 
                color: Colors.black
                ),
            ),
            new Text(
              text,
              style: new TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3.0),
            )
          ],
        ),
      ),
    );
  }
}
