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
import 'package:mobilelabelimg/widgets/rect.dart';

void main() {
  runApp(new MaterialApp(
    home: MyApp(),
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
    return SafeArea(
        child: Stack(
      children: [
        RectBox(
          id: 0,
        ),
      ],
    ));
  }
}
