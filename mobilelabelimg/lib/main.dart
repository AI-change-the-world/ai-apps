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
import 'package:mobilelabelimg/tests/drag_scale.dart';
import 'package:mobilelabelimg/tests/scale_demo.dart';
import 'package:mobilelabelimg/widgets/rect.dart';
import 'package:mobilelabelimg/workboard/views/workboard_demo.dart';

void main() {
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Demoview(),
  ));
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RectDemo(),
    );
  }
}

class RectDemo extends StatelessWidget {
  const RectDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        RectBox(
          id: 0,
        ),
      ],
    );
  }
}
