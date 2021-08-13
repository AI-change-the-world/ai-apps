import 'package:flutter/material.dart';
import 'package:mobilelabelimg/entity/PolygonEntity.dart';
import 'package:mobilelabelimg/widgets/polygon_points.dart';
import 'package:provider/provider.dart';
import 'package:mobilelabelimg/widgets/polygon_provider.dart';
import 'package:mobilelabelimg/utils/common.dart';

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

      canvas.drawLine(
          Offset(keys.last.currentState!.defaultLeft + 0.5 * circleSize,
              keys.last.currentState!.defaultTop + 0.5 * circleSize),
          Offset(keys.first.currentState!.defaultLeft + 0.5 * circleSize,
              keys.first.currentState!.defaultTop + 0.5 * circleSize),
          line);

      /// dont know why this section does not work
      ///
      // if (i == points.length - 1 &&
      //     (keys.first.currentState!.defaultLeft -
      //                 keys.last.currentState!.defaultLeft)
      //             .abs() <
      //         circleSize &&
      //     (keys.first.currentState!.defaultTop -
      //                 keys.last.currentState!.defaultTop)
      //             .abs() <
      //         circleSize) {
      //   print("该收网了");
      //   canvas.drawLine(
      //       Offset(keys.last.currentState!.defaultLeft + 0.5 * circleSize,
      //           keys.last.currentState!.defaultTop + 0.5 * circleSize),
      //       Offset(keys.first.currentState!.defaultLeft + 0.5 * circleSize,
      //           keys.first.currentState!.defaultTop + 0.5 * circleSize),
      //       line);
      //   print(points.last);
      //   print(points.first);
      // }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}

class PolygonDemo extends StatefulWidget {
  PolygonDemo({Key? key}) : super(key: key);

  @override
  _PolygonDemoState createState() => _PolygonDemoState();
}

class _PolygonDemoState extends State<PolygonDemo> {
  late PolygonEntity polygonEntity =
      PolygonEntity(keyList: [], pList: [], className: "", index: 0);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // context.read<AddOrRemovePolygonProvider>().add(polygonEntity);
  }

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
            index: polygonEntity.pList.length + 1,
          );

          context.read<MovePolygonProvider>().add(key);

          setState(() {
            polygonEntity.keyList.add(key);
            polygonEntity.pList.add(point);

            // print("=========================================");
            // print(x);
            // print(y);
            // print(context
            //     .read<AddOrRemovePolygonProvider>()
            //     .poList[0]
            //     .pList
            //     .last
            //     .poffset
            //     .dx);
            // print(context
            //     .read<AddOrRemovePolygonProvider>()
            //     .poList[0]
            //     .pList
            //     .last
            //     .poffset
            //     .dy);
            // print("=========================================");
            if (polygonEntity.pList.length > 2) {
              if ((x - polygonEntity.keyList[0].currentState!.defaultLeft)
                          .abs() <
                      circleSize &&
                  (y - polygonEntity.keyList[0].currentState!.defaultTop)
                          .abs() <
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
        foregroundPainter: LinePainter(
            keys: polygonEntity.keyList, points: polygonEntity.pList),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: polygonEntity.pList,
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
