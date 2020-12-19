import 'package:flutter/material.dart';
import 'functions.dart';

class ScaleSplashScreen extends StatefulWidget {
  //ScaleSplashScreen

  // [icon] represents the application icon .
  final Widget icon;
  // [iconScaleDuration] represents duration for which icon would animate .
  final Duration iconScaleDuration;
  // [reverseIconScale] represents if animation icon Scaling should be reversed .
  final bool reverseIconScale;
  // [label] represents text .
  final String label;
  // [labelDirection] represents direction in which label would animate .
  final SplashScreenDirection labelDirection;
  // [labelDuration] represents duration for which label would animate .
  final Duration labelDuration;
  // [labelStyle] represents textStyle given to label if provided .
  final TextStyle labelStyle;
  // [screenFunction] represents function which would get excecuted after splash animation is completed .
  final Function screenFunction;
  // [navigateTo] represents the page you want to navigate after splash animation is completed
  // and screenFunction (if provided) is executed completely .
  final Widget navigateTo;
  // [screenLoader] represents custom loader while screenFunction is executed
  // @Default is CircularProgressIndicator .
  final Widget screenLoader;
  // [backgroundColor] represents background Color of splash Screen .
  final Color backgroundColor;
  // [splashPageTransistion] represents Page transistion while navigating to new Page .
  final SplashPageTransistion splashPageTransistion;
  // [pageTransistionDuration] represents Page transistion Duration while navigating to new Page .
  final Duration pageTransistionDuration;
  ScaleSplashScreen(
      {@required this.icon,
      @required this.labelDirection,
      @required this.iconScaleDuration,
      @required this.labelDuration,
      @required this.label,
      @required this.navigateTo,
      this.screenFunction,
      this.labelStyle,
      this.screenLoader,
      this.reverseIconScale,
      this.splashPageTransistion,
      this.pageTransistionDuration,
      this.backgroundColor})
      : assert(icon != null &&
            navigateTo != null &&
            labelDirection != null &&
            labelDuration != null &&
            iconScaleDuration != null &&
            label != null &&
            ((splashPageTransistion == null &&
                    pageTransistionDuration == null) ||
                (splashPageTransistion != null &&
                    pageTransistionDuration != null)));
  @override
  _ScaleSplashScreenState createState() => _ScaleSplashScreenState();
}

