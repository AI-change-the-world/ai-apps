/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2021-07-31 20:06:45
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2021-08-17 20:34:16
 */
import 'package:flutter/material.dart';
import 'package:mobilelabelimg/main_page_v1.dart';
import 'package:mobilelabelimg/widgets/polygon.dart';
import 'package:mobilelabelimg/workboard/views/labelimg_opening_view.dart';
import 'package:mobilelabelimg/workboard/views/multi_images_workboard.dart';
import 'package:mobilelabelimg/workboard/views/single_image_workboard.dart';
// import 'package:mobilelabelimg/workboard/views/workboard_demo.dart';

class Routers {
  static final pageAnnotationWorkboard = "pageAnnotationWorkboard";
  static final pageMultiAnnotationWorkboard = "pageMultiAnnotationWorkboard";
  static final pageMain = "pageMain";
  static final pageLabelimgMain = "pageLabelimgMain";
  static final pagePolygonPage = "pagePolygonPage";

  static final Map<String, WidgetBuilder> routers = {
    pageAnnotationWorkboard: (ctx) => SingleImageAnnotationPage(),
    pageMultiAnnotationWorkboard: (ctx) => MultiImageAnnotationPage(),
    // pageAnnotationWorkboard: (ctx) => DragDemo(),
    pageMain: (ctx) => MainPageV1(),
    pageLabelimgMain: (ctx) => LabelImgOpenningPage(),
    pagePolygonPage: (ctx) => PolygonDemoPage()
  };
}
