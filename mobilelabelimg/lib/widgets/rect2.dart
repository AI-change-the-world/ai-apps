import 'package:flutter/material.dart';

const circleSize = 30.0;

GlobalKey<_PointState> topLeftKey = GlobalKey(debugLabel: "topLeftKey");
GlobalKey<_PointState> topRightKey = GlobalKey(debugLabel: "topRightKey");
GlobalKey<_PointState> bottomLeftKey = GlobalKey(debugLabel: "bottomLeftKey");
GlobalKey<_PointState> bottomRightKey = GlobalKey(debugLabel: "bottomRightKey");
GlobalKey<_RectState> rectKey = GlobalKey(debugLabel: "rectKey");

class RectDemo extends StatelessWidget {
  const RectDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Rect(
          key: rectKey,
        )
      ],
    );
  }
}

class Rect extends StatefulWidget {
  Rect({Key? key}) : super(key: key);

  @override
  _RectState createState() => _RectState();
}

class _RectState extends State<Rect> {
  double height = 300;
  double width = 300;

  double defaultLeft = 0;
  double defaultTop = 0;

  setHeight(double height, double _top) {
    setState(() {
      this.height = height;
      // this.defaultTop = _top;
    });
  }

  setWidth(double width, double _left) {
    setState(() {
      this.width = width;
      // this.defaultLeft = _left;
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
                topLeftKey.currentState!.offset =
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
            offset: Offset(300 - circleSize + defaultLeft, defaultTop));
        break;
      case 2:
        p = Point(
            key: key,
            color: Colors.blue,
            offset: Offset(defaultLeft, 300 - circleSize + defaultTop));
        break;
      case 3:
        p = Point(
            key: key,
            color: Colors.black,
            offset: Offset(
                300 - circleSize + defaultLeft, 300 - circleSize + defaultTop));
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

  moveTO(Offset offset) {
    print(offset);
    setState(() {
      this.offset = offset;
      _left = offset.dx - rectKey.currentState!.defaultLeft;
      _top = offset.dy - rectKey.currentState!.defaultTop;
    });
  }

  // dxMoveTo(double pos) {
  //   setState(() {
  //     _left = pos;
  //   });
  // }

  // dyMoveTo(double pos) {
  //   setState(() {
  //     _top = pos;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: _left,
        top: _top,
        child: Draggable(
            onDraggableCanceled: (Velocity velocity, Offset offset) {
              this.moveTO(offset);

              double width = (topLeftKey.currentState!.offset.dx -
                      topRightKey.currentState!.offset.dx)
                  .abs();

              double height = (topLeftKey.currentState!.offset.dy -
                      bottomLeftKey.currentState!.offset.dy)
                  .abs();

              // print(width);
              // print(height);

              // rectKey.currentState!.setHeight(height, height);
              // rectKey.currentState!.setWidth(width, width);

              rectKey.currentState!.moveTo();

              // if (widget.key == topLeftKey) {
              //   topRightKey.currentState!.dyMoveTo(this.offset.dy);
              //   bottomLeftKey.currentState!.dxMoveTo(this.offset.dx);
              // }

              // if (widget.key == topRightKey) {
              //   topLeftKey.currentState!.dyMoveTo(this.offset.dy);
              //   bottomRightKey.currentState!.dxMoveTo(this.offset.dx);
              // }

              // if (widget.key == bottomLeftKey) {
              //   bottomRightKey.currentState!.dyMoveTo(this.offset.dy);
              //   topLeftKey.currentState!.dxMoveTo(this.offset.dx);
              // }

              // if (widget.key == bottomRightKey) {
              //   bottomLeftKey.currentState!.dyMoveTo(this.offset.dy);
              //   topRightKey.currentState!.dxMoveTo(this.offset.dx);
              // }
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
