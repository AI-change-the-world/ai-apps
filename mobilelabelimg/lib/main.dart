/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2021-07-08 19:14:07
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2021-07-18 21:16:49
 */
import 'package:flutter/material.dart';
import 'package:mobilelabelimg/main_page.dart';
import 'package:mobilelabelimg/utils/routers.dart';
import 'package:mobilelabelimg/widgets/polygon.dart';
import 'package:mobilelabelimg/workboard/views/labelme_workboard_demo.dart';
// import 'package:mobilelabelimg/tests/drag_scale.dart';
// import 'package:mobilelabelimg/tests/scale_demo.dart';
// import 'package:mobilelabelimg/widgets/rect.dart';
// import 'package:mobilelabelimg/workboard/views/workboard_demo.dart';

void main() {
  runApp(new MaterialApp(
    routes: Routers.routers,
    debugShowCheckedModeBanner: false,
    // home: MainPage(),
    home: Polygon(),
  ));
}
