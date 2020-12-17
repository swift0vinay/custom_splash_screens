import 'package:flutter/material.dart';
import 'functions.dart';

class ScaleSplashScreen extends StatefulWidget {
  // SCALE TRANSISTION
  final Widget icon;
  final Duration iconScaleDuration;
  final String label;
  final SplashScreenDirection labelDirection;
  final Duration labelDuration;
  final TextStyle labelStyle;
  final Function screenFunction;
  final Widget navigateTo;
  final Widget screenLoader;
  final Color backgroundColor;
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
      this.backgroundColor})
      : assert(icon != null &&
            navigateTo != null &&
            labelDirection != null &&
            labelDuration != null &&
            iconScaleDuration != null &&
            label != null);
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
    // TODO: implement initState
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
            Navigator.of(context)
                .pushReplacement(MaterialPageRoute(builder: (context) {
              return this.widget.navigateTo;
            }));
          });
        } else {
          setState(() {
            loading = true;
          });
          await this.widget.screenFunction();
          setState(() {
            loading = false;
          });
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (context) {
            return this.widget.navigateTo;
          }));
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
