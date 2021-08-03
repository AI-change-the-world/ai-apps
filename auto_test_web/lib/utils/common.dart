/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2021-08-02 18:51:44
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2021-08-02 19:29:09
 */
import 'package:flutter/material.dart';
import "dart:ui" as _ui;

const primaryColor = Color(0xFF2697FF);
const secondaryColor = Color(0xFF2A2D3E);
const bgColor = Color(0xFF212332);

const defaultPadding = 16.0;

class CommonUtils {
  /// 获取屏幕大小
  static MediaQueryData mediaQuery = MediaQueryData.fromWindow(_ui.window);
  static double _width = mediaQuery.size.width;
  static double _height = mediaQuery.size.height;

  static screenW() {
    return _width;
  }

  static screenH() {
    return _height;
  }
}

class Responsive {
  // final Widget mobile;
  // final Widget? tablet;
  // final Widget desktop;

  // const Responsive({
  //   Key? key,
  //   required this.mobile,
  //   this.tablet,
  //   required this.desktop,
  // }) : super(key: key);

// This size work fine on my design, maybe you need some customization depends on your design

  // This isMobile, isTablet, isDesktop helep us later
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 850;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width < 1100 &&
      MediaQuery.of(context).size.width >= 850;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1100;

  // @override
  // Widget build(BuildContext context) {
  //   final Size _size = MediaQuery.of(context).size;
  //   // If our width is more than 1100 then we consider it a desktop
  //   if (_size.width >= 1100) {
  //     return desktop;
  //   }
  //   // If width it less then 1100 and more then 850 we consider it as tablet
  //   else if (_size.width >= 850 && tablet != null) {
  //     return tablet!;
  //   }
  //   // Or less then that we called it mobile
  //   else {
  //     return mobile;
  //   }
  // }
}
