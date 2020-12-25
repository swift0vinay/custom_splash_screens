import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';

getHeight(BuildContext context) {
  // Method to get screen Height
  Orientation orientation = MediaQuery.of(context).orientation;
  if (orientation == Orientation.portrait)
    return MediaQuery.of(context).size.height;
  else
    return MediaQuery.of(context).size.width;
}

getWidth(BuildContext context) {
  // Method to get screen Width
  Orientation orientation = MediaQuery.of(context).orientation;
  if (orientation == Orientation.portrait)
    return MediaQuery.of(context).size.width;
  else
    return MediaQuery.of(context).size.height;
}

//Enum Representing Directions
enum SplashScreenDirection {
  LTR, // LEFT-TO-RIGHT
  RTL, // RIGHT-TO-LEFT
  TTB, // TOP-TO-BOTTOM
  BTT, // BOTTOM-TO-TOP
}

//Enum Representing SplashPageTransistions
enum SplashPageTransistion {
  SlideDown,
  SlideUp,
  SlideLeft,
  SlideRight,
  Flip1,
  Flip2,
  Flip3,
  Flip4,
}

getPageTransistion(context, animation, secondaryAnimation, child,
    SplashPageTransistion splashPageTransistion) {
  switch (splashPageTransistion) {
    case SplashPageTransistion.SlideLeft:
      {
        return SlideTransition(
          child: child,
          position: Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0))
              .animate(animation),
        );
      }
    case SplashPageTransistion.SlideRight:
      {
        return SlideTransition(
          child: child,
          position: Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0))
              .animate(animation),
        );
      }
    case SplashPageTransistion.SlideDown:
      {
        return SlideTransition(
          child: child,
          position: Tween<Offset>(begin: Offset(0, -1), end: Offset(0, 0))
              .animate(animation),
        );
      }
    case SplashPageTransistion.SlideUp:
      {
        return SlideTransition(
          child: child,
          position: Tween<Offset>(begin: Offset(0, 1), end: Offset(0, 0))
              .animate(animation),
        );
      }
    case SplashPageTransistion.Flip1:
      {
        return Transform(
          transform: Matrix4.identity()
            ..rotateY(
                new Tween<double>(begin: -pi, end: 0).animate(animation).value),
          child: child,
        );
      }
    case SplashPageTransistion.Flip2:
      {
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..rotateY(
                new Tween<double>(begin: pi, end: 0).animate(animation).value),
          child: child,
        );
      }
    case SplashPageTransistion.Flip3:
      {
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..rotateY(
                new Tween<double>(begin: -pi, end: 0).animate(animation).value),
          child: child,
        );
      }
    case SplashPageTransistion.Flip4:
      {
        return Transform(
          alignment: Alignment.centerRight,
          transform: Matrix4.identity()
            ..rotateY(
                new Tween<double>(begin: pi, end: 0).animate(animation).value),
          child: child,
        );
      }
  }
}

navigateToPage(BuildContext context, Duration pageTransistionDuration,
    SplashPageTransistion splashPageTransistion, Widget navigateTo) {
  if (splashPageTransistion != null) {
    Navigator.of(context).pushReplacement(PageRouteBuilder(
      transitionDuration: pageTransistionDuration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return getPageTransistion(context, animation, secondaryAnimation, child,
            splashPageTransistion);
      },
      pageBuilder: (context, _, __) {
        return navigateTo;
      },
    ));
  } else {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
      return navigateTo;
    }));
  }
}
