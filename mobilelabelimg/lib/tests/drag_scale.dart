import 'package:flutter/material.dart';
import 'package:flutter_drag_scale/flutter_drag_scale.dart';

// void main() => runApp(MyApp());

class MyAppScale extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400.0,
      width: 400,
      child: Center(
        child: DragScaleContainer(
          doubleTapStillScale: true,
          child: Stack(
            children: [
              Container(
                child: Image(
                  image: new NetworkImage(
                      'http://h.hiphotos.baidu.com/zhidao/wh%3D450%2C600/sign=0d023672312ac65c67506e77cec29e27/9f2f070828381f30dea167bbad014c086e06f06c.jpg'),
                ),
              ),
              Positioned(left: 20, top: 30, child: Text("TEST"))
            ],
          ),
          // child: new Image(
          //   image: new NetworkImage(
          //       'http://h.hiphotos.baidu.com/zhidao/wh%3D450%2C600/sign=0d023672312ac65c67506e77cec29e27/9f2f070828381f30dea167bbad014c086e06f06c.jpg'),
          // ),
        ),
      ),
    );
  }
}
