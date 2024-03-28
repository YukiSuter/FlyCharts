import 'package:flutter/material.dart';

double scaleFactor(BuildContext context) {
  double availableWidth = MediaQuery.of(context).size.width;
  double availableHeight = MediaQuery.of(context).size.height;
  print("height" + availableHeight.toString());
  print("width" + availableWidth.toString());

  double idealWidth = 1180;
  double idealHeight = 680;

  double widthRatio = (availableWidth - 120) / idealWidth;
  double heightRatio = (availableHeight - 120) / idealHeight;

  print("WR: " + widthRatio.toString());
  print("HR: " + heightRatio.toString());

  double calcSF = 1;
  if (widthRatio < heightRatio) {
    calcSF = widthRatio;
  } else {
    calcSF = heightRatio;
  }
  print("SF: " + calcSF.toString());

  return calcSF;
}
