import 'package:auto_test_web/pages/main/sidebar_demo.dart';
import 'package:auto_test_web/routers.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    routes: Routers.routers,
    // initialRoute: Routers.pageLogin,
    home: MyHomePage(),
  ));
}
