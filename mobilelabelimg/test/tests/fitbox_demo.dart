/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2021-07-18 20:48:31
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2021-07-18 21:21:47
 */
import 'package:flutter/material.dart';

class FitboxDemo extends StatelessWidget {
  const FitboxDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "FittedBox缩放布局",
      home: Scaffold(
          appBar: AppBar(
            title: const Text('FittedBox缩放布局'),
          ),
          body: Container(
            color: Colors.grey,
            width: 250,
            height: 250,

            //缩放布局
            child: FittedBox(
              fit: BoxFit.contain,
              //对亲属性
              alignment: Alignment.topLeft,

              child: Container(
                color: Colors.lightBlue,
                child: const Text('还有谁'),
              ),
            ),
          )),
    );
  }
}
