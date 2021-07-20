import 'package:flutter/material.dart';
import "dart:ui" as _ui;

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
