/// for test
/// Deprecated
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
  const Rect({Key? key}) : super(key: key);

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
      defaultTop = top;
    });
  }

  setLeft(double left) {
    setState(() {
      defaultLeft = left;
    });
  }

  moveTo(Offset? _off) {
    setState(() {
      if (null != _off) {
        defaultLeft = _off.dx;
        defaultTop = _off.dy;
      } else {
        defaultLeft = topLeftKey.currentState!.offset.dx;
        defaultTop = topLeftKey.currentState!.offset.dy;
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
                defaultLeft = offset.dx;
                defaultTop = offset.dy;
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
            woffset: Offset(defaultLeft, defaultTop));
        break;
      case 1: // top right
        p = Point(
            key: key,
            color: Colors.green,
            woffset:
                Offset(defaultRectSize - circleSize + defaultLeft, defaultTop));
        break;
      case 2:
        p = Point(
            key: key,
            color: Colors.blue,
            woffset:
                Offset(defaultLeft, defaultRectSize - circleSize + defaultTop));
        break;
      case 3:
        p = Point(
            key: key,
            color: Colors.black,
            woffset: Offset(defaultRectSize - circleSize + defaultLeft,
                defaultRectSize - circleSize + defaultTop));
        break;
      default:
        p = Point(key: key, color: Colors.red, woffset: const Offset(0, 0));
        break;
    }
    return p;
  }
}

// ignore: must_be_immutable
class Point extends StatefulWidget {
  Point({required Key key, required this.color, required this.woffset})
      : super(key: key);

  Color color;
  Offset woffset;

  @override
  _PointState createState() => _PointState();
}

class _PointState extends State<Point> {
  late Offset offset;

  double _left = 0;
  double _top = 0;

  double _moveX = 0;
  double _moveY = 0;

  late Offset currentOffset;

  void setLeft(double left) {
    setState(() {
      _left = left;
    });
  }

  void setTop(double top) {
    setState(() {
      _top = top;
    });
  }

  @override
  void initState() {
    super.initState();
    offset = widget.woffset;

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
            onDraggableCanceled: (Velocity velocity, Offset _offset) {
              currentOffset = offset;
              Offset topLeftOffset = topLeftKey.currentState!.offset;
              Offset topRightOffset = topRightKey.currentState!.offset;
              Offset bottomLeftOffset = bottomLeftKey.currentState!.offset;
              Offset bottomRightOffset = bottomRightKey.currentState!.offset;

              _moveX = _offset.dx - currentOffset.dx;
              _moveY = _offset.dx - currentOffset.dx;
              if (widget.key == topLeftKey) {
                topLeftOffset = _offset;
                topRightOffset = Offset(_offset.dx, _offset.dy + _moveY);
                bottomLeftOffset = Offset(_offset.dx + _moveX, _offset.dy);
              }

              if (widget.key == topRightKey) {
                topLeftOffset = Offset(topLeftOffset.dx, _offset.dy);
                topRightOffset = _offset;
                bottomRightOffset = Offset(_offset.dx, bottomRightOffset.dy);
              }

              if (widget.key == bottomLeftKey) {
                bottomLeftOffset = _offset;
                topLeftOffset = Offset(_offset.dx, topLeftOffset.dy);
                bottomRightOffset = Offset(bottomRightOffset.dx, _offset.dy);
              }

              if (widget.key == bottomRightKey) {
                bottomRightOffset = _offset;
                topRightOffset = Offset(_offset.dx + _moveX, _offset.dy);
                bottomLeftOffset = Offset(_offset.dx, _offset.dy + _moveY);
              }

              topLeftKey.currentState!.moveTO(topLeftOffset);
              topRightKey.currentState!.moveTO(topRightOffset);
              bottomLeftKey.currentState!.moveTO(bottomLeftOffset);
              bottomRightKey.currentState!.moveTO(bottomRightOffset);

              late double width;
              late double height;

              width = (topLeftKey.currentState!.offset.dx -
                      circleSize -
                      bottomRightKey.currentState!.offset.dx)
                  .abs();

              height = (topLeftKey.currentState!.offset.dy -
                      circleSize -
                      bottomRightKey.currentState!.offset.dy)
                  .abs();

              // print("========================");
              // print(width);
              // print(height);
              // print("========================");

              rectKey.currentState!.setHeight(height);
              rectKey.currentState!.setWidth(width);

              topLeftKey.currentState!.setLeft(0);
              topLeftKey.currentState!.setTop(0);

              topRightKey.currentState!.setLeft(width - circleSize);
              topRightKey.currentState!.setTop(0);

              bottomLeftKey.currentState!.setLeft(0);
              bottomLeftKey.currentState!.setTop(height - circleSize);

              bottomRightKey.currentState!.setLeft(width - circleSize);
              bottomRightKey.currentState!.setTop(height - circleSize);

              rectKey.currentState!.moveTo(topLeftKey.currentState!.offset);
            },
            feedback: Container(
                width: circleSize,
                height: circleSize,
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(150),
                    border: Border.all(color: widget.color, width: 0.5))),
            child: Container(
                width: circleSize,
                height: circleSize,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(150),
                  border: Border.all(color: widget.color, width: 0.5),
                ))));
  }
}
