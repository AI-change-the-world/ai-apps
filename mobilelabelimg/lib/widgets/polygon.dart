import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
part './polygon_provider.dart';

const circleSize = 30.0;

class LinePainter extends CustomPainter {
  final List<PolygonPoint> points;
  final List<GlobalKey<PolygonPointState>> keys;

  LinePainter({required this.points, required this.keys});

  var line = Paint()
    ..style = PaintingStyle.stroke
    ..color = Colors.blue
    ..strokeWidth = 1.0;

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    if (points.length < 2) return;
    for (int i = 1; i < points.length; i++) {
      canvas.drawLine(
          Offset(keys[i - 1].currentState!.defaultLeft + 0.5 * circleSize,
              keys[i - 1].currentState!.defaultTop + 0.5 * circleSize),
          Offset(keys[i].currentState!.defaultLeft + 0.5 * circleSize,
              keys[i].currentState!.defaultTop + 0.5 * circleSize),
          line);
      if (i == points.length - 1 &&
          (keys.first.currentState!.defaultLeft -
                      keys.last.currentState!.defaultLeft)
                  .abs() <
              circleSize &&
          (keys.first.currentState!.defaultTop -
                      keys.last.currentState!.defaultTop)
                  .abs() <
              circleSize) {
        print("该收网了");
        canvas.drawLine(
            Offset(keys.last.currentState!.defaultLeft + 0.5 * circleSize,
                keys.last.currentState!.defaultTop + 0.5 * circleSize),
            Offset(keys.first.currentState!.defaultLeft + 0.5 * circleSize,
                keys.first.currentState!.defaultTop + 0.5 * circleSize),
            line);
        print(points.last);
        print(points.first);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}

class PolygonPoint extends StatefulWidget {
  PolygonPoint({Key? key, required this.poffset, required this.index})
      : super(key: key);
  Offset poffset;
  int index;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    // TODO: implement toString
    return index.toString();
  }

  @override
  PolygonPointState createState() => PolygonPointState();
}

class PolygonPointState extends State<PolygonPoint> {
  late Offset offset;

  late double defaultLeft;
  late double defaultTop;

  late double fatherLeft;
  late double fatherTop;

  @override
  void initState() {
    super.initState();
    offset = widget.poffset;
    defaultLeft = offset.dx;
    defaultTop = offset.dy;
    fatherLeft = 0;
    fatherTop = 0;
  }

  moveTO(Offset offset_) {
    setState(() {
      // offset = offset_;
      defaultLeft = offset_.dx;
      defaultTop = offset_.dy;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: defaultLeft + fatherLeft,
        top: defaultTop + fatherTop,
        child: Draggable(
            onDraggableCanceled: (Velocity velocity, Offset _offset) {
              moveTO(_offset);
            },
            child: Container(
                width: circleSize,
                height: circleSize,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(150),
                  border: new Border.all(color: Colors.blue, width: 0.5),
                )),
            feedback: Container(
                width: circleSize,
                height: circleSize,
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(150),
                    border: new Border.all(
                        color: Colors.blueAccent, width: 0.5)))));
  }
}

class Polygon extends StatelessWidget {
  const Polygon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        child: Scaffold(
          body: PolygonDemo(),
        ),
        providers: [
          ChangeNotifierProvider(create: (_) => DrawingProvicer()),
        ]);
  }
}

class PolygonDemo extends StatefulWidget {
  PolygonDemo({Key? key}) : super(key: key);

  @override
  _PolygonDemoState createState() => _PolygonDemoState();
}

class _PolygonDemoState extends State<PolygonDemo> {
  List<PolygonPoint> pList = [];
  List<GlobalKey<PolygonPointState>> keyList = [];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTapUp: (TapUpDetails details) {
        if (context.read<DrawingProvicer>().status == DrawingStatus.drawing) {
          var x = details.globalPosition.dx;
          var y = details.globalPosition.dy;
          GlobalKey<PolygonPointState> key = GlobalKey();
          PolygonPoint point = PolygonPoint(
            key: key,
            poffset: Offset(x, y),
            index: pList.length + 1,
          );

          setState(() {
            keyList.add(key);
            pList.add(point);
            if (pList.length > 2) {
              if ((x - keyList[0].currentState!.defaultLeft).abs() <
                      circleSize &&
                  (y - keyList[0].currentState!.defaultTop).abs() <
                      circleSize) {
                context
                    .read<DrawingProvicer>()
                    .changeStatus(DrawingStatus.notDrawing);
              }
            }
          });
        }
        // print(details.localPosition);
      },
      child: CustomPaint(
        foregroundPainter: LinePainter(keys: keyList, points: pList),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: pList,
          ),
        ),
      ),
    );
  }

  // Widget buildGetToolButtons() {
  //   return Positioned(
  //       child: Row(
  //     children: [TextButton(onPressed: () {}, child: child)],
  //   ));
  // }
}
