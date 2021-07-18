/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2021-07-16 19:11:57
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2021-07-18 21:23:19
 */

import 'package:flutter/material.dart';

part './points.dart';

const circleSize = 30.0;
const defaultRectSize = 300.0;

class RectBox extends StatelessWidget {
  int id;
  RectBox({Key? key, required this.id}) : super(key: key);

  GlobalKey<_PointState> topLeftKey = GlobalKey(debugLabel: "topLeftKey");
  GlobalKey<_PointState> topRightKey = GlobalKey(debugLabel: "topRightKey");
  GlobalKey<_PointState> bottomLeftKey = GlobalKey(debugLabel: "bottomLeftKey");
  GlobalKey<_PointState> bottomRightKey =
      GlobalKey(debugLabel: "bottomRightKey");
  GlobalKey<_RectState> rectKey = GlobalKey(debugLabel: "rectKey");

  @override
  Widget build(BuildContext context) {
    return Rect(
      key: rectKey,
      globalKeys: [topLeftKey, topRightKey, bottomLeftKey, bottomRightKey],
    );
  }
}

class Rect extends StatefulWidget {
  List<GlobalKey> globalKeys;
  Rect({Key? key, required this.globalKeys}) : super(key: key);

  @override
  _RectState createState() => _RectState();
}

class _RectState extends State<Rect> {
  double height = defaultRectSize;
  double width = defaultRectSize;

  double defaultLeft = 0;
  double defaultTop = 0;

  var topLeftKey;
  var topRightKey;
  var bottomLeftKey;
  var bottomRightKey;

  List<double> getRectBox() {
    return [];
  }

  @override
  void initState() {
    super.initState();
    topLeftKey = widget.globalKeys[0];
    topRightKey = widget.globalKeys[1];
    bottomLeftKey = widget.globalKeys[2];
    bottomRightKey = widget.globalKeys[3];
  }

  setHeight(double height) {
    setState(() {
      this.height = height;
      // this.defaultTop = _top;
    });
  }

  setWidth(double width) {
    setState(() {
      this.width = width;
      // this.defaultLeft = _left;
    });
  }

  setTop(double top) {
    setState(() {
      this.defaultTop = top;
    });
  }

  setLeft(double left) {
    setState(() {
      this.defaultLeft = left;
    });
  }

  moveTo(Offset? _off) {
    setState(() {
      if (null != _off) {
        this.defaultLeft = _off.dx;
        this.defaultTop = _off.dy;
      } else {
        this.defaultLeft = topLeftKey.currentState!.offset.dx;
        this.defaultTop = topLeftKey.currentState!.offset.dy;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: defaultLeft,
        top: defaultTop,
        child: Draggable(
            onDraggableCanceled: (velocity, offset) {
              setState(() {
                this.defaultLeft = offset.dx;
                this.defaultTop = offset.dy;
                topLeftKey.currentState!.offset = offset;
                topRightKey.currentState!.offset =
                    Offset(offset.dx - circleSize + width, offset.dy);
                bottomLeftKey.currentState!.offset =
                    Offset(offset.dx, offset.dy - circleSize + height);
                bottomRightKey.currentState!.offset = Offset(
                    offset.dx - circleSize + width,
                    offset.dy - circleSize + height);
              });
            },
            child: Container(
              // margin: EdgeInsets.only(top: 100, left: 50),
              height: height,
              width: width,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 0.5),
                color: Colors.transparent,
              ),
              child: Stack(
                children: [
                  getPoint(0, topLeftKey),
                  getPoint(1, topRightKey),
                  getPoint(2, bottomLeftKey),
                  getPoint(3, bottomRightKey),
                ],
              ),
            ),
            feedback: Container(
              color: Colors.green,
              height: height,
              width: width,
            )));
  }

  Widget getPoint(int position, GlobalKey key) {
    late Widget p;
    switch (position) {
      case 0: // top left
        p = Point(
          key: key,
          color: Colors.red,
          woffset: Offset(defaultLeft, defaultTop),
          globalKeys: widget.globalKeys,
          rectKey: widget.key as GlobalKey<_RectState>,
        );
        break;
      case 1: // top right
        p = Point(
          key: key,
          color: Colors.green,
          woffset:
              Offset(defaultRectSize - circleSize + defaultLeft, defaultTop),
          globalKeys: widget.globalKeys,
          rectKey: widget.key as GlobalKey<_RectState>,
        );
        break;
      case 2:
        p = Point(
          key: key,
          color: Colors.blue,
          woffset:
              Offset(defaultLeft, defaultRectSize - circleSize + defaultTop),
          globalKeys: widget.globalKeys,
          rectKey: widget.key as GlobalKey<_RectState>,
        );
        break;
      case 3:
        p = Point(
          key: key,
          color: Colors.black,
          woffset: Offset(defaultRectSize - circleSize + defaultLeft,
              defaultRectSize - circleSize + defaultTop),
          globalKeys: widget.globalKeys,
          rectKey: widget.key as GlobalKey<_RectState>,
        );
        break;
      default:
        p = Point(
          key: key,
          color: Colors.red,
          woffset: Offset(0, 0),
          globalKeys: widget.globalKeys,
          rectKey: widget.key as GlobalKey<_RectState>,
        );
        break;
    }
    return p;
  }
}
