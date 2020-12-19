import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final Function onTap;
  final Color color;
  final Color shadowColor;
  final String text;

  const Button(
      {Key key, this.onTap, this.color, this.shadowColor, @required this.text})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          height: 40.0,
          child: Material(
            borderRadius: BorderRadius.circular(20.0),
            shadowColor: shadowColor == null ? Colors.greenAccent : shadowColor,
            color: color == null ? Colors.green : color,
            elevation: 7.0,
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'WorkSans'),
              ),
            ),
          )),
    );
  }
}
