import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      ///填充布局
      body: SafeArea(
        child: InteractiveViewer(
          alignPanAxis: false,
          boundaryMargin: const EdgeInsets.all(120),
          //对子Widget 进行缩放平移
          child: Image.asset("assets/app_icons/me.jpg"),
        ),
      ),
    );
  }
}
