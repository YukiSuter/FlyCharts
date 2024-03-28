import 'dart:ffi';

import 'package:flutter/material.dart';

class cardButton extends StatelessWidget {
  const cardButton(
      {required this.backgroundColor,
      required this.borderColor,
      required this.borderRadius,
      required this.text,
      required this.icon,
      required this.height,
      required this.width,
      required this.textScaleFactor,
      required this.iconSize,
      super.key});

  final Color backgroundColor;
  final Color borderColor;
  final double borderRadius;
  final String text;
  final IconData icon;
  final double height;
  final double width;
  final double textScaleFactor;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          border: Border.all(color: borderColor)),
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(icon, size: iconSize),
            Text(
              text,
              textScaler: TextScaler.linear(textScaleFactor),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
