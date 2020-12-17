
# custom_splash_screens
Creates Custom Splash Screens having cool Animations.

# Getting Started
To use this plugin, add *custom_splash_screen* as a dependency in your pubspec.yaml file.

There are  2 types of SplashScreens :
 - SCALE_SPLASH_SCREEN
 - LINEAR_SPLASH_SCREEN

Also there are 4 Splash Screen Directions to customize animations on your own :

 - SplashScrenDirection.LTR (Left-To-Right)
 - SplashScrenDirection.RTL (Right-To-Left)
 - SplashScrenDirection.TTB (Top-To-Bottom)
 - SplashScrenDirection.BTT (Bottom-To-Top)

Further below are the must required properties while using any of the splash screen : 

 - icon
 - label
 - iconDuration (in Linear-Splash-Screen only)
 - iconScaleDuration (in Scale-Splash-Screen only)
 - labelDuration
 - navigateTo
 - labelDirection
 - iconDirection (in Linear-Splash-Screen only)


# ScaleSplashScreen
Example : 

	import 'package:flutter/material.dart';  
	import 'package:custom_splash_screens/custom_splash_screens.dart';
        
        void main() => runApp(MyApp());  
       
	    class  MyApp  extends  StatelessWidget {
	    @override
	    Widget  build(BuildContext context) {
		    return  MaterialApp(
		    title: 'SCALE SPLASH SCREEN',
		    home: ScaleSplashScreen(
	    icon: FlutterLogo(),  //icon of your application or any widget you like to show
	    labelDirection: SplashScreenDirection.LTR,  //direction in which label would move in splashScreen
	    iconScaleDuration: Duration(seconds: 2),  // Duration for how long icon would scale
	    labelDuration: Duration(seconds: 2),  // Duration for how long label would move
	    label: "NEW APP",    
	    backgroundColor:Colors.green,  //background color for your splash screen
	    labelStyle: TextStyle(fontSize: 18,fontWeight:FontWeight.bold),  //style for your label
        navigateTo: NewHome(),  // Navigate to another Page whent animation is completed or screenFunction (if given) is executed
        screenFunction: () async {
		    await  Future.delayed(Duration(seconds: 10));
            },
          ),  // function needed to be executed on splash Screen
         screenLoader: SizedBox(
	          height:100,
	          width:100,
	          child:Text("LOADING"),
	       ),  //defines custom loader if screen Function takes longer time in execution,By default is an circular progress indicator
	    );
      }
    }
    
# LinearSplashScreen
Example : 

	import 'package:flutter/material.dart';  
	import 'package:custom_splash_screens/custom_splash_screens.dart';
        
        void main() => runApp(MyApp());  
       
	    class  MyApp  extends  StatelessWidget {
	    @override
	    Widget  build(BuildContext context) {
		    return  MaterialApp(
		    title: 'SCALE SPLASH SCREEN',
		    home: LinearSplashScreen(
	    icon: FlutterLogo(),  //icon of your application or any widget you like to show
	    iconDirection: SplashScreenDirection.TTB,  //direction in which icon would move in splashScreen
	    labelDirection: SplashScreenDirection.LTR,  //direction in which label would move in splashScreen
	    iconDuration: Duration(seconds: 2),  // Duration for how long icon would move
	    labelDuration: Duration(seconds: 2),  // Duration for how long label would move
	    label: "NEW APP",    
	    backgroundColor:Colors.green,  //background color for your splash screen
	    labelStyle: TextStyle(fontSize: 18,fontWeight:FontWeight.bold),  //style for your label
        navigateTo: NewHome(),  // Navigate to another Page whent animation is completed or screenFunction (if given) is executed
        screenFunction: () async {
		    await  Future.delayed(Duration(seconds: 10));
            },
          ),  // function needed to be executed on splash Screen
         screenLoader: SizedBox(
	          height:100,
	          width:100,
	          child:Text("LOADING"),
	       ),  //defines custom loader if screen Function takes longer time in execution,By default is an circular progress indicator
	    );
      }
    }
