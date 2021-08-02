import 'package:flutter/material.dart';
import "dart:ui" as _ui;

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
