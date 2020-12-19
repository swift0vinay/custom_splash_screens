import 'package:custom_splash_screens/custom_splash_screens.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // SCALE_SPLASH_SCREEN
      /*
      home: ScaleSplashScreen(
      icon: FlutterLogo(),
      iconScaleDuration: Duration(seconds: 2),
      label: "APP NAME",
      labelDirection: SplashScreenDirection.LTR,
      labelDuration: Duration(seconds: 2),
      navigateTo: NavigateTo(),
      splashPageTransistion: SplashPageTransistion.SlideLeft,
      pageTransistionDuration: Duration(seconds: 2),
       screenFunction: () async {
        await Future.delayed(Duration(seconds: 5));
      },
      reverseIconScale:true,
      screenLoader: SizedBox(
        height: 100,
        width: 100,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    )
      */
      // LINEAR_SPLASH_SCREEN

      home: LinearSplashScreen(
        icon: FlutterLogo(),
        iconDirection: SplashScreenDirection.TTB,
        iconDuration: Duration(seconds: 2),
        label: "APP NAME",
        labelDirection: SplashScreenDirection.LTR,
        labelDuration: Duration(seconds: 2),
        navigateTo: NavigateTo(),
        screenFunction: () async {
          await Future.delayed(Duration(seconds: 5));
        },
        splashPageTransistion: SplashPageTransistion.SlideLeft,
        pageTransistionDuration: Duration(seconds: 2),
        screenLoader: SizedBox(
          height: 100,
          width: 100,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}

class NavigateTo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("NEW PAGE")),
      body: Container(
        child: Center(
          child: Text("NEW PAGE"),
        ),
      ),
    );
  }
}
