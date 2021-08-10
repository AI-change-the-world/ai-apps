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

const versionCode = " v.alpha-1";

const templeteJson = <String, dynamic>{
  "params": {"param1": "类型", "param2": "类型", "...": "如果不是预设类型，则默认认为是不可变数据"},
  "json": {"param1": "类型", "param2": "类型", "...": "如果不是预设类型，则默认认为是不可变数据"},
  "boundries": {"param___eq": "value", "...": "三个下划线是分割符，前面是参数名，后面是关系，value是值"},
  "method": "value"
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
