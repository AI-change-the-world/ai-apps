import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobilelabelimg/entity/imageObjs.dart';
import 'package:mobilelabelimg/utils/common.dart';
import 'package:mobilelabelimg/workboard/bloc/workboard_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

const _size = 50.0;

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

  late int currentId;

  // String _filepath = "";

  @override
  void initState() {
    super.initState();
    _workboardBloc = context.read<WorkboardBloc>();
    if (_workboardBloc.state.param.rectBoxes.isEmpty) {
      currentId = -1;
    } else {
      currentId = _workboardBloc.state.param.rectBoxes.last.id;
    }
  }

  @override
  Widget build(BuildContext context) {
    final String? imgPath =
        ModalRoute.of(context)!.settings.arguments as String;
    // _filepath = imgPath!;
    _workboardBloc.add(GetSingleImageRects(filename: imgPath!));
    return BlocBuilder<WorkboardBloc, WorkboardState>(
        builder: (context, state) {
      return Scaffold(
        body: SafeArea(
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
              fit: BoxFit.fill,
              image: FileImage(File(imgPath)),
            )),
            // color: Colors.greenAccent,
            width: double.infinity,
            height: double.infinity,
            child: Stack(
              children: _workboardBloc.state.param.rectBoxes,
            ),
          ),
        ),
        floatingActionButton: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FloatingActionButton(
                onPressed: () {
                  showCupertinoDialog(
                      context: context,
                      builder: (context) {
                        return CupertinoAlertDialog(
                          actions: [
                            CupertinoActionSheetAction(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text("取消"))
                          ],
                          content: Material(
                            child: Container(
                              padding: EdgeInsets.all(10),
                              width: 320,
                              child: Wrap(
                                spacing: 3,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .popUntil((route) => route.isFirst);
                                    },
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.chevron_left,
                                            color: Colors.white),
                                        Text(
                                          "退出",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ],
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: Size(_size, _size),
                                      shape: CircleBorder(),
                                      padding: EdgeInsets.all(20),
                                      primary: Colors.blue, // <-- Button color
                                      onPrimary: Colors.red, // <-- Splash color
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {},
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.upload_file,
                                            color: Colors.white),
                                        Text(
                                          "上传",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ],
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: Size(_size, _size),
                                      shape: CircleBorder(),
                                      padding: EdgeInsets.all(20),
                                      primary: Colors.blue, // <-- Button color
                                      onPrimary: Colors.red, // <-- Splash color
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Fluttertoast.showToast(
                                          msg: "当前模式下不支持下一张",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIosWeb: 2,
                                          backgroundColor: Colors.blue,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                    },
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.skip_next,
                                            color: Colors.white),
                                        Text(
                                          "next",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ],
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      shape: CircleBorder(),
                                      minimumSize: Size(_size, _size),
                                      padding: EdgeInsets.all(20),
                                      primary: Colors.blue, // <-- Button color
                                      onPrimary: Colors.red, // <-- Splash color
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                },
                heroTag: "tool",
                child: Icon(Icons.work),
              ),
              FloatingActionButton(
                heroTag: "add",
                onPressed: () {
                  // addRect();
                  currentId += 1;
                  _workboardBloc.add(RectAdded(id: currentId));
                },
                child: Icon(Icons.add),
              ),
              FloatingActionButton(
                heroTag: "save",
                onPressed: () async {
                  // print(_filepath.split("/").last);

                  Annotation annotation = Annotation();

                  String _name, _ext;
                  _name = imgPath.split("/").last.split(".").first;
                  _ext = imgPath.split("/").last.split(".").last;

                  annotation.filename = _name + "." + _ext;
                  annotation.path = imgPath;
                  annotation.source = Source();
                  annotation.size = ClassSize(
                      width: CommonUtil.screenW().floor(),
                      height: CommonUtil.screenH().floor());
                  annotation.segmented = 0;
                  annotation.object = [];

                  print(_name);
                  print(_ext);
                  for (var rect in _workboardBloc.state.param.rectBoxes) {
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
                    getExternalStorageDirectory().then((value) async {
                      print(value!.path);
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
