/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2021-07-16 19:11:57
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2021-07-18 21:23:19
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobilelabelimg/workboard/bloc/workboard_bloc.dart';

part './points.dart';

const circleSize = 30.0;
const defaultRectSize = 300.0;

class RectBox extends StatelessWidget {
  int id;
  RectBox({Key? key, required this.id}) : super(key: key);

  GlobalKey<_PointState> topLeftKey = GlobalKey(debugLabel: "topLeftKey");
  GlobalKey<_PointState> topRightKey = GlobalKey(debugLabel: "topRightKey");
  GlobalKey<_PointState> bottomLeftKey = GlobalKey(debugLabel: "bottomLeftKey");
  GlobalKey<_PointState> bottomRightKey =
      GlobalKey(debugLabel: "bottomRightKey");
  GlobalKey<_RectState> rectKey = GlobalKey(debugLabel: "rectKey");

  @override
  Widget build(BuildContext context) {
    return Rect(
      id: this.id,
      key: rectKey,
      globalKeys: [topLeftKey, topRightKey, bottomLeftKey, bottomRightKey],
    );
  }
}

class Rect extends StatefulWidget {
  List<GlobalKey> globalKeys;
  int id;
  Rect({Key? key, required this.globalKeys, required this.id})
      : super(key: key);

  @override
  _RectState createState() => _RectState();
}

class _RectState extends State<Rect> {
  double height = defaultRectSize;
  double width = defaultRectSize;

  double defaultLeft = 0;
  double defaultTop = 0;

  final TextEditingController controller = TextEditingController();

  late GlobalKey<_PointState> topLeftKey;
  late GlobalKey<_PointState> topRightKey;
  late GlobalKey<_PointState> bottomLeftKey;
  late GlobalKey<_PointState> bottomRightKey;

  late WorkboardBloc _workboardBloc;
  String className = '';

  List<int> getRectBox() {
    // print(this.topLeftKey.currentState!.offset);
    int leftTopX = this.topLeftKey.currentState!.offset.dx.toInt();
    int leftTopY = this.topLeftKey.currentState!.offset.dy.toInt();

    int rightBottomX = this.bottomRightKey.currentState!.offset.dx.toInt();
    int rightBottomY = this.bottomRightKey.currentState!.offset.dy.toInt();

    return [leftTopX, leftTopY, rightBottomX, rightBottomY];
  }

  @override
  void initState() {
    super.initState();
    topLeftKey = widget.globalKeys[0] as GlobalKey<_PointState>;
    topRightKey = widget.globalKeys[1] as GlobalKey<_PointState>;
    bottomLeftKey = widget.globalKeys[2] as GlobalKey<_PointState>;
    bottomRightKey = widget.globalKeys[3] as GlobalKey<_PointState>;
    _workboardBloc = context.read<WorkboardBloc>();
  }

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
      this.defaultTop = top;
    });
  }

  setLeft(double left) {
    setState(() {
      this.defaultLeft = left;
    });
  }

  moveTo(Offset? _off) {
    setState(() {
      if (null != _off) {
        this.defaultLeft = _off.dx;
        this.defaultTop = _off.dy;
      } else {
        this.defaultLeft = topLeftKey.currentState!.offset.dx;
        this.defaultTop = topLeftKey.currentState!.offset.dy;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkboardBloc, WorkboardState>(
      builder: (context, state) {
        return Positioned(
            left: defaultLeft,
            top: defaultTop,
            child: Draggable(
                onDraggableCanceled: (velocity, offset) {
                  setState(() {
                    this.defaultLeft = offset.dx;
                    this.defaultTop = offset.dy;
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
                child: Opacity(
                  opacity: 0.7,
                  child: InkWell(
                    onDoubleTap: () async {
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
                      this.className = result.toString();
                    },
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
                        _workboardBloc.add(RectRemove(id: widget.id));
                      }
                    },
                    child: Container(
                      // margin: EdgeInsets.only(top: 100, left: 50),
                      height: height,
                      width: width,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.green, width: 0.5),
                        color: Colors.blueAccent,
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
                  ),
                ),
                feedback: Container(
                  color: Colors.blue,
                  height: height,
                  width: width,
                )));
      },
    );
  }

  Widget getPoint(int position, GlobalKey key) {
    late Widget p;
    switch (position) {
      case 0: // top left
        p = Point(
          key: key,
          color: Colors.red,
          woffset: Offset(defaultLeft, defaultTop),
          globalKeys: widget.globalKeys,
          rectKey: widget.key as GlobalKey<_RectState>,
        );
        break;
      case 1: // top right
        p = Point(
          key: key,
          color: Colors.green,
          woffset:
              Offset(defaultRectSize - circleSize + defaultLeft, defaultTop),
          globalKeys: widget.globalKeys,
          rectKey: widget.key as GlobalKey<_RectState>,
        );
        break;
      case 2:
        p = Point(
          key: key,
          color: Colors.blue,
          woffset:
              Offset(defaultLeft, defaultRectSize - circleSize + defaultTop),
          globalKeys: widget.globalKeys,
          rectKey: widget.key as GlobalKey<_RectState>,
        );
        break;
      case 3:
        p = Point(
          key: key,
          color: Colors.black,
          woffset: Offset(defaultRectSize - circleSize + defaultLeft,
              defaultRectSize - circleSize + defaultTop),
          globalKeys: widget.globalKeys,
          rectKey: widget.key as GlobalKey<_RectState>,
        );
        break;
      default:
        p = Point(
          key: key,
          color: Colors.red,
          woffset: Offset(0, 0),
          globalKeys: widget.globalKeys,
          rectKey: widget.key as GlobalKey<_RectState>,
        );
        break;
    }
    return p;
  }
}
