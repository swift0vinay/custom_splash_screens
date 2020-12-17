
# custom_splash_screens
Creates Custom Splash Screens having cool Animations.

# Getting Started
To use this plugin, add *custom_splash_screen* as a dependency in your pubspec.yaml file.
There are initially 2 types of SplashScreens:
 - SCALE_SPLASH_SCREEN
 - LINEAR_SPLASH_SCREEN

# ScaleSplashScreen
Example : 

       void  main() {
	    runApp(MyApp());
       }
       
	    class  MyApp  extends  StatelessWidget {
	    @override
	    Widget  build(BuildContext context) {
		    return  MaterialApp(
		    title: 'SCALE SPLASH SCREEN',
		    home: ScaleSplashScreen(
	    icon: FlutterLogo(),//icon of your application
	    labelDirection: SplashScreenDirection.LTR,//direction in which label would move in splashScreen
	    iconScaleDuration: Duration(seconds: 2),// Duration for how long icon would scale
	    labelDuration: Duration(seconds: 2),// Duration for how long label would move
	    label: "NEW APP",    
	    backgroundColor:Colors.green,//background color for your splash screen
	    labelStyle: TextStyle(fontSize: 18,fontWeight:FontWeight.bold),//style for your label
        navigateTo: NewHome(),// Navigate to another Page whent animation is completed or screenFunction (if given) is executed
        screenFunction: () async {
	    await  Future.delayed(Duration(seconds: 10));
            },
          ),// function needed to be executed on splash Screen
	    );
      }
    }
