import 'dart:math';

import 'package:flutter/material.dart';
import 'functions.dart';

class ScaleSplashScreen extends StatefulWidget {
  /// ScaleSplashScreen

  /// [onlyIcon] represents if only icon is to be show on splashScreen .
  final bool onlyIcon;

  /// [icon] represents the application icon .
  final Widget icon;

  /// [iconScaleDuration] represents duration for which icon would animate .
  final Duration iconScaleDuration;

  /// [reverseIconScale] represents if animation icon Scaling should be reversed .
  ///
  /// @Default is Duration(seconds:2) .
  final bool reverseIconScale;

  /// [label] represents text .
  final String label;

  /// [labelDirection] represents direction in which label would animate .
  ///
  /// @Default is SplashScreenDirection.LTR
  final SplashScreenDirection labelDirection;

  /// [labelDuration] represents duration for which label would animate .
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
  ScaleSplashScreen({
    @required this.icon,
    this.labelDirection: SplashScreenDirection.LTR,
    this.iconScaleDuration: const Duration(seconds: 2),
    this.labelDuration: const Duration(seconds: 2),
    this.label: '',
    @required this.navigateTo,
    this.onlyIcon: false,
    this.screenFunction,
    this.labelStyle,
    this.screenLoader,
    this.reverseIconScale: false,
    this.splashPageTransistion,
    this.pageTransistionDuration,
    this.backgroundColor,
  }) : assert(icon != null &&
            navigateTo != null &&
            ((splashPageTransistion == null &&
                    pageTransistionDuration == null) ||
                (splashPageTransistion != null &&
                    pageTransistionDuration != null)));
  @override
  _ScaleSplashScreenState createState() => _ScaleSplashScreenState();
}

class _ScaleSplashScreenState extends State<ScaleSplashScreen>
    with TickerProviderStateMixin {
  /// [scaleController] animates icon through scaleAnimation .
  ///
  /// scales Icon according for duration given by [iconScaleDuration]
  AnimationController scaleController;
  Animation<double> scaleAnimation;

  /// [iconKey] derives the position of icon properties such as height and width .
  final iconKey = GlobalKey();

  /// [labelAnimationController] animates label in the direction specified by [labelDirection] .
  AnimationController labelAnimationController;
  Animation<double> labelAnimation;

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
        labelAnimation = getAnimation(screenWidth, screenHeight);
      }
      setState(() {});
    });

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

    /// listener added for [scaleAnimation]
    scaleAnimation.addListener(() async {
      if (scaleAnimation.isCompleted) {
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
            if (widget.reverseIconScale != null && widget.reverseIconScale) {
              await scaleController.reverse().whenComplete(() {
                navigateToPage(context, widget.pageTransistionDuration,
                    widget.splashPageTransistion, widget.navigateTo);
              });
            } else {
              navigateToPage(context, widget.pageTransistionDuration,
                  widget.splashPageTransistion, widget.navigateTo);
            }
          }
        } else {
          completed = true;
          labelAnimationController.forward();
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
    double halfIconWidth = iconWidth * 0.5;
    double val1 = halfIconWidth * 1.5;
    double halfIconHeight = iconHeight * 0.5;
    double val2 = halfIconHeight * 1.5;
    if (widget.labelDirection == SplashScreenDirection.LTR) {
      return Tween<double>(begin: 0, end: val1)
          .animate(labelAnimationController);
    } else if (widget.labelDirection == SplashScreenDirection.RTL) {
      return Tween<double>(begin: 0, end: val1)
          .animate(labelAnimationController);
    } else if (widget.labelDirection == SplashScreenDirection.TTB) {
      return Tween<double>(begin: 0, end: val2)
          .animate(labelAnimationController);
    } else if (widget.labelDirection == SplashScreenDirection.BTT) {
      return Tween<double>(begin: 0, end: val2)
          .animate(labelAnimationController);
    }
  }

  getWidget1(double w, double h) {
    double screenHorizontalCenter = w * endRightPercent * 0.01 * 0.5;
    double screenVerticalCenter = h * endBottomPercent * 0.01 * 0.5;
    if (widget.labelDirection == SplashScreenDirection.LTR) {
      return Positioned(
        left: !completed
            ? screenHorizontalCenter
            : screenHorizontalCenter + labelAnimation.value,
        top: screenVerticalCenter,
        child: labelWidget(h, w),
      );
    } else if (widget.labelDirection == SplashScreenDirection.RTL) {
      return Positioned(
        left: !completed
            ? screenHorizontalCenter
            : screenHorizontalCenter - labelAnimation.value,
        top: screenVerticalCenter,
        child: labelWidget(h, w),
      );
    } else if (widget.labelDirection == SplashScreenDirection.TTB) {
      return Positioned(
        left: screenHorizontalCenter,
        top: screenVerticalCenter + labelAnimation.value,
        child: labelWidget(h, w),
      );
    } else if (widget.labelDirection == SplashScreenDirection.BTT) {
      return Positioned(
        left: screenHorizontalCenter,
        top: screenVerticalCenter - labelAnimation.value,
        child: labelWidget(h, w),
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

  getWidget2(double w, double h) {
    double screenHorizontalCenter = w * endRightPercent * 0.01 * 0.5;
    double screenVerticalCenter = h * endBottomPercent * 0.01 * 0.5;
    if (widget.labelDirection == SplashScreenDirection.LTR) {
      return Positioned(
        left: !completed
            ? screenHorizontalCenter
            : screenHorizontalCenter - labelAnimation.value,
        top: screenVerticalCenter,
        child: iconWidget(h, w),
      );
    } else if (widget.labelDirection == SplashScreenDirection.RTL) {
      return Positioned(
        left: !completed
            ? screenHorizontalCenter
            : screenHorizontalCenter + labelAnimation.value,
        top: screenVerticalCenter,
        child: iconWidget(h, w),
      );
    } else if (widget.labelDirection == SplashScreenDirection.TTB) {
      return Positioned(
        left: screenHorizontalCenter,
        top: screenVerticalCenter - labelAnimation.value,
        child: iconWidget(h, w),
      );
    } else if (widget.labelDirection == SplashScreenDirection.BTT) {
      return Positioned(
        left: screenHorizontalCenter,
        top: screenVerticalCenter + labelAnimation.value,
        child: iconWidget(h, w),
      );
    }
  }

  /// Returns the widget which contains [icon]
  Transform iconWidget(double h, double w) {
    return Transform.scale(
      scale: scaleAnimation.value,
      child: Container(
        key: iconKey,
        constraints: BoxConstraints(
          minHeight: max(h, w) * 0.1,
          minWidth: max(h, w) * 0.1,
        ),
        color: widget.backgroundColor ?? Colors.white,
        child: this.widget.icon,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = getWidth(context);
    double height = getHeight(context);

    if (!initAnimation) {
      initAnimation = true;
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
