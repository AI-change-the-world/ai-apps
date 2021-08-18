import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
    // print("============================================");
    // print(listPolygonEntity.length);
    // if (listPolygonEntity.isNotEmpty) {
    //   print(listPolygonEntity.last.keyList.length);
    //   print(listPolygonEntity.last.keyList.last.currentState == null);
    // }
    // print("============================================");

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
  PolygonDemo({Key? key, required this.imgPath}) : super(key: key);
  final String imgPath;

  @override
  _PolygonDemoState createState() => _PolygonDemoState();
}

class _PolygonDemoState extends State<PolygonDemo> {
  final GlobalKey<ScaffoldState> _scaffoldKey2 = GlobalKey<ScaffoldState>();
  late PolygonWorkboardBloc _polygonWorkboardBloc;

  var _initFuture;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _polygonWorkboardBloc = context.read<PolygonWorkboardBloc>();
    _initFuture = initPage();
  }

  Future<void> initPage() async {
    DraggableButton draggableButton = DraggableButton(
      scaffoldKey: _scaffoldKey2,
      type: 1,
    );
    _polygonWorkboardBloc.add(WidgetAddEvent(w: draggableButton));
    _polygonWorkboardBloc
        .add(GetSingleImagePolygonEvent(filename: widget.imgPath));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PolygonWorkboardBloc, PolygonWorkboardState>(
        builder: (context, state) {
      return FutureBuilder(
          future: _initFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Scaffold(
                  drawer: ToolsListWidget(
                    imgPath: _polygonWorkboardBloc.state.imgPath,
                    type: 1,
                  ),
                  key: _scaffoldKey2,
                  body: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTapUp: (TapUpDetails details) {
                      if (context.read<DrawingProvicer>().status ==
                          DrawingStatus.drawing) {
                        // print("======================================");
                        // print(_polygonWorkboardBloc.state.widgets.length);
                        // print(_polygonWorkboardBloc.state.listPolygonEntity.length);
                        // print("======================================");

                        var x = details.globalPosition.dx;
                        var y = details.globalPosition.dy;
                        bool isFirst = false;
                        if (_polygonWorkboardBloc.state.widgets.length == 1 ||
                            (_polygonWorkboardBloc
                                        .state.widgets.last.runtimeType ==
                                    PolygonPoint &&
                                (_polygonWorkboardBloc.state.widgets.last
                                            as PolygonPoint)
                                        .index ==
                                    -1)) isFirst = true;
                        GlobalKey<PolygonPointState> key = GlobalKey();
                        PolygonPoint point = PolygonPoint(
                          key: key,
                          poffset: Offset(x, y),
                          index: _polygonWorkboardBloc
                                  .state.listPolygonEntity.last.pList.length +
                              1,
                          isFirst: isFirst,
                        );

                        // context.read<MovePolygonProvider>().add(key, point);

                        // setState(() {
                        _polygonWorkboardBloc
                            .state.listPolygonEntity.last.keyList
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

                            _polygonWorkboardBloc.add(WidgetAddEvent(
                                w: PolygonPoint(
                              poffset: Offset(-1, -1),
                              index: -1,
                              isFirst: false,
                            )));
                          }
                        }
                        // });
                      } else {
                        Fluttertoast.showToast(
                            msg: "当前为修改模式，请新建一个标注继续",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 2,
                            backgroundColor: Colors.orange,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }
                      // print(details.localPosition);
                    },
                    child: CustomPaint(
                      // key: ,
                      foregroundPainter: (_polygonWorkboardBloc
                                  .state.listPolygonEntity.isEmpty ||
                              _polygonWorkboardBloc.state.listPolygonEntity.last
                                  .keyList.isNotEmpty)
                          ? LinePainter(
                              listPolygonEntity:
                                  _polygonWorkboardBloc.state.listPolygonEntity)
                          : null,
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: _polygonWorkboardBloc.state.imgPath != ""
                            ? BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: FileImage(File(
                                        _polygonWorkboardBloc.state.imgPath))),
                              )
                            : null,
                        child: Stack(
                            // children: polygonEntity.pList,
                            children:
                                List.of(_polygonWorkboardBloc.state.widgets)
                                  ..removeWhere((element) {
                                    if (element.runtimeType == PolygonPoint) {
                                      return (element as PolygonPoint).index ==
                                          -1;
                                    } else {
                                      return false;
                                    }
                                  })),
                      ),
                    ),
                  ));
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          });
    });
  }
}

class PolygonDemoPage extends StatelessWidget {
  final String imgPath;
  const PolygonDemoPage({Key? key, required this.imgPath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => DrawingProvicer()),
            // ChangeNotifierProvider(create: (_) => MovePolygonProvider()),
          ],
          child: Scaffold(
            body: PolygonDemo(
              imgPath: imgPath,
            ),
          ),
        ),
        create: (BuildContext context) {
          return PolygonWorkboardBloc()..add(InitialEvent());
        });
  }
}
