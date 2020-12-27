import 'dart:math';

import 'package:flutter/material.dart';

import 'functions.dart';

class LinearSplashScreen extends StatefulWidget {
  /// LinearSplashScreen

  /// [onlyIcon] represents if only icon is to be show on splashScreen .
  final bool onlyIcon;

  /// [icon] represents the application icon .
  final Widget icon;

  /// [iconDuration] represents duration for which icon would animate .
  ///
  /// @Default is Duration(seconds:2) .

  final Duration iconDuration;

  /// [label] represents text .

  final String label;

  /// [iconDirection] represents direction in which icon would animate .
  ///
  /// @Default is SplashScreenDirection.TTB
  final SplashScreenDirection iconDirection;

  /// [labelDirection] represents direction in which label would animate .
  ///
  /// @Default is SplashScreenDirection.LTR
  final SplashScreenDirection labelDirection;

  /// [labelDuration] represents duration for which label would animate .
  ///
  /// @Default is Duration(seconds:2) .
  final Duration labelDuration;

  /// [labelStyle] represents textStyle given to label if provided .
  final TextStyle labelStyle;

  /// [screenFunction] represents function which would get excecuted after splash animation is completed .
  final Function screenFunction;

  /// [navigateTo] represents the page you want to navigate after splash animation is completed
  ///
  /// and screenFunction (if provided) is executed completely .
  final Widget navigateTo;

  /// [screenLoader] represents custom loader while screenFunction is executed
  ///
  /// @Default is CircularProgressIndicator .
  final Widget screenLoader;

  /// [backgroundColor] represents background Color of splash Screen .
  final Color backgroundColor;

  /// [splashPageTransistion] represents Page transistion while navigating to new Page .
  final SplashPageTransistion splashPageTransistion;

  /// [pageTransistionDuration] represents Page transistion Duration while navigating to new Page .
  final Duration pageTransistionDuration;

  LinearSplashScreen({
    @required this.icon,
    this.onlyIcon: false,
    this.labelDirection: SplashScreenDirection.LTR,
    this.iconDirection: SplashScreenDirection.TTB,
    this.iconDuration: const Duration(seconds: 2),
    this.labelDuration: const Duration(seconds: 2),
    this.label: '',
    @required this.navigateTo,
    this.screenFunction,
    this.splashPageTransistion,
    this.pageTransistionDuration,
    this.labelStyle,
    this.screenLoader,
    this.backgroundColor,
  }) : assert(icon != null &&
            navigateTo != null &&
            ((splashPageTransistion == null &&
                    pageTransistionDuration == null) ||
                (splashPageTransistion != null &&
                    pageTransistionDuration != null)));

  @override
  _LinearSplashScreenState createState() => _LinearSplashScreenState();
}

