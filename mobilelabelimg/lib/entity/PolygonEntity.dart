import 'package:flutter/material.dart';
import 'package:mobilelabelimg/widgets/polygon_points.dart';

class PolygonEntity {
  List<PolygonPoint> pList;
  List<GlobalKey<PolygonPointState>> keyList;
  String className;
  int index;
  PolygonEntity(
      {required this.pList,
      required this.keyList,
      required this.className,
      required this.index});
}
