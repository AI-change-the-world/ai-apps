import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobilelabelimg/widgets/rect.dart';
import 'package:mobilelabelimg/workboard/bloc/workboard_bloc.dart';

class Demoview extends StatelessWidget {
  const Demoview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        child: WorkBoardDemo(),
        create: (BuildContext context) {
          return WorkboardBloc()..add(RectIntial());
        });
  }
}

class WorkBoardDemo extends StatefulWidget {
  WorkBoardDemo({Key? key}) : super(key: key);

  @override
  _WorkBoardDemoState createState() => _WorkBoardDemoState();
}

class _WorkBoardDemoState extends State<WorkBoardDemo> {
  // List<Widget> rects = [];
  late WorkboardBloc _workboardBloc;

  int currentId = -1;

  @override
  void initState() {
    super.initState();
    _workboardBloc = context.read<WorkboardBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkboardBloc, WorkboardState>(
        builder: (context, state) {
      return Scaffold(
        body: SafeArea(
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
              fit: BoxFit.fill,
              image: NetworkImage(
                  'http://h.hiphotos.baidu.com/zhidao/wh%3D450%2C600/sign=0d023672312ac65c67506e77cec29e27/9f2f070828381f30dea167bbad014c086e06f06c.jpg'),
            )),
            // color: Colors.greenAccent,
            width: double.infinity,
            height: double.infinity,
            child: Stack(
              children: _workboardBloc.state.rectBoxes,
            ),
          ),
        ),
        floatingActionButton: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FloatingActionButton(
                onPressed: () {
                  // addRect();
                  currentId += 1;
                  _workboardBloc.add(RectAdded(id: currentId));
                },
                child: Icon(Icons.add),
              ),
              FloatingActionButton(
                onPressed: () {
                  // addRect();
                  for (var rect in _workboardBloc.state.rectBoxes) {
                    print(rect.rectKey.currentState!.className);
                    print(rect.rectKey.currentState!.getRectBox());
                  }
                },
                child: Icon(Icons.save),
              ),
            ],
          ),
        ),
      );
    });
  }
}