class _LinearSplashScreenState extends State<LinearSplashScreen>
    with TickerProviderStateMixin {
  /// [iconController] animates label in the direction specified by [iconDirection] .
  AnimationController iconController;
  Animation iconAnimation;

  /// [labelController] animates label in the direction specified by [labelDirection] .
  AnimationController labelController;
  Animation labelAnimation;

  /// [iconKey] derives the position of icon properties such as height and width .
  final iconKey = GlobalKey();

  /// [completed]  keeps track of whether animation is completed or not .
  bool completed = false;

  /// [initAnimation]  helps to initialize the animations only once .
  bool initAnimation = false;

  /// [loading] keeps track of loading while [screenFunction] is executed .
  bool loading = false;

  double endBottomPercent = 0;
  double endRightPercent = 0;
  double pRightPercent = 0.0;
  double pBottomPercent = 0.0;
  double iconWidth = 0.0;
  double iconHeight = 0.0;

  @override
  void initState() {
    super.initState();

    /// used to locate the [icon] widget so as to center icon and label
    ///
    /// Below method calculates the center of screen accurately and optimizes animation accordingly.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      RenderBox box = iconKey.currentContext.findRenderObject();
      double screenWidth = getWidth(context);
      double screenHeight = getHeight(context);
      iconWidth = box.size.width;
      iconHeight = box.size.height;
      endRightPercent = ((screenWidth - iconWidth) / screenWidth * 100);
      endBottomPercent = ((screenHeight - iconHeight) / screenHeight * 100);
      pRightPercent = ((screenWidth - max(screenHeight, screenWidth) * 0.1) /
          screenWidth *
          100);
      pBottomPercent = ((screenHeight - max(screenHeight, screenWidth) * 0.1) /
          screenHeight *
          100);
      if (!widget.onlyIcon) {
        iconAnimation = getIconAnimation(screenWidth, screenHeight);
        labelAnimation = getLabelAnimation(screenWidth, screenHeight);
      }
      setState(() {});
    });

    loading = false;
    initAnimation = false;
    completed = false;

    iconController =
        AnimationController(vsync: this, duration: widget.iconDuration);
    iconAnimation = Tween<double>(begin: 0, end: 0).animate(iconController);

    labelController =
        AnimationController(vsync: this, duration: widget.labelDuration);
    labelAnimation = Tween<double>(begin: 0, end: 0).animate(labelController);

    /// listener added for [iconAnimation]
    iconAnimation.addListener(() async {
      if (iconAnimation.isCompleted) {
        if (widget.onlyIcon) {
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
            navigateToPage(context, widget.pageTransistionDuration,
                widget.splashPageTransistion, widget.navigateTo);
          }
        } else {
          completed = true;
          labelController.forward();
        }
      }
      setState(() {});
    });

    /// listener added for [labelAnimation]
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
          navigateToPage(context, widget.pageTransistionDuration,
              widget.splashPageTransistion, widget.navigateTo);
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

  getIconAnimation(double width, double height) {
    double screenHorizontalCenter = width * endRightPercent * 0.01 * 0.5;
    double screenVerticalCenter = height * endBottomPercent * 0.01 * 0.5;
    if (widget.iconDirection == SplashScreenDirection.TTB) {
      return Tween<double>(
        begin: 0,
        end: screenVerticalCenter,
      ).animate(iconController);
    } else if (widget.iconDirection == SplashScreenDirection.BTT) {
      return Tween<double>(
        begin: screenVerticalCenter * 2,
        end: screenVerticalCenter,
      ).animate(iconController);
    } else if (widget.iconDirection == SplashScreenDirection.LTR) {
      return Tween<double>(
        begin: 0,
        end: screenHorizontalCenter,
      ).animate(iconController);
    } else if (widget.iconDirection == SplashScreenDirection.RTL) {
      return Tween<double>(
        begin: screenHorizontalCenter * 2,
        end: screenHorizontalCenter,
      ).animate(iconController);
    }
  }

  getLabelAnimation(double width, double height) {
    double halfIconWidth = iconWidth * 0.5;
    double val1 = halfIconWidth * 1.5;
    double halfIconHeight = iconHeight * 0.5;
    double val2 = halfIconHeight * 1.5;
    if (widget.labelDirection == SplashScreenDirection.LTR) {
      return Tween<double>(
        begin: 0,
        end: val1,
      ).animate(labelController);
    } else if (widget.labelDirection == SplashScreenDirection.RTL) {
      return Tween<double>(
        begin: 0,
        end: val1,
      ).animate(labelController);
    } else if (widget.labelDirection == SplashScreenDirection.TTB) {
      return Tween<double>(
        begin: 0,
        end: val2,
      ).animate(labelController);
    } else if (widget.labelDirection == SplashScreenDirection.BTT) {
      return Tween<double>(
        begin: 0,
        end: val2,
      ).animate(labelController);
    }
  }

  getWidget1(double width, double height) {
    double screenHorizontalCenter = width * endRightPercent * 0.01 * 0.5;
    double screenVerticalCenter = height * endBottomPercent * 0.01 * 0.5;
    if (widget.labelDirection == SplashScreenDirection.LTR) {
      return Positioned(
        left: !completed
            ? screenHorizontalCenter
            : screenHorizontalCenter + labelAnimation.value,
        top: screenVerticalCenter,
        child: labelWidget(height, width),
      );
    } else if (widget.labelDirection == SplashScreenDirection.RTL) {
      return Positioned(
        left: !completed
            ? screenHorizontalCenter
            : screenHorizontalCenter - labelAnimation.value,
        top: screenVerticalCenter,
        child: labelWidget(height, width),
      );
    } else if (widget.labelDirection == SplashScreenDirection.TTB) {
      return Positioned(
        left: screenHorizontalCenter,
        top: screenVerticalCenter + labelAnimation.value,
        child: labelWidget(height, width),
      );
    } else if (widget.labelDirection == SplashScreenDirection.BTT) {
      return Positioned(
        left: screenHorizontalCenter,
        top: screenVerticalCenter - labelAnimation.value,
        child: labelWidget(height, width),
      );
    }
  }

  /// Returns the widget which contains [label]
  AnimatedOpacity labelWidget(double h, double w) {
    return AnimatedOpacity(
      duration: Duration(milliseconds: 800),
      opacity: completed ? 1 : 0,
      child: Container(
        constraints: BoxConstraints(
          minHeight: max(h, w) * 0.1,
          minWidth: max(h, w) * 0.1,
        ),
        height: iconHeight,
        width: iconWidth,
        child: Center(
          child: Text(this.widget.label, style: this.widget.labelStyle),
        ),
      ),
    );
  }

  getWidget2(double width, double height) {
    double screenHorizontalCenter = width * endRightPercent * 0.01 * 0.5;
    double screenVerticalCenter = height * endBottomPercent * 0.01 * 0.5;
    if (widget.iconDirection == SplashScreenDirection.TTB) {
      if (widget.labelDirection == SplashScreenDirection.LTR) {
        return Positioned(
          left: !completed
              ? screenHorizontalCenter
              : screenHorizontalCenter - labelAnimation.value,
          top: iconAnimation.value,
          child: iconWidget(height, width),
        );
      } else if (widget.labelDirection == SplashScreenDirection.RTL) {
        return Positioned(
          left: !completed
              ? screenHorizontalCenter
              : screenHorizontalCenter + labelAnimation.value,
          top: iconAnimation.value,
          child: iconWidget(height, width),
        );
      } else if (widget.labelDirection == SplashScreenDirection.TTB) {
        return Positioned(
          left: screenHorizontalCenter,
          top: !completed
              ? iconAnimation.value
              : screenVerticalCenter - labelAnimation.value,
          child: iconWidget(height, width),
        );
      } else if (widget.labelDirection == SplashScreenDirection.BTT) {
        return Positioned(
          left: screenHorizontalCenter,
          top: !completed
              ? iconAnimation.value
              : screenVerticalCenter + labelAnimation.value,
          child: iconWidget(height, width),
        );
      }
    } else if (widget.iconDirection == SplashScreenDirection.BTT) {
      if (widget.labelDirection == SplashScreenDirection.LTR) {
        return Positioned(
          left: !completed
              ? screenHorizontalCenter
              : screenHorizontalCenter - labelAnimation.value,
          top: iconAnimation.value,
          child: iconWidget(height, width),
        );
      } else if (widget.labelDirection == SplashScreenDirection.RTL) {
        return Positioned(
          left: !completed
              ? screenHorizontalCenter
              : screenHorizontalCenter + labelAnimation.value,
          top: iconAnimation.value,
          child: iconWidget(height, width),
        );
      } else if (widget.labelDirection == SplashScreenDirection.TTB) {
        return Positioned(
          left: screenHorizontalCenter,
          top: !completed
              ? iconAnimation.value
              : screenVerticalCenter - labelAnimation.value,
          child: iconWidget(height, width),
        );
      } else if (widget.labelDirection == SplashScreenDirection.BTT) {
        return Positioned(
          left: screenHorizontalCenter,
          top: !completed
              ? iconAnimation.value
              : screenVerticalCenter + labelAnimation.value,
          child: iconWidget(height, width),
        );
      }
    } else if (widget.iconDirection == SplashScreenDirection.LTR) {
      if (widget.labelDirection == SplashScreenDirection.LTR) {
        return Positioned(
          left: !completed
              ? iconAnimation.value
              : screenHorizontalCenter - labelAnimation.value,
          top: screenVerticalCenter,
          child: iconWidget(height, width),
        );
      } else if (widget.labelDirection == SplashScreenDirection.RTL) {
        return Positioned(
          left: !completed
              ? iconAnimation.value
              : screenHorizontalCenter + labelAnimation.value,
          top: screenVerticalCenter,
          child: iconWidget(height, width),
        );
      } else if (widget.labelDirection == SplashScreenDirection.TTB) {
        return Positioned(
          left: iconAnimation.value,
          top: !completed
              ? screenVerticalCenter
              : screenVerticalCenter - labelAnimation.value,
          child: iconWidget(height, width),
        );
      } else if (widget.labelDirection == SplashScreenDirection.BTT) {
        return Positioned(
          left: iconAnimation.value,
          top: !completed
              ? screenVerticalCenter
              : screenVerticalCenter + labelAnimation.value,
          child: iconWidget(height, width),
        );
      }
    } else if (widget.iconDirection == SplashScreenDirection.RTL) {
      if (widget.labelDirection == SplashScreenDirection.LTR) {
        return Positioned(
          left: !completed
              ? iconAnimation.value
              : screenHorizontalCenter - labelAnimation.value,
          top: screenVerticalCenter,
          child: iconWidget(height, width),
        );
      } else if (widget.labelDirection == SplashScreenDirection.RTL) {
        return Positioned(
          left: !completed
              ? iconAnimation.value
              : screenHorizontalCenter + labelAnimation.value,
          top: screenVerticalCenter,
          child: iconWidget(height, width),
        );
      } else if (widget.labelDirection == SplashScreenDirection.TTB) {
        return Positioned(
          left: iconAnimation.value,
          top: !completed
              ? screenVerticalCenter
              : screenVerticalCenter - labelAnimation.value,
          child: iconWidget(height, width),
        );
      } else if (widget.labelDirection == SplashScreenDirection.BTT) {
        return Positioned(
          left: iconAnimation.value,
          top: !completed
              ? screenVerticalCenter
              : screenVerticalCenter + labelAnimation.value,
          child: iconWidget(height, width),
        );
      }
    }
  }

  /// Returns the widget which contains [icon]
  Container iconWidget(double h, double w) {
    return Container(
      key: iconKey,
      constraints: BoxConstraints(
        minHeight: max(h, w) * 0.1,
        minWidth: max(h, w) * 0.1,
      ),
      color: widget.backgroundColor ?? Colors.white,
      child: this.widget.icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = getWidth(context);
    double height = getHeight(context);

    if (!initAnimation) {
      initAnimation = true;
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
                bottom: height * pBottomPercent * 0.01 * 0.01,
                left: width * pRightPercent * 0.5 * 0.01,
                child: AnimatedCrossFade(
                  duration: Duration(milliseconds: 800),
                  firstChild: this.widget.screenLoader == null
                      ? SizedBox(
                          height: max(width, height) * 0.1,
                          width: max(width, height) * 0.1,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : this.widget.screenLoader,
                  secondChild: SizedBox(
                    height: max(width, height) * 0.1,
                    width: max(width, height) * 0.1,
                  ),
                  crossFadeState: loading
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                ),
              ),
              !widget.onlyIcon ? getWidget1(width, height) : SizedBox.shrink(),
              getWidget2(width, height),
            ],
          ),
        ),
      ),
    );
  }
}
