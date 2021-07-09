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
    return Rect(
      key: rectKey,
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

  setHeight(double height) {
    setState(() {
      this.height = height;
    });
  }

  setWidth(double width) {
    setState(() {
      this.width = width;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }

  Widget getPoint(int position, GlobalKey key) {
    late Widget p;
    switch (position) {
      case 0: // top left
        p = Point(key: key, color: Colors.red, offset: Offset(0, 0));
        break;
      case 1: // top right
        p = Point(
            key: key, color: Colors.green, offset: Offset(300 - circleSize, 0));
        break;
      case 2:
        p = Point(
            key: key, color: Colors.blue, offset: Offset(0, 300 - circleSize));
        break;
      case 3:
        p = Point(
            key: key,
            color: Colors.black,
            offset: Offset(300 - circleSize, 300 - circleSize));
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

  @override
  void initState() {
    super.initState();
    offset = widget.offset;
    print(this.offset);
  }

  moveTO(Offset offset) {
    setState(() {
      this.offset = offset;
    });
  }

  dxMoveTo(double pos) {
    setState(() {
      this.offset = Offset(pos, this.offset.dy);
    });
  }

  dyMoveTo(double pos) {
    setState(() {
      this.offset = Offset(this.offset.dx, pos);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: offset.dx,
        top: offset.dy,
        child: Draggable(
            onDraggableCanceled: (Velocity velocity, Offset offset) {
              this.moveTO(offset);

              double width = (topLeftKey.currentState!.offset.dx -
                      topRightKey.currentState!.offset.dx)
                  .abs();

              double height = (topLeftKey.currentState!.offset.dy -
                      bottomLeftKey.currentState!.offset.dy)
                  .abs();

              rectKey.currentState!.setHeight(height);
              rectKey.currentState!.setWidth(width);

              if (widget.key == topLeftKey) {
                topRightKey.currentState!.dyMoveTo(this.offset.dy);
                bottomLeftKey.currentState!.dxMoveTo(this.offset.dx);
              }

              if (widget.key == topRightKey) {
                topLeftKey.currentState!.dyMoveTo(this.offset.dy);
                bottomRightKey.currentState!.dxMoveTo(this.offset.dx);
              }

              if (widget.key == bottomLeftKey) {
                bottomRightKey.currentState!.dyMoveTo(this.offset.dy);
                topLeftKey.currentState!.dxMoveTo(this.offset.dx);
              }

              if (widget.key == bottomRightKey) {
                bottomLeftKey.currentState!.dyMoveTo(this.offset.dy);
                topRightKey.currentState!.dxMoveTo(this.offset.dx);
              }
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
