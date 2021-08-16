import 'package:flutter/material.dart';
import "dart:ui" as _ui;

const circleSize = 30.0;
const defaultRectSize = 300.0;
const titleHeight = 0.0;
const buttonSize = 60.0;

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
}
