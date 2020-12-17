# custom_splash_screens

Creates Custom Splash Screens having cool Animations.

## Getting Started

To use this plugin, add custom_splash_screen as a dependency in your pubspec.yaml file.

There are inititally 2 types of splash screens : ScaleSplashScreen and LinearSplashScreen.

ScaleSplashScreen has following properties:
       NAME                                RETURN TYPE
    -> icon                       |      Widget
    -> labelDirection             |      SplashScreenDirection                -> iconScaleDuration          |      Duration
    -> labelDuration              |      Duration
    -> label                      |      String
    -> labelStyle                 |      TextStyle
    -> navigateTo                 |      Widget
    -> screenFunction             |      Function
    -> backgroundColor            |      Color
    -> screenLoader               |      Widget