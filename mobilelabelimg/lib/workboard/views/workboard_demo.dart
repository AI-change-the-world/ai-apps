import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobilelabelimg/entity/imageObjs.dart';
import 'package:mobilelabelimg/utils/common.dart';
import 'package:mobilelabelimg/workboard/bloc/workboard_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

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

  String _filepath =
      "http://h.hiphotos.baidu.com/zhidao/wh%3D450%2C600/sign=0d023672312ac65c67506e77cec29e27/9f2f070828381f30dea167bbad014c086e06f06c.jpg";

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
              image: NetworkImage(_filepath),
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
                onPressed: () async {
                  // print(_filepath.split("/").last);

                  Annotation annotation = Annotation();

                  String _name, _ext;
                  _name = _filepath.split("/").last.split(".").first;
                  _ext = _filepath.split("/").last.split(".").last;

                  annotation.filename = _name + "." + _ext;
                  annotation.path = _filepath;
                  annotation.source = Source();
                  annotation.size = ClassSize(
                      width: CommonUtil.screenW().floor(),
                      height: CommonUtil.screenH().floor());
                  annotation.segmented = 0;
                  annotation.object = [];

                  print(_name);
                  print(_ext);
                  for (var rect in _workboardBloc.state.rectBoxes) {
                    // print(rect.rectKey.currentState!.className);
                    // print(rect.rectKey.currentState!.getRectBox());
                    ClassObject classObject = ClassObject();
                    classObject.name = rect.rectKey.currentState!.className;
                    classObject.difficult = 0;
                    Bndbox bndbox = Bndbox();
                    bndbox.xmin = rect.rectKey.currentState!.getRectBox()[0];
                    bndbox.ymin = rect.rectKey.currentState!.getRectBox()[1];
                    bndbox.xmax = rect.rectKey.currentState!.getRectBox()[2];
                    bndbox.ymax = rect.rectKey.currentState!.getRectBox()[3];
                    classObject.bndbox = bndbox;
                    annotation.object!.add(classObject);
                  }
                  ImageObjs imageObjs = ImageObjs(annotation: annotation);
                  // print(imageObjs.toXmlStr());
                  if (await Permission.storage.request().isGranted) {
                    getApplicationDocumentsDirectory().then((value) async {
                      print(value.path);
                      File file = new File(value.path + "/" + _name + ".xml");
                      try {
                        await file.writeAsString(imageObjs.toXmlStr());
                      } catch (e) {
                        print(e);
                      }

                      File testReadFile =
                          File(value.path + "/" + _name + ".xml");
                      try {
                        String content = testReadFile.readAsStringSync();
                        print(content);
                      } catch (e) {
                        print(e);
                      }
                    });
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
