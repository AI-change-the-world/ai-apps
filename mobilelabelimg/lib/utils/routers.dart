import 'package:flutter/material.dart';
import 'package:mobilelabelimg/main_page.dart';
import 'package:mobilelabelimg/workboard/views/single_image_workboard.dart';
// import 'package:mobilelabelimg/workboard/views/workboard_demo.dart';

class Routers {
  static final pageAnnotationWorkboard = "pageAnnotationWorkboard";
  static final pageMain = "pageMain";

  static final Map<String, WidgetBuilder> routers = {
    pageAnnotationWorkboard: (ctx) => SingleImageAnnotationPage(),
    // pageAnnotationWorkboard: (ctx) => DragDemo(),
    pageMain: (ctx) => MainPage(),
  };
}
