import 'package:flutter/material.dart';

class CircleButton extends StatelessWidget {
  final GestureTapCallback onTap;
  final IconData iconData;

  const CircleButton({ required this.onTap, required this.iconData}) : super();

  @override
  Widget build(BuildContext context) {
    double size = 20.0;

    return new InkResponse(
      onTap: onTap,
      child: new Container(
        alignment: Alignment.center,
        width: size,
        height: size,
        decoration: new BoxDecoration(
          color: Colors.black,
          shape: BoxShape.circle,
        ),
        child: new Icon(
          iconData,
          color: Colors.white,
          size: 15,
        ),
      ),
    );
  }
}