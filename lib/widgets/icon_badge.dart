import 'package:flutter/material.dart';

class IconBadge extends StatelessWidget {

  final IconData icon;
  final Color colorIcon;
  final Color colorBackground;
  final Color colorTextBadge;
  final String badge;

  IconBadge(
      this.icon,
  {
    this.colorIcon = Colors.white,
    this.badge,
    this.colorBackground = Colors.red,
    this.colorTextBadge = Colors.white
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Icon(
          icon,
          color: colorIcon,),
        Positioned(
          right: 0,
          child: new Container(
            padding: EdgeInsets.all(1),
            decoration: new BoxDecoration(
              color: colorBackground,
              borderRadius: BorderRadius.circular(6),
            ),
            constraints: BoxConstraints(
              minWidth: 12,
              minHeight: 12,
            ),
            child: new Text(
              badge,
              style: new TextStyle(
                color: colorTextBadge,
                fontSize: 8,
                fontWeight: FontWeight.bold
              ),
              textAlign: TextAlign.center,
            ),
          ),
        )
      ],
    );
  }
}
