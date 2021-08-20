/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2021-07-31 20:06:45
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2021-08-17 20:19:20
 */
import 'package:flutter/material.dart';
import "dart:ui" as _ui;

import 'package:shared_preferences/shared_preferences.dart';

const circleSize = 30.0;
const defaultRectSize = 300.0;
const titleHeight = 0.0;
const buttonSize = 60.0;
const labelmeVersion = "4.2.9";
const labelmeShapeType = "polygon";

const appname = "移动端标注工具";

class CommonUtil {
  /// 获取屏幕大小
  static MediaQueryData mediaQuery = MediaQueryData.fromWindow(_ui.window);
  static double _width = mediaQuery.size.width;
  static double _height = mediaQuery.size.height;
  static double screenW() {
    return _width;
  }

  static double screenH() {
    return _height;
  }

  /// 字体样式
  static TextStyle fontStyle = TextStyle(fontWeight: FontWeight.bold);

  static TextStyle jobNameStyle =
      TextStyle(fontSize: 17, fontWeight: FontWeight.bold);
}

Future<bool> checkFirstLogin() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? _isFirstStartApp = prefs.getBool("isFirstStartApp");
  if (null == _isFirstStartApp) {
    _isFirstStartApp = true;
  }
  return _isFirstStartApp;
}

Future<bool> checkPolicyAgreed() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? _agreed = prefs.getBool("agreed");
  if (null == _agreed) {
    _agreed = false;
  }
  return _agreed;
}

Future setPolicyAgreed() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // bool _agreed = prefs.getBool("agreed");
  await prefs.setBool("agreed", true);
}
