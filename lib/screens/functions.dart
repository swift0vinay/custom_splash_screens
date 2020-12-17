import 'package:flutter/material.dart';

getHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

getWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

enum SplashScreenDirection {
  LTR,
  RTL,
  TTB,
  BTT,
}
