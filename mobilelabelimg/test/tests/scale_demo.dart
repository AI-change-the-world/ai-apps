import 'package:flutter/material.dart';

// void main() {
//   runApp(SampleApp());
// }

class SampleApp extends StatelessWidget {
  const SampleApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sample App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AnimateApp(),
    );
  }
}

class AnimateApp extends StatefulWidget {
  const AnimateApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AnimateAppState();
  }
}

class _AnimateAppState extends State<AnimateApp>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
//  Animation<double> animation;
  Animation<double?>? animation;

  @override
  void initState() {
    super.initState();

//    线性
//    // 创建 AnimationController 对象
//    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 2000));
//    // 通过 Tween 对象 创建 Animation 对象
//    animation = Tween(begin: 50.0, end: 200.0).animate(controller)
//      ..addListener(() {
//        // 注意：这句不能少，否则 widget 不会重绘，也就看不到动画效果
//        setState(() {});
//      });

////    非线性
//    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 2000));
//// 非线性动画
//    final CurvedAnimation curve = CurvedAnimation(parent: controller, curve: Curves.elasticOut);
//    animation = Tween(begin: 50.0, end: 200.0).animate(curve)
//      ..addListener(() {
//        setState(() {});
//      });

//    通过给 Animation 添加 addStatusListener(...) 来监听当前动画的状态
//    //    非线性
//    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 2000));
//    //    非线性动画
//    final CurvedAnimation curve = CurvedAnimation(parent: controller, curve: Curves.elasticOut);
//    animation = Tween(begin: 50.0, end: 200.0).animate(curve)
//      ..addListener(() {
//        setState(() {});
//      })
//      ..addStatusListener((status) {
//        if (status == AnimationStatus.completed) {//表示动画在结束时停止的状态
//          controller.reverse();//动画反向执行（从后往前）
//        } else if (status == AnimationStatus.dismissed) {//表示动画在开始时就停止的状态
//          controller.forward();//动画正常执行（从前往后）
//        }
//      });

//    Tween 还可以接受 Color 类型的参数，实现颜色渐变的效果，下面让 widget 的颜色从 红色 渐变到 蓝色

    controller = AnimationController(
        duration: const Duration(milliseconds: 3000), vsync: this);
    final CurvedAnimation curve =
        CurvedAnimation(parent: controller, curve: Curves.elasticOut);
    // animation = ColorTween(begin: Colors.redAccent, end: Colors.blue)
    //     .animate(controller)
    //       ..addListener(() {
    //         setState(() {});
    //       })
    //       ..addStatusListener((status) {
    //         if (status == AnimationStatus.completed) {
    //           //表示动画在结束时停止的状态
    //           controller.reverse(); //动画反向执行（从后往前）
    //         } else if (status == AnimationStatus.dismissed) {
    //           //表示动画在开始时就停止的状态
    //           controller.forward(); //动画正常执行（从前往后）
    //         }
    //       });

    animation = Tween(begin: 200.0, end: 600.0).animate(curve)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          //表示动画在结束时停止的状态
          controller.reverse(); //动画反向执行（从后往前）
        } else if (status == AnimationStatus.dismissed) {
          //表示动画在开始时就停止的状态
          controller.forward(); //动画正常执行（从前往后）
        }
      });

    // 执行动画
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'AnimateApp',
        theme: ThemeData(primaryColor: Colors.blue),
        home: Scaffold(
            appBar: AppBar(
              title: Text('AnimateApp'),
            ),
            body: Center(
              child: Container(
                color: Colors.blue,
                child: Text("TTTTTTTTTTTTTTTTTTTTTTTTTTT"),
                // decoration: BoxDecoration(color: animation!.value),
                margin: EdgeInsets.symmetric(vertical: 10.0),
                height: animation!.value,
                width: animation!.value,
              ),
              //  child: Container(
              //    // 获取动画的值赋给 widget 的宽高
              //    width: animation.value,
              //    height: animation.value,
              //    decoration: BoxDecoration(
              //        color: Colors.redAccent
              //    ),
              //  ),
            )));
  }

  @override
  void dispose() {
    // 资源释放
    controller.dispose();
    super.dispose();
  }
}
