/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2021-07-08 19:14:07
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2021-08-17 20:23:56
 */
import 'package:flutter/material.dart';
import 'package:mobilelabelimg/launch_page_v1.dart';
import 'package:mobilelabelimg/utils/routers.dart';

void main() {
  runApp(MaterialApp(
    routes: Routers.routers,
    debugShowCheckedModeBanner: false,
    // home: PolygonWorkboard(),
    // initialRoute: Routers.pageMain,
    home: const LaunchPage(),
    // home: TestPage(),
  ));
}
