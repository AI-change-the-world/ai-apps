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

const welcomeStr = "自零伊始，於壹而终";

const templeteJson = <String, dynamic>{
  "url": "一个完整有效的url",
  "params": {"param1": "类型", "param2": "类型", "...": "类型"},
  "json": {"param1": "类型", "param2": "类型", "...": "类型"}
};

class CommonUtils {
  /// 获取屏幕大小
  static MediaQueryData mediaQuery = MediaQueryData.fromWindow(_ui.window);
  static final double _width = mediaQuery.size.width;
  static final double _height = mediaQuery.size.height;

  static screenW() {
    return _width;
  }

  static screenH() {
    return _height;
  }
}

class Responsive {
// This size work fine on my design, maybe you need some customization depends on your design

  // This isMobile, isTablet, isDesktop helep us later
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 850;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width < 1100 &&
      MediaQuery.of(context).size.width >= 850;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1100;
}
