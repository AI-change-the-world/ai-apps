import 'package:flutter/material.dart';
import 'package:mobilelabelimg/entity/PolygonEntity.dart';
import 'package:mobilelabelimg/widgets/drawer_button_list.dart';
import 'package:mobilelabelimg/widgets/polygon_points.dart';
import 'package:provider/provider.dart';
import 'package:mobilelabelimg/widgets/polygon_provider.dart';
import 'package:mobilelabelimg/utils/common.dart';

class LinePainter extends CustomPainter {
  // final List<PolygonPoint> points;
  // final List<GlobalKey<PolygonPointState>> keys;

  // PolygonEntity? polygonEntity;
  List<PolygonEntity> listPolygonEntity;

  // LinePainter({required this.points, required this.keys});

  LinePainter({required this.listPolygonEntity});

  var line = Paint()
    ..style = PaintingStyle.stroke
    ..color = Colors.blue
    ..strokeWidth = 1.0;

  @override
  void paint(Canvas canvas, Size size) {
    // print(polygonEntity.pList.length);
    if (listPolygonEntity.isNotEmpty) {
      // PolygonEntity polygonEntity = listPolygonEntity.last;
      for (PolygonEntity polygonEntity in listPolygonEntity) {
        if (polygonEntity.pList.length < 2) return;
        for (int i = 1; i < polygonEntity.pList.length; i++) {
          canvas.drawLine(
              Offset(
                  polygonEntity.keyList[i - 1].currentState!.defaultLeft +
                      0.5 * circleSize,
                  polygonEntity.keyList[i - 1].currentState!.defaultTop +
                      0.5 * circleSize),
              Offset(
                  polygonEntity.keyList[i].currentState!.defaultLeft +
                      0.5 * circleSize,
                  polygonEntity.keyList[i].currentState!.defaultTop +
                      0.5 * circleSize),
              line);

          canvas.drawLine(
              Offset(
                  polygonEntity.keyList.last.currentState!.defaultLeft +
                      0.5 * circleSize,
                  polygonEntity.keyList.last.currentState!.defaultTop +
                      0.5 * circleSize),
              Offset(
                  polygonEntity.keyList.first.currentState!.defaultLeft +
                      0.5 * circleSize,
                  polygonEntity.keyList.first.currentState!.defaultTop +
                      0.5 * circleSize),
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
  // PolygonEntity polygonEntity =
  //     PolygonEntity(keyList: [], pList: [], className: "", index: 0);
  final GlobalKey<ScaffoldState> _scaffoldKey2 = GlobalKey<ScaffoldState>();

  // late List<PolygonEntity> listPolygonEntity = [];
  List<Widget> listPolyPoints = [];

  // int currentPolygonIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // listPolygonEntity.add(polygonEntity);

    DraggableButton draggableButton = DraggableButton(
      scaffoldKey: _scaffoldKey2,
      type: 1,
    );
    listPolyPoints.add(draggableButton);

    // context.read<AddOrRemovePolygonProvider>().add(polygonEntity);
  }

  @override
  Widget build(BuildContext context) {
    // context.read<DrawingProvicer>().changeStatus(DrawingStatus.notDrawing);
    return Scaffold(
        drawer: ToolsListWidget(
          imgPath: "",
          type: 1,
        ),
        key: _scaffoldKey2,
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTapUp: (TapUpDetails details) {
            if (context.read<DrawingProvicer>().status ==
                DrawingStatus.drawing) {
              var x = details.globalPosition.dx;
              var y = details.globalPosition.dy;
              bool isFirst = false;
              if (listPolyPoints.length == 1 ||
                  (listPolyPoints.last.runtimeType == PolygonPoint &&
                      (listPolyPoints.last as PolygonPoint).index == -1))
                isFirst = true;
              GlobalKey<PolygonPointState> key = GlobalKey();
              PolygonPoint point = PolygonPoint(
                key: key,
                poffset: Offset(x, y),
                index: context
                        .read<AddOrRemovePolygonProvider>()
                        .poList
                        .last
                        .pList
                        .length +
                    1,
                isFirst: isFirst,
              );

              context.read<MovePolygonProvider>().add(key);

              setState(() {
                context
                    .read<AddOrRemovePolygonProvider>()
                    .poList
                    .last
                    .keyList
                    .add(key);
                context
                    .read<AddOrRemovePolygonProvider>()
                    .poList
                    .last
                    .pList
                    .add(point);
                listPolyPoints.add(point);

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
                if (context
                        .read<AddOrRemovePolygonProvider>()
                        .poList
                        .last
                        .pList
                        .length >
                    2) {
                  if ((x -
                                  context
                                      .read<AddOrRemovePolygonProvider>()
                                      .poList
                                      .last
                                      .keyList[0]
                                      .currentState!
                                      .defaultLeft)
                              .abs() <
                          circleSize &&
                      (y -
                                  context
                                      .read<AddOrRemovePolygonProvider>()
                                      .poList
                                      .last
                                      .keyList[0]
                                      .currentState!
                                      .defaultTop)
                              .abs() <
                          circleSize) {
                    context
                        .read<DrawingProvicer>()
                        .changeStatus(DrawingStatus.notDrawing);

                    // currentPolygonIndex += 1;

                    listPolyPoints.add(PolygonPoint(
                      poffset: Offset(-1, -1),
                      index: -1,
                      isFirst: false,
                    ));
                  }
                }
              });
            }
            // print(details.localPosition);
          },
          child: CustomPaint(
            foregroundPainter: LinePainter(
                listPolygonEntity:
                    context.read<AddOrRemovePolygonProvider>().poList),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill, image: AssetImage("assets/demo_img.png")),
              ),
              child: Stack(
                  // children: polygonEntity.pList,
                  children: List.of(listPolyPoints)
                    ..removeWhere((element) {
                      if (element.runtimeType == PolygonPoint) {
                        return (element as PolygonPoint).index == -1;
                      } else {
                        return false;
                      }
                    })),
            ),
          ),
        ));
  }

  // Widget buildGetToolButtons() {
  //   return Positioned(
  //       child: Row(
  //     children: [TextButton(onPressed: () {}, child: child)],
  //   ));
  // }
}
