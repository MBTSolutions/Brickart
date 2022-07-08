import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final Color color;
  final String text;
  final Color textColor;
  final Function onPressed;
  final double sizeButton;
  final double shape;
  final bool loading;
  final double elevation;

  ButtonWidget(
      {this.color,
      this.text,
      this.textColor,
      this.onPressed,
      this.sizeButton = 40,
      this.shape = 0,
      this.elevation = 0,
      this.loading = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: sizeButton,
      child: ElevatedButton(
        
        style: ButtonStyle(
          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(shape),),),
          backgroundColor: MaterialStateProperty.all(color),
          elevation: MaterialStateProperty.all(elevation),
          textStyle: MaterialStateProperty.all(TextStyle(
            color: textColor,
          ))
        ),
        child: Text(text,
            style: TextStyle(
              color: textColor,
              fontFamily: 'Montserrat',
              fontSize: 12,
              fontWeight: FontWeight.bold,
            )),
        onPressed: onPressed,
      ),
    );
  }
}