class _ScaleSplashScreenState extends State<ScaleSplashScreen>
    with TickerProviderStateMixin {
  AnimationController scaleController;
  Animation<double> scaleAnimation;
  AnimationController labelAnimationController;
  Animation<double> labelAnimation;
  bool completed = false;
  bool initAnimation = false;
  bool loading = false;
  @override
  void initState() {
    super.initState();
    loading = false;
    initAnimation = false;
    completed = false;
    scaleController =
        AnimationController(vsync: this, duration: widget.iconScaleDuration);
    scaleAnimation = Tween<double>(begin: 5, end: 1).animate(scaleController);
    labelAnimationController =
        AnimationController(vsync: this, duration: widget.labelDuration);
    labelAnimation =
        Tween<double>(begin: 0, end: 0).animate(labelAnimationController);
    scaleAnimation.addListener(() {
      if (scaleAnimation.isCompleted) {
        completed = true;
        labelAnimationController.forward();
      }
      setState(() {});
    });
    labelAnimation.addListener(() async {
      if (labelAnimation.isCompleted) {
        if (this.widget.screenFunction == null) {
          Future.delayed(Duration(seconds: 1)).then((value) {
            navigateToPage(context, widget.pageTransistionDuration,
                widget.splashPageTransistion, widget.navigateTo);
          });
        } else {
          setState(() {
            loading = true;
          });
          await this.widget.screenFunction();
          setState(() {
            loading = false;
          });
          if (widget.reverseIconScale != null && widget.reverseIconScale) {
            await labelAnimationController.reverse().whenComplete(() async {
              await scaleController.reverse().whenComplete(() {
                navigateToPage(context, widget.pageTransistionDuration,
                    widget.splashPageTransistion, widget.navigateTo);
              });
            });
          } else {
            navigateToPage(context, widget.pageTransistionDuration,
                widget.splashPageTransistion, widget.navigateTo);
          }
        }
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    scaleController.dispose();
    labelAnimationController.dispose();
  }

  getAnimation(double w, double h) {
    if (widget.labelDirection == SplashScreenDirection.LTR) {
      return Tween<double>(begin: w * 0.35, end: w * 0.20)
          .animate(labelAnimationController);
    } else if (widget.labelDirection == SplashScreenDirection.RTL) {
      return Tween<double>(begin: w * 0.35, end: w * 0.20)
          .animate(labelAnimationController);
    } else if (widget.labelDirection == SplashScreenDirection.TTB) {
      return Tween<double>(begin: h * 0.45, end: h * 0.55)
          .animate(labelAnimationController);
    } else if (widget.labelDirection == SplashScreenDirection.BTT) {
      return Tween<double>(begin: h * 0.45, end: h * 0.25)
          .animate(labelAnimationController);
    }
  }

  getWidget1(double w, double h) {
    if (widget.labelDirection == SplashScreenDirection.LTR) {
      return Positioned(
        left: !completed ? w * 0.35 : w * 0.70 - labelAnimation.value,
        top: h * 0.40,
        child: AnimatedOpacity(
          duration: Duration(milliseconds: 800),
          opacity: completed ? 1 : 0,
          child: Container(
            height: w * 0.3,
            width: w * 0.3,
            child: Center(
              child: Text(this.widget.label, style: this.widget.labelStyle),
            ),
          ),
        ),
      );
    } else if (widget.labelDirection == SplashScreenDirection.RTL) {
      return Positioned(
        left: !completed ? w * 0.35 : labelAnimation.value,
        top: h * 0.40,
        child: AnimatedOpacity(
          duration: Duration(milliseconds: 800),
          opacity: completed ? 1 : 0,
          child: Container(
            height: w * 0.3,
            width: w * 0.3,
            child: Center(
              child: Text(this.widget.label, style: this.widget.labelStyle),
            ),
          ),
        ),
      );
    } else if (widget.labelDirection == SplashScreenDirection.TTB ||
        widget.labelDirection == SplashScreenDirection.BTT) {
      return Positioned(
        left: w * 0.35,
        top: labelAnimation.value,
        child: AnimatedOpacity(
          duration: Duration(milliseconds: 800),
          opacity: completed ? 1 : 0,
          child: Container(
            height: w * 0.3,
            width: w * 0.3,
            child: Center(
              child: Text(this.widget.label, style: this.widget.labelStyle),
            ),
          ),
        ),
      );
    }
  }

  getWidget2(double w, double h) {
    if (widget.labelDirection == SplashScreenDirection.LTR) {
      return Positioned(
        left: !completed ? w * 0.35 : labelAnimation.value,
        top: h * 0.40,
        child: Transform.scale(
          scale: scaleAnimation.value,
          child: Container(
            height: w * 0.3,
            width: w * 0.3,
            color: widget.backgroundColor ?? Colors.white,
            child: this.widget.icon,
          ),
        ),
      );
    } else if (widget.labelDirection == SplashScreenDirection.RTL) {
      return Positioned(
        left: !completed ? w * 0.35 : w * 0.70 - labelAnimation.value,
        top: h * 0.40,
        child: Transform.scale(
          scale: scaleAnimation.value,
          child: Container(
            height: w * 0.3,
            width: w * 0.3,
            color: widget.backgroundColor ?? Colors.white,
            child: this.widget.icon,
          ),
        ),
      );
    } else if (widget.labelDirection == SplashScreenDirection.TTB ||
        widget.labelDirection == SplashScreenDirection.BTT) {
      return Positioned(
        left: w * 0.35,
        top: h * 0.40,
        child: Transform.scale(
          scale: scaleAnimation.value,
          child: Container(
            height: w * 0.3,
            width: w * 0.3,
            color: widget.backgroundColor ?? Colors.white,
            child: this.widget.icon,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = getWidth(context);
    double height = getHeight(context);
    if (!initAnimation) {
      initAnimation = true;
      labelAnimation = getAnimation(width, height);
      scaleController.forward();
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: widget.backgroundColor ?? Colors.white,
        body: Container(
          height: height,
          width: width,
          child: Stack(
            children: [
              Container(
                height: height,
                width: width,
              ),
              Positioned(
                bottom: height * 0.15,
                left: width * 0.40,
                child: AnimatedCrossFade(
                  duration: Duration(milliseconds: 800),
                  firstChild: this.widget.screenLoader == null
                      ? SizedBox(
                          height: height * 0.1,
                          width: height * 0.1,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : this.widget.screenLoader,
                  secondChild: SizedBox(
                    height: height * 0.1,
                    width: height * 0.1,
                  ),
                  crossFadeState: loading
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                ),
              ),
              getWidget1(width, height),
              getWidget2(width, height),
            ],
          ),
        ),
      ),
    );
  }
}
