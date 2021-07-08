import 'package:flutter/material.dart';

class DraggableWidget extends StatefulWidget {
  final Offset offset; //布局位置变量
  final Color widgetColor; //布局颜色变量
  //构造方法，用于数据传递
  const DraggableWidget(
      {Key? key, required this.offset, required this.widgetColor})
      : super(key: key);
  _DraggableWidgetState createState() => _DraggableWidgetState();
}

class _DraggableWidgetState extends State<DraggableWidget> {
  Offset offset = Offset(0.0, 0.0); //初始化offset位置
  @override
  void initState() {
    super.initState();
    offset = widget.offset;
  }

  @override
  Widget build(BuildContext context) {
    //这里使用Positioned控件定位布局
    return Positioned(
      left: offset.dx, //接收x轴位置
      top: offset.dy, //接收y轴位置
      //这里使用容器可拖拽控件Draggable
      child: Draggable(
        data: widget.widgetColor,
        child: Container(
          width: 100.0,
          height: 100.0,
          color: widget.widgetColor,
        ),
        feedback: Container(
          width: 100.0,
          height: 100.0,
          color: widget.widgetColor.withOpacity(0.5),
        ),
        onDraggableCanceled: (Velocity velocity, Offset offset) {
          setState(() {
            this.offset = offset; //更新位置
          });
        },
      ),
    );
  }
}

class DraggableDemo extends StatefulWidget {
  _DraggableDemoState createState() => _DraggableDemoState();
}

class _DraggableDemoState extends State<DraggableDemo> {
  Color _draggableColor = Colors.grey;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //这里使用层叠组件stack
      body: Stack(
        children: <Widget>[
          //左上的容器
          DraggableWidget(
            offset: Offset(80.0, 80.0),
            widgetColor: Colors.tealAccent,
          ),
          //右上容器
          DraggableWidget(
            offset: Offset(180.0, 80.0),
            widgetColor: Colors.redAccent,
          ),
          //拖拽后放入的容器
          Center(
            child: DragTarget(
              onAccept: (Color color) {
                _draggableColor = color;
              },
              builder: (context, candidateData, rejectedData) {
                return Container(
                  width: 200.0,
                  height: 200.0,
                  color: _draggableColor,
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
