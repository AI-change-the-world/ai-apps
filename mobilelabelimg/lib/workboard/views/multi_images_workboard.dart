import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobilelabelimg/workboard/bloc/workboard_bloc.dart';

const _size = 50.0;

class MultiImageAnnotationPage extends StatelessWidget {
  const MultiImageAnnotationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        child: MultiAnnotationWorkBoard(),
        create: (BuildContext context) {
          return WorkboardBloc()..add(RectIntial());
        });
  }
}

class MultiAnnotationWorkBoard extends StatefulWidget {
  MultiAnnotationWorkBoard({Key? key}) : super(key: key);

  @override
  _MultiAnnotationWorkBoardState createState() =>
      _MultiAnnotationWorkBoardState();
}

class _MultiAnnotationWorkBoardState extends State<MultiAnnotationWorkBoard> {
  late WorkboardBloc _workboardBloc;
  late int currentId;
  String? xmlSavedPath;

  @override
  void initState() {
    super.initState();
    _workboardBloc = context.read<WorkboardBloc>();
    // if (_workboardBloc.state.param.rectBoxes.isEmpty) {
    //   currentId = -1;
    // } else {
    //   currentId = _workboardBloc.state.param.rectBoxes.last.id;
    // }
  }

  @override
  Widget build(BuildContext context) {
    List<String>? imgPaths =
        ModalRoute.of(context)!.settings.arguments as List<String>;
    if (null != imgPaths) {
      print("=====================");
      print(imgPaths);
      print("=====================");
    }

    return BlocBuilder<WorkboardBloc, WorkboardState>(
        builder: (context, state) {
      return Scaffold(
        body: SafeArea(
          child: Text("asadsasdsa"),
        ),
      );
    });
  }
}
