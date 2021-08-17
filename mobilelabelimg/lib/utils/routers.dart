import 'package:flutter/material.dart';
import 'package:mobilelabelimg/main_page.dart';
import 'package:mobilelabelimg/workboard/views/labelimg_opening_view.dart';
import 'package:mobilelabelimg/workboard/views/multi_images_workboard.dart';
import 'package:mobilelabelimg/workboard/views/single_image_workboard.dart';
// import 'package:mobilelabelimg/workboard/views/workboard_demo.dart';

class Routers {
  static final pageAnnotationWorkboard = "pageAnnotationWorkboard";
  static final pageMultiAnnotationWorkboard = "pageMultiAnnotationWorkboard";
  static final pageMain = "pageMain";
  static final pageLabelimgMain = "pageLabelimgMain";

  static final Map<String, WidgetBuilder> routers = {
    pageAnnotationWorkboard: (ctx) => SingleImageAnnotationPage(),
    pageMultiAnnotationWorkboard: (ctx) => MultiImageAnnotationPage(),
    // pageAnnotationWorkboard: (ctx) => DragDemo(),
    pageMain: (ctx) => MainPage(),
    pageLabelimgMain: (ctx) => LabelImgOpenningPage(),
  };
}
