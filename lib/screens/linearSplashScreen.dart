import 'package:flutter/material.dart';

import 'functions.dart';

class LinearSplashScreen extends StatefulWidget {
  final Widget icon;
  final Duration iconDuration;
  final String label;
  final SplashScreenDirection iconDirection;
  final SplashScreenDirection labelDirection;
  final Duration labelDuration;
  final TextStyle labelStyle;
  final Function screenFunction;
  final Widget navigateTo;
  final Widget screenLoader;
  final Color backgroundColor;
  LinearSplashScreen(
      {@required this.icon,
      @required this.labelDirection,
      @required this.iconDirection,
      @required this.iconDuration,
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
            iconDuration != null &&
            iconDirection != null &&
            label != null);

  @override
  _LinearSplashScreenState createState() => _LinearSplashScreenState();
}

class _LinearSplashScreenState extends State<LinearSplashScreen>
    with TickerProviderStateMixin {
  AnimationController iconController;
  Animation iconAnimation;
  AnimationController labelController;
  Animation labelAnimation;
  bool completed = false;
  bool initAnimation = false;
  bool loading = false;
  @override
  void initState() {
    super.initState();
    loading = false;
    initAnimation = false;
    completed = false;
    iconController =
        AnimationController(vsync: this, duration: widget.iconDuration);
    labelController =
        AnimationController(vsync: this, duration: widget.labelDuration);
    iconAnimation = Tween<double>(begin: 0, end: 0).animate(iconController);
    labelAnimation = Tween<double>(begin: 0, end: 0).animate(labelController);
    iconAnimation.addListener(() {
      if (iconAnimation.isCompleted) {
        completed = true;
        labelController.forward();
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
    iconController.dispose();
    labelController.dispose();
  }

  getAnimation1(double width, double height) {
    if (widget.iconDirection == SplashScreenDirection.TTB) {
      return Tween<double>(
        begin: 0,
        end: height * 0.40,
      ).animate(iconController);
    } else if (widget.iconDirection == SplashScreenDirection.BTT) {
      return Tween<double>(
        begin: height,
        end: height * 0.40,
      ).animate(iconController);
    } else if (widget.iconDirection == SplashScreenDirection.LTR) {
      return Tween<double>(
        begin: 0,
        end: width * 0.35,
      ).animate(iconController);
    } else if (widget.iconDirection == SplashScreenDirection.RTL) {
      return Tween<double>(
        begin: width,
        end: width * 0.35,
      ).animate(iconController);
    }
  }

  getAnimation2(double width, double height) {
    if (widget.labelDirection == SplashScreenDirection.LTR) {
      return Tween<double>(
        begin: width * 0.35,
        end: width * 0.20,
      ).animate(labelController);
    } else if (widget.labelDirection == SplashScreenDirection.RTL) {
      return Tween<double>(
        begin: width * 0.35,
        end: width * 0.20,
      ).animate(labelController);
    } else if (widget.labelDirection == SplashScreenDirection.TTB) {
      return Tween<double>(
        begin: height * 0.35,
        end: height * 0.50,
      ).animate(labelController);
    } else if (widget.labelDirection == SplashScreenDirection.BTT) {
      return Tween<double>(
        begin: height * 0.35,
        end: height * 0.25,
      ).animate(labelController);
    }
  }

  getWidget1(double width, double height) {
    if (widget.labelDirection == SplashScreenDirection.LTR) {
      return Positioned(
        left: !completed ? width * 0.35 : width * 0.70 - labelAnimation.value,
        top: height * 0.40,
        child: AnimatedOpacity(
          duration: Duration(milliseconds: 800),
          opacity: completed ? 1 : 0,
          child: Container(
            height: width * 0.3,
            width: width * 0.3,
            child: Center(
              child: Text(this.widget.label, style: this.widget.labelStyle),
            ),
          ),
        ),
      );
    } else if (widget.labelDirection == SplashScreenDirection.RTL) {
      return Positioned(
        left: !completed ? width * 0.35 : labelAnimation.value,
        top: height * 0.40,
        child: AnimatedOpacity(
          duration: Duration(milliseconds: 800),
          opacity: completed ? 1 : 0,
          child: Container(
            height: width * 0.3,
            width: width * 0.3,
            child: Center(
              child: Text(this.widget.label, style: this.widget.labelStyle),
            ),
          ),
        ),
      );
    } else if (widget.labelDirection == SplashScreenDirection.TTB) {
      return Positioned(
        left: width * 0.35,
        top: labelAnimation.value,
        child: AnimatedOpacity(
          duration: Duration(milliseconds: 800),
          opacity: completed ? 1 : 0,
          child: Container(
            height: width * 0.3,
            width: width * 0.3,
            child: Center(
              child: Text(this.widget.label, style: this.widget.labelStyle),
            ),
          ),
        ),
      );
    } else if (widget.labelDirection == SplashScreenDirection.BTT) {
      return Positioned(
        left: width * 0.35,
        top: labelAnimation.value,
        child: AnimatedOpacity(
          duration: Duration(milliseconds: 800),
          opacity: completed ? 1 : 0,
          child: Container(
            height: width * 0.3,
            width: width * 0.3,
            child: Center(
              child: Text(this.widget.label, style: this.widget.labelStyle),
            ),
          ),
        ),
      );
    }
  }

  getWidget2(double width, double height) {
    if (widget.iconDirection == SplashScreenDirection.TTB) {
      if (widget.labelDirection == SplashScreenDirection.LTR) {
        return Positioned(
          left: !completed ? width * 0.35 : labelAnimation.value,
          top: iconAnimation.value,
          child: Container(
            height: width * 0.3,
            width: width * 0.3,
            color: widget.backgroundColor ?? Colors.white,
            child: this.widget.icon,
          ),
        );
      } else if (widget.labelDirection == SplashScreenDirection.RTL) {
        return Positioned(
          left: !completed ? width * 0.35 : width * 0.70 - labelAnimation.value,
          top: iconAnimation.value,
          child: Container(
            height: width * 0.3,
            width: width * 0.3,
            color: widget.backgroundColor ?? Colors.white,
            child: this.widget.icon,
          ),
        );
      } else if (widget.labelDirection == SplashScreenDirection.TTB) {
        return Positioned(
          left: width * 0.35,
          top: !completed
              ? iconAnimation.value
              : iconAnimation.value -
                  labelAnimation.value * 0.15 * labelController.value,
          child: Container(
            height: width * 0.3,
            width: width * 0.3,
            color: widget.backgroundColor ?? Colors.white,
            child: this.widget.icon,
          ),
        );
      } else if (widget.labelDirection == SplashScreenDirection.BTT) {
        return Positioned(
          left: width * 0.35,
          top: !completed
              ? iconAnimation.value
              : iconAnimation.value +
                  labelAnimation.value * 0.15 * labelController.value,
          child: Container(
            height: width * 0.3,
            width: width * 0.3,
            color: widget.backgroundColor ?? Colors.white,
            child: this.widget.icon,
          ),
        );
      }
    } else if (widget.iconDirection == SplashScreenDirection.BTT) {
      if (widget.labelDirection == SplashScreenDirection.LTR) {
        return Positioned(
          left: !completed ? width * 0.35 : labelAnimation.value,
          top: iconAnimation.value,
          child: Container(
            height: width * 0.3,
            width: width * 0.3,
            color: widget.backgroundColor ?? Colors.white,
            child: this.widget.icon,
          ),
        );
      } else if (widget.labelDirection == SplashScreenDirection.RTL) {
        return Positioned(
          left: !completed ? width * 0.35 : width * 0.70 - labelAnimation.value,
          top: iconAnimation.value,
          child: Container(
            height: width * 0.3,
            width: width * 0.3,
            color: widget.backgroundColor ?? Colors.white,
            child: this.widget.icon,
          ),
        );
      } else if (widget.labelDirection == SplashScreenDirection.TTB) {
        return Positioned(
          left: width * 0.35,
          top: !completed
              ? iconAnimation.value
              : iconAnimation.value -
                  labelAnimation.value * 0.15 * labelController.value,
          child: Container(
            height: width * 0.3,
            width: width * 0.3,
            color: widget.backgroundColor ?? Colors.white,
            child: this.widget.icon,
          ),
        );
      } else if (widget.labelDirection == SplashScreenDirection.BTT) {
        return Positioned(
          left: width * 0.35,
          top: !completed
              ? iconAnimation.value
              : iconAnimation.value +
                  labelAnimation.value * 0.15 * labelController.value,
          child: Container(
            height: width * 0.3,
            width: width * 0.3,
            color: widget.backgroundColor ?? Colors.white,
            child: this.widget.icon,
          ),
        );
      }
    } else if (widget.iconDirection == SplashScreenDirection.LTR) {
      if (widget.labelDirection == SplashScreenDirection.LTR) {
        return Positioned(
          left: !completed ? iconAnimation.value : labelAnimation.value,
          top: height * 0.4,
          child: Container(
            height: width * 0.3,
            width: width * 0.3,
            color: widget.backgroundColor ?? Colors.white,
            child: this.widget.icon,
          ),
        );
      } else if (widget.labelDirection == SplashScreenDirection.RTL) {
        return Positioned(
          left: !completed
              ? iconAnimation.value
              : width * 0.70 - labelAnimation.value,
          top: height * 0.4,
          child: Container(
            height: width * 0.3,
            width: width * 0.3,
            color: widget.backgroundColor ?? Colors.white,
            child: this.widget.icon,
          ),
        );
      } else if (widget.labelDirection == SplashScreenDirection.TTB) {
        return Positioned(
          left: iconAnimation.value,
          top: !completed
              ? height * 0.40
              : height * 0.40 -
                  labelAnimation.value * 0.15 * labelController.value,
          child: Container(
            height: width * 0.3,
            width: width * 0.3,
            color: widget.backgroundColor ?? Colors.white,
            child: this.widget.icon,
          ),
        );
      } else if (widget.labelDirection == SplashScreenDirection.BTT) {
        return Positioned(
          left: iconAnimation.value,
          top: !completed
              ? height * 0.40
              : height * 0.40 +
                  labelAnimation.value * 0.15 * labelController.value,
          child: Container(
            height: width * 0.3,
            width: width * 0.3,
            color: widget.backgroundColor ?? Colors.white,
            child: this.widget.icon,
          ),
        );
      }
    } else if (widget.iconDirection == SplashScreenDirection.RTL) {
      if (widget.labelDirection == SplashScreenDirection.LTR) {
        return Positioned(
          left: !completed ? iconAnimation.value : labelAnimation.value,
          top: height * 0.4,
          child: Container(
            height: width * 0.3,
            width: width * 0.3,
            color: widget.backgroundColor ?? Colors.white,
            child: this.widget.icon,
          ),
        );
      } else if (widget.labelDirection == SplashScreenDirection.RTL) {
        return Positioned(
          left: !completed
              ? iconAnimation.value
              : width * 0.70 - labelAnimation.value,
          top: height * 0.4,
          child: Container(
            height: width * 0.3,
            width: width * 0.3,
            color: widget.backgroundColor ?? Colors.white,
            child: this.widget.icon,
          ),
        );
      } else if (widget.labelDirection == SplashScreenDirection.TTB) {
        return Positioned(
          left: iconAnimation.value,
          top: !completed
              ? height * 0.40
              : height * 0.40 -
                  labelAnimation.value * 0.15 * labelController.value,
          child: Container(
            height: width * 0.3,
            width: width * 0.3,
            color: widget.backgroundColor ?? Colors.white,
            child: this.widget.icon,
          ),
        );
      } else if (widget.labelDirection == SplashScreenDirection.BTT) {
        return Positioned(
          left: iconAnimation.value,
          top: !completed
              ? height * 0.40
              : height * 0.40 +
                  labelAnimation.value * 0.15 * labelController.value,
          child: Container(
            height: width * 0.3,
            width: width * 0.3,
            color: widget.backgroundColor ?? Colors.white,
            child: this.widget.icon,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = getWidth(context);
    double height = getHeight(context);
    if (!initAnimation) {
      initAnimation = true;
      iconAnimation = getAnimation1(width, height);
      labelAnimation = getAnimation2(width, height);
      iconController.forward();
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
