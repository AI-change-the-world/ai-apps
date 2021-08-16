/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2021-08-16 19:01:24
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2021-08-16 22:30:32
 */
import 'package:flutter/material.dart';
import 'package:mobilelabelimg/widgets/polygon.dart';
import 'package:provider/provider.dart';

class PolygonWorkboard extends StatelessWidget {
  const PolygonWorkboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        child: Scaffold(
          body: PolygonDemoPage(),
        ),
        providers: [
          ChangeNotifierProvider(create: (_) => DrawingProvicer()),
          ChangeNotifierProvider(create: (_) => MovePolygonProvider()),
        ]);
  }
}
