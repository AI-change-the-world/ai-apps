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
import 'package:mobilelabelimg/policy_page.dart';
import 'package:mobilelabelimg/widgets/polygon.dart';
import 'package:mobilelabelimg/workboard/views/labelimg_opening_view.dart';
import 'package:mobilelabelimg/workboard/views/labelme_opening_view.dart';
import 'package:mobilelabelimg/workboard/views/multi_images_workboard.dart';
import 'package:mobilelabelimg/workboard/views/single_image_workboard.dart';
// import 'package:mobilelabelimg/workboard/views/workboard_demo.dart';

class Routers {
  static const pageAnnotationWorkboard = "pageAnnotationWorkboard";
  static const pageMultiAnnotationWorkboard = "pageMultiAnnotationWorkboard";
  static const pageMain = "pageMain";
  static const pageLabelimgMain = "pageLabelimgMain";
  static const pagePolygonPage = "pagePolygonPage";
  static const pageLabelmeMain = "pageLabelmeMain";
  static const policyPage = "policyPage";

  static final Map<String, WidgetBuilder> routers = {
    pageAnnotationWorkboard: (ctx) => const SingleImageAnnotationPage(),
    pageMultiAnnotationWorkboard: (ctx) => const MultiImageAnnotationPage(),
    pageMain: (ctx) => const MainPageV1(),
    pageLabelimgMain: (ctx) => const LabelImgOpenningPage(),
    pagePolygonPage: (ctx) => const PolygonDemoPage(),
    pageLabelmeMain: (ctx) => const LabelmeOpenningPage(),
    policyPage: (ctx) => PolicyPage(withTitle: true),
  };
}
