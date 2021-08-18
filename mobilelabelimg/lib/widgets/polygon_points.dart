import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobilelabelimg/entity/labelmeObj.dart';
import 'package:mobilelabelimg/workboard/bloc/polygon_workboard_bloc.dart';
import 'package:provider/provider.dart';
import 'package:mobilelabelimg/widgets/polygon.dart';
import 'package:mobilelabelimg/utils/common.dart';

// ignore: must_be_immutable
class PolygonPoint extends StatefulWidget {
  PolygonPoint({
    Key? key,
    required this.poffset,

    /// index == -1 means a not valid point
    required this.index,
    required this.isFirst,
  }) : super(key: key);
  Offset poffset;
  int index;
  bool isFirst;

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

  TextEditingController controller = TextEditingController();

  late PolygonWorkboardBloc _polygonWorkboardBloc;

  @override
  void initState() {
    super.initState();
    offset = widget.poffset;
    defaultLeft = offset.dx;
    defaultTop = offset.dy;
    _polygonWorkboardBloc = context.read<PolygonWorkboardBloc>();
  }

  moveTO(Offset offset_) {
    setState(() {
      // offset = offset_;
      defaultLeft = offset_.dx;
      defaultTop = offset_.dy;
    });
  }

  List<int> getAllFirstPoint() {
    List<int> indexs = [];
    List<PolygonPoint> _points = getAllPoints();

    for (int _i = 0; _i < _points.length; _i++) {
      if (_points[_i].isFirst) {
        indexs.add(_i);
      }
    }
    return indexs;
  }

  List<GlobalKey<PolygonPointState>> getAllKeys() {
    List<GlobalKey<PolygonPointState>> _keys = [];
    for (var i in _polygonWorkboardBloc.state.listPolygonEntity) {
      _keys.addAll(i.keyList);
    }
    return _keys;
  }

  List<PolygonPoint> getAllPoints() {
    List<PolygonPoint> _points = [];
    for (var i in _polygonWorkboardBloc.state.listPolygonEntity) {
      _points.addAll(i.pList);
    }
    return _points;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PolygonWorkboardBloc, PolygonWorkboardState>(
        builder: (context, state) {
      return Positioned(
          left: defaultLeft,
          top: defaultTop,
          child: Draggable(
              onDraggableCanceled: (Velocity velocity, Offset _offset) {
                double _left = defaultLeft;
                double _top = defaultTop;
                if (context.read<DrawingProvicer>().status ==
                        DrawingStatus.notDrawing &&
                    widget.isFirst) {
                  List<GlobalKey<PolygonPointState>> _keys = getAllKeys();

                  int _index =
                      _keys.indexOf(widget.key as GlobalKey<PolygonPointState>);

                  var indexs = getAllFirstPoint();

                  int __ind = indexs.indexOf(_index);
                  double _x = _left - _offset.dx;
                  double _y = _top - _offset.dy;
                  moveTO(_offset);
                  Future.delayed(Duration.zero).then((value) =>
                      _polygonWorkboardBloc
                          .add(PointMoveEvent(x: _x, y: _y, index: __ind)));
                }
                moveTO(_offset);
              },
              child: widget.isFirst
                  ? GestureDetector(
                      onLongPress: () async {
                        var result = await showCupertinoDialog(
                            context: context,
                            builder: (context) {
                              return CupertinoAlertDialog(
                                title: Text("是否要删除这个标注？"),
                                actions: [
                                  CupertinoActionSheetAction(
                                      onPressed: () {
                                        Navigator.of(context).pop(0);
                                      },
                                      child: Text("取消")),
                                  CupertinoActionSheetAction(
                                      onPressed: () {
                                        Navigator.of(context).pop(1);
                                      },
                                      child: Text("确定"))
                                ],
                              );
                            });

                        if (result == 1) {
                          List<GlobalKey<PolygonPointState>> _keys =
                              getAllKeys();

                          int _index = _keys.indexOf(
                              widget.key as GlobalKey<PolygonPointState>);
                          var indexs = getAllFirstPoint();

                          int __ind = indexs.indexOf(_index);

                          _polygonWorkboardBloc
                              .add(WidgetsRemoveEvent(index: __ind));

                          _polygonWorkboardBloc
                              .add(PolygonEntityRemoveEvent(index: __ind));

                          context
                              .read<DrawingProvicer>()
                              .changeStatus(DrawingStatus.notDrawing);
                        }
                      },
                      onDoubleTap: () async {
                        var _keys = getAllKeys();

                        int _index = _keys.indexOf(
                            widget.key as GlobalKey<PolygonPointState>);
                        var indexs = getAllFirstPoint();

                        int __ind = indexs.indexOf(_index);

                        if (_polygonWorkboardBloc
                                .state.listPolygonEntity[__ind].className !=
                            "") {
                          controller.text = _polygonWorkboardBloc
                              .state.listPolygonEntity[__ind].className;
                        }
                        await showCupertinoDialog(
                            context: context,
                            builder: (context) {
                              return CupertinoAlertDialog(
                                title: Text("请输入类名"),
                                content: Material(
                                    child: TextField(
                                  maxLength: 30,
                                  controller: controller,
                                )),
                                actions: [
                                  CupertinoActionSheetAction(
                                    child: Text("确定"),
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(controller.text);
                                    },
                                  )
                                ],
                              );
                            });

                        _polygonWorkboardBloc.add(PolygonEntityChangeNameEvent(
                            name: controller.text, index: __ind));

                        // print(_polygonWorkboardBloc
                        //     .state.listPolygonEntity[__ind].className);
                      },
                      child: Container(
                          width: circleSize,
                          height: circleSize,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(150),
                            border:
                                new Border.all(color: Colors.red, width: 0.5),
                          )),
                    )
                  : Container(
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
                          color: widget.isFirst
                              ? Colors.redAccent
                              : Colors.blueAccent,
                          width: 0.5)))));
    });
  }

  /// for test
  void showPositonChange() {
    LabelmeObject labelmeObject = LabelmeObject();
    labelmeObject.imageData = "";
    labelmeObject.imageHeight = CommonUtil.screenH().ceil();
    labelmeObject.imageWidth = CommonUtil.screenW().ceil();
    labelmeObject.flags = {};
    labelmeObject.version = labelmeVersion;
    List<Shapes> shapes = [];
    for (var i in _polygonWorkboardBloc.state.listPolygonEntity) {
      Shapes _shapes = Shapes();
      _shapes.flags = {};
      _shapes.label = i.className;
      _shapes.groupId = "0";
      _shapes.shapeType = labelmeShapeType;
      List _ppoints = [];

      for (var p in i.keyList) {
        int _left = p.currentState!.defaultLeft.ceil();
        int _top = p.currentState!.defaultTop.ceil();
        _ppoints.add([_left, _top]);
      }
      _shapes.points = _ppoints;
      shapes.add(_shapes);
    }
    labelmeObject.shapes = shapes;

    print(labelmeObject.toJson());
    print("============================================");
  }
}
