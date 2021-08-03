/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2021-07-31 19:39:25
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2021-08-02 19:30:37
 */
import 'package:auto_test_web/pages/main/main_page_demo.dart';
import 'package:auto_test_web/pages/main/main_page_provider.dart';
import 'package:auto_test_web/routers.dart';
import 'package:auto_test_web/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Admin Panel',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: bgColor,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
            .apply(bodyColor: Colors.white),
        canvasColor: secondaryColor,
      ),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => MenuController(),
          ),
          ChangeNotifierProvider(
            create: (context) => ListTabsController(),
          ),
          ChangeNotifierProvider(
            create: (context) => CenterWidgetController(),
          ),
        ],
        child: MainPageDemo(),
      ),
    );
  }
}
