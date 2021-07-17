import 'package:flutter/material.dart';

const circleSize = 30.0;
const defaultRectSize = 300.0;

GlobalKey<_PointState> topLeftKey = GlobalKey(debugLabel: "topLeftKey");
GlobalKey<_PointState> topRightKey = GlobalKey(debugLabel: "topRightKey");
GlobalKey<_PointState> bottomLeftKey = GlobalKey(debugLabel: "bottomLeftKey");
GlobalKey<_PointState> bottomRightKey = GlobalKey(debugLabel: "bottomRightKey");
GlobalKey<_RectState> rectKey = GlobalKey(debugLabel: "rectKey");

class RectDemo extends StatelessWidget {
  const RectDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Stack(
      children: [
        Rect(
          key: rectKey,
        )
      ],
    ));
  }
}

class Rect extends StatefulWidget {
  Rect({Key? key}) : super(key: key);

  @override
  _RectState createState() => _RectState();
}

class _RectState extends State<Rect> {
  double height = defaultRectSize;
  double width = defaultRectSize;

  double defaultLeft = 0;
  double defaultTop = 0;

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

  moveTo() {
    setState(() {
      this.defaultLeft = topLeftKey.currentState!.offset.dx;
      this.defaultTop = topLeftKey.currentState!.offset.dy;
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
            offset: Offset(defaultLeft, defaultTop));
        break;
      case 1: // top right
        p = Point(
            key: key,
            color: Colors.green,
            offset:
                Offset(defaultRectSize - circleSize + defaultLeft, defaultTop));
        break;
      case 2:
        p = Point(
            key: key,
            color: Colors.blue,
            offset:
                Offset(defaultLeft, defaultRectSize - circleSize + defaultTop));
        break;
      case 3:
        p = Point(
            key: key,
            color: Colors.black,
            offset: Offset(defaultRectSize - circleSize + defaultLeft,
                defaultRectSize - circleSize + defaultTop));
        break;
      default:
        p = Point(key: key, color: Colors.red, offset: Offset(0, 0));
        break;
    }
    return p;
  }
}

// ignore: must_be_immutable
class Point extends StatefulWidget {
  Point({required Key key, required this.color, required this.offset})
      : super(key: key);

  Color color;
  Offset offset;

  @override
  _PointState createState() => _PointState();
}

class _PointState extends State<Point> {
  late Offset offset;

  double _left = 0;
  double _top = 0;

  @override
  void initState() {
    super.initState();
    offset = widget.offset;

    if (widget.key == topRightKey) {
      _left = rectKey.currentState!.width - circleSize;
    }

    if (widget.key == bottomLeftKey) {
      _top = rectKey.currentState!.height - circleSize;
    }

    if (widget.key == bottomRightKey) {
      _top = rectKey.currentState!.height - circleSize;
      _left = rectKey.currentState!.width - circleSize;
    }
    // print(this.offset);
  }

  moveTO(Offset offset, {bool b = true}) {
    // print(offset);
    setState(() {
      this.offset = offset;
      if (b) {
        _left = offset.dx - rectKey.currentState!.defaultLeft;
        _top = offset.dy - rectKey.currentState!.defaultTop;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: _left,
        top: _top,
        child: Draggable(
            onDraggableCanceled: (Velocity velocity, Offset offset) {
              this.moveTO(offset);

              // if (widget.key == topLeftKey) {
              //   topRightKey.currentState!.offset = Offset(offset.dx, offset.dy);
              // }

              late double width;
              late double height;

              if (widget.key == topLeftKey) {
                width = (topLeftKey.currentState!.offset.dx -
                        circleSize -
                        topRightKey.currentState!.offset.dx)
                    .abs();

                height = (topLeftKey.currentState!.offset.dy -
                        circleSize -
                        bottomLeftKey.currentState!.offset.dy)
                    .abs();
              } else if (widget.key == topRightKey) {
                width = (topLeftKey.currentState!.offset.dx -
                        circleSize -
                        topRightKey.currentState!.offset.dx)
                    .abs();

                height = (topRightKey.currentState!.offset.dy -
                        circleSize -
                        bottomRightKey.currentState!.offset.dy)
                    .abs();
                rectKey.currentState!.setTop(widget.offset.dy);
              } else if (widget.key == bottomLeftKey) {
                width = (bottomLeftKey.currentState!.offset.dx -
                        circleSize -
                        bottomRightKey.currentState!.offset.dx)
                    .abs();

                height = (bottomLeftKey.currentState!.offset.dy -
                        circleSize -
                        topLeftKey.currentState!.offset.dy)
                    .abs();
              } else {
                width = (bottomRightKey.currentState!.offset.dx +
                        circleSize -
                        topLeftKey.currentState!.offset.dx)
                    .abs();

                height = (bottomRightKey.currentState!.offset.dy +
                        circleSize -
                        topLeftKey.currentState!.offset.dy)
                    .abs();
              }

              // print("=============");
              // print(width);
              // print(height);
              // print("=============");

              rectKey.currentState!.moveTo();

              rectKey.currentState!.setHeight(height);
              rectKey.currentState!.setWidth(width);

              topLeftKey.currentState!._left = 0;
              topLeftKey.currentState!._top = 0;

              topRightKey.currentState!._left = width - circleSize;
              topRightKey.currentState!._top = 0;

              bottomLeftKey.currentState!._left = 0;
              bottomLeftKey.currentState!._top = height - circleSize;

              bottomRightKey.currentState!._left = width - circleSize;
              bottomRightKey.currentState!._top = height - circleSize;
            },
            feedback: Container(
                width: circleSize,
                height: circleSize,
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(150),
                    border: new Border.all(color: widget.color, width: 0.5))),
            child: Container(
                width: circleSize,
                height: circleSize,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(150),
                  border: new Border.all(color: widget.color, width: 0.5),
                ))));
  }
}
