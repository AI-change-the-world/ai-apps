import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobilelabelimg/entity/PolygonEntity.dart';
import 'package:mobilelabelimg/widgets/drawer_button_list.dart';
import 'package:mobilelabelimg/widgets/polygon_points.dart';
import 'package:mobilelabelimg/workboard/bloc/polygon_workboard_bloc.dart';

import 'package:provider/provider.dart';

import 'package:mobilelabelimg/utils/common.dart';

part './polygon_provider.dart';

class LinePainter extends CustomPainter {
  List<PolygonEntity> listPolygonEntity;

  LinePainter({required this.listPolygonEntity});

  var line = Paint()
    ..style = PaintingStyle.stroke
    ..color = Colors.blue
    ..strokeWidth = 1.0;

  @override
  void paint(Canvas canvas, Size size) {
    if (listPolygonEntity.isNotEmpty) {
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
  late PolygonWorkboardBloc _polygonWorkboardBloc;

  // late List<PolygonEntity> listPolygonEntity = [];
  // List<Widget> listPolyPoints = [];

  // int currentPolygonIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _polygonWorkboardBloc = context.read<PolygonWorkboardBloc>();

    // listPolygonEntity.add(polygonEntity);

    DraggableButton draggableButton = DraggableButton(
      scaffoldKey: _scaffoldKey2,
      type: 1,
    );
    _polygonWorkboardBloc.add(WidgetAddEvent(w: draggableButton));
    // listPolyPoints.add(draggableButton);

    // context.read<AddOrRemovePolygonProvider>().add(polygonEntity);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PolygonWorkboardBloc, PolygonWorkboardState>(
        builder: (context, state) {
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
                if (_polygonWorkboardBloc.state.widgets.length == 1 ||
                    (_polygonWorkboardBloc.state.widgets.last.runtimeType ==
                            PolygonPoint &&
                        (_polygonWorkboardBloc.state.widgets.last
                                    as PolygonPoint)
                                .index ==
                            -1)) isFirst = true;
                GlobalKey<PolygonPointState> key = GlobalKey();
                PolygonPoint point = PolygonPoint(
                  key: key,
                  poffset: Offset(x, y),
                  // index: context
                  //         .read<AddOrRemovePolygonProvider>()
                  //         .poList
                  //         .last
                  //         .pList
                  //         .length +
                  //     1,
                  index: _polygonWorkboardBloc
                          .state.listPolygonEntity.last.pList.length +
                      1,
                  isFirst: isFirst,
                );

                context.read<MovePolygonProvider>().add(key, point);

                setState(() {
                  _polygonWorkboardBloc.state.listPolygonEntity.last.keyList
                      .add(key);
                  _polygonWorkboardBloc.state.listPolygonEntity.last.pList
                      .add(point);
                  _polygonWorkboardBloc.add(WidgetAddEvent(w: point));
                  if (_polygonWorkboardBloc
                          .state.listPolygonEntity.last.pList.length >
                      2) {
                    if ((x -
                                    _polygonWorkboardBloc
                                        .state
                                        .listPolygonEntity
                                        .last
                                        .keyList[0]
                                        .currentState!
                                        .defaultLeft)
                                .abs() <
                            circleSize &&
                        (y -
                                    _polygonWorkboardBloc
                                        .state
                                        .listPolygonEntity
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

                      _polygonWorkboardBloc.add(WidgetAddEvent(
                          w: PolygonPoint(
                        poffset: Offset(-1, -1),
                        index: -1,
                        isFirst: false,
                      )));

                      // listPolyPoints.add(PolygonPoint(
                      //   poffset: Offset(-1, -1),
                      //   index: -1,
                      //   isFirst: false,
                      // ));
                    }
                  }
                });
              }
              // print(details.localPosition);
            },
            child: CustomPaint(
              // key: ,
              foregroundPainter: LinePainter(
                  listPolygonEntity:
                      _polygonWorkboardBloc.state.listPolygonEntity),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage("assets/demo_img.png")),
                ),
                child: Stack(
                    // children: polygonEntity.pList,
                    children: List.of(_polygonWorkboardBloc.state.widgets)
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
    });
  }
}

class PolygonDemoPage extends StatelessWidget {
  const PolygonDemoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        child: PolygonDemo(),
        create: (BuildContext context) {
          return PolygonWorkboardBloc()..add(InitialEvent());
        });
  }
}
