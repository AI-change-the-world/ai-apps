/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2021-07-31 19:39:25
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2021-08-03 20:22:31
 */

import 'package:auto_test_web/routers.dart';
import 'package:auto_test_web/utils/common.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

// ignore: use_key_in_widget_constructors
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: Routers.routers,
      debugShowCheckedModeBanner: false,
      title: 'I0 Testing Platform' + versionCode,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: bgColor,
        canvasColor: secondaryColor,
      ),
      initialRoute: Routers.pageLogin,
    );
  }
}
