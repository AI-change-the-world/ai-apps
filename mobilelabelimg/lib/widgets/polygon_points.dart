import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobilelabelimg/widgets/polygon_provider.dart';
import 'package:mobilelabelimg/utils/common.dart';

// ignore: must_be_immutable
class PolygonPoint extends StatefulWidget {
  PolygonPoint({
    Key? key,
    required this.poffset,
    required this.index,
    required this.isFirst,
  }) : super(key: key);
  Offset poffset;
  int index;
  bool isFirst;

  // bool get isValid => index != -1;

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

  @override
  void initState() {
    super.initState();
    offset = widget.poffset;
    defaultLeft = offset.dx;
    defaultTop = offset.dy;
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
        left: defaultLeft,
        top: defaultTop,
        child: Draggable(
            onDraggableCanceled: (Velocity velocity, Offset _offset) {
              double _left = defaultLeft;
              double _top = defaultTop;
              if (context.read<DrawingProvicer>().status ==
                      DrawingStatus.notDrawing &&
                  widget.isFirst) {
                double _x = _left - _offset.dx;
                double _y = _top - _offset.dy;
                moveTO(_offset);
                context.read<MovePolygonProvider>().move(_x, _y);
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
                    },
                    onDoubleTap: () async {
                      // print("这里要添加类型");
                      var result = await showCupertinoDialog(
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
                                    Navigator.of(context).pop(controller.text);
                                  },
                                )
                              ],
                            );
                          });
                    },
                    child: Container(
                        width: circleSize,
                        height: circleSize,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(150),
                          border: new Border.all(color: Colors.red, width: 0.5),
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
  }
}
