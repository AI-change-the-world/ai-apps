import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobilelabelimg/widgets/drawer_button_list.dart';
import 'package:mobilelabelimg/workboard/bloc/workboard_bloc.dart';

// const _size = 50.0;

class SingleImageAnnotationPage extends StatelessWidget {
  const SingleImageAnnotationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        child: SingleAnnotationWorkBoard(),
        create: (BuildContext context) {
          return WorkboardBloc()..add(RectIntial());
        });
  }
}

class SingleAnnotationWorkBoard extends StatefulWidget {
  SingleAnnotationWorkBoard({Key? key}) : super(key: key);

  @override
  _SingleAnnotationWorkBoardState createState() =>
      _SingleAnnotationWorkBoardState();
}

class _SingleAnnotationWorkBoardState extends State<SingleAnnotationWorkBoard> {
  // List<Widget> rects = [];
  late WorkboardBloc _workboardBloc;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TransformationController _maxMinController = TransformationController();
  double currentFactor = 1.0;
  double smallFactor = 0.9;
  double largerFactor = 1.1;

  @override
  void initState() {
    super.initState();
    _workboardBloc = context.read<WorkboardBloc>();
    _maxMinController.value = Matrix4.identity();
    // print(_maxMinController.value);
  }

  void smaller() {
    currentFactor = currentFactor * smallFactor;
    if (currentFactor <= 0.8) {
      currentFactor = 0.8;
      _maxMinController.value = Matrix4.identity() * 0.8;
    } else {
      _maxMinController.value = Matrix4.identity() * currentFactor;
    }
    if (currentFactor != 0.8)
      _workboardBloc.add(ChangeFactorEvent(factor: currentFactor));
  }

  void larger() {
    currentFactor = currentFactor * largerFactor;
    if (currentFactor >= 2.5) {
      currentFactor = 2.5;
      _maxMinController.value = Matrix4.identity() * 2.5;
    } else {
      _maxMinController.value = Matrix4.identity() * currentFactor;
    }
    if (currentFactor != 2.5)
      _workboardBloc.add(ChangeFactorEvent(factor: currentFactor));
  }

  @override
  void dispose() {
    _maxMinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String? imgPath = ModalRoute.of(context)!.settings.arguments as String;
    // _filepath = imgPath!;
    _workboardBloc.add(GetSingleImageRects(filename: imgPath));
    return BlocBuilder<WorkboardBloc, WorkboardState>(
        builder: (context, state) {
      return Scaffold(
        key: _scaffoldKey,
        drawer: ToolsListWidget(
          type: 0,
          imgPath: _workboardBloc.state.param.imagePath,
        ),
        body: Stack(
          children: [
            InteractiveViewer(
                transformationController: _maxMinController,
                boundaryMargin: EdgeInsets.zero,
                child: Container(
                  decoration: _workboardBloc.state.param.imagePath != ""
                      ? BoxDecoration(
                          image: DecorationImage(
                          fit: BoxFit.fill,
                          image: FileImage(
                              File(_workboardBloc.state.param.imagePath)),
                        ))
                      : null,
                  // color: Colors.greenAccent,
                  width: double.infinity,
                  height: double.infinity,
                  child: Stack(
                    children: _workboardBloc.state.param.rectBoxes,
                  ),
                )),
            DraggableButton(
              scaffoldKey: _scaffoldKey,
              type: 0,
            ),
            Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  color: Colors.yellow,
                  alignment: Alignment.bottomRight,
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            print("放大");
                            larger();
                          },
                          icon: ImageIcon(AssetImage("assets/icons/plus.png"))),
                      IconButton(
                          onPressed: () {
                            print("缩小");
                            smaller();
                          },
                          icon:
                              ImageIcon(AssetImage("assets/icons/minus.png"))),
                    ],
                  ),
                ))
          ],
        ),
      );
    });
  }
}
