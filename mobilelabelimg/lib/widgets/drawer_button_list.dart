import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobilelabelimg/entity/PolygonEntity.dart';
import 'package:mobilelabelimg/entity/imageObjs.dart';
import 'package:mobilelabelimg/entity/labelmeObj.dart';
import 'package:mobilelabelimg/utils/common.dart';
import 'package:mobilelabelimg/widgets/polygon.dart';
import 'package:mobilelabelimg/workboard/bloc/polygon_workboard_bloc.dart';
import 'package:mobilelabelimg/workboard/bloc/workboard_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class DraggableButton extends StatefulWidget {
  DraggableButton({Key? key, required this.scaffoldKey, required this.type})
      : super(key: key);
  GlobalKey<ScaffoldState> scaffoldKey;
  int type;

  @override
  DraggableButtonState createState() => DraggableButtonState();
}

class DraggableButtonState extends State<DraggableButton> {
  double defaultButtonLeft = CommonUtil.screenW() * 0.8;
  double defaultButtonTop = 100.0;
  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: defaultButtonLeft,
        top: defaultButtonTop,
        child: Draggable(
          onDragUpdate: (details) {
            // print(details.globalPosition);
            setState(() {
              defaultButtonLeft = details.globalPosition.dx - 0.5 * buttonSize;
              defaultButtonTop = details.globalPosition.dy - 0.5 * buttonSize;
            });
          },
          feedback: Container(),
          child: IconButton(
            icon: Icon(
              Icons.work,
              color: Colors.yellow,
              size: buttonSize,
            ),
            onPressed: () {
              if (!widget.scaffoldKey.currentState!.isDrawerOpen) {
                widget.scaffoldKey.currentState!.openDrawer();
              }
            },
          ),
        ));
  }
}

// ignore: must_be_immutable
class ToolsListWidget extends StatefulWidget {
  /// type 0, labelImg single image;
  /// type 1 labelme single image
  int type;
  String imgPath;
  ToolsListWidget({Key? key, required this.type, required this.imgPath})
      : super(key: key);

  @override
  _ToolsListWidgetState createState() => _ToolsListWidgetState();
}

class _ToolsListWidgetState extends State<ToolsListWidget> {
  var _workboardBloc;
  late int currentId;
  String? xmlSavedPath;

  // late PolygonWorkboardBloc _polygonWorkboardBloc;

  @override
  void initState() {
    super.initState();
    if (widget.type == 0) {
      _workboardBloc = context.read<WorkboardBloc>();
      if (_workboardBloc.state.param.rectBoxes.isEmpty) {
        currentId = -1;
      } else {
        currentId = _workboardBloc.state.param.rectBoxes.last.id;
      }
    } else {
      _workboardBloc = context.read<PolygonWorkboardBloc>();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.type == 0
        ? BlocBuilder<WorkboardBloc, WorkboardState>(builder: (context, state) {
            return Drawer(
              child: ListView(
                children: [
                  DrawerHeader(
                    child: Text(_workboardBloc.state.param.imageName),
                  ),
                  DrawerListTile(
                    title: "添加一个新的标注",
                    svgSrc: "assets/icons/menu_dashbord.svg",
                    press: () {
                      currentId += 1;
                      _workboardBloc.add(RectAdded(id: currentId));
                      Navigator.pop(context);
                    },
                  ),
                  DrawerListTile(
                      title: "保存标注(xml)",
                      svgSrc: "assets/icons/menu_tran.svg",
                      press: () async {
                        Annotation annotation = Annotation();

                        String _name, _ext;
                        _name = widget.imgPath.split("/").last.split(".").first;
                        _ext = widget.imgPath.split("/").last.split(".").last;

                        annotation.filename = _name + "." + _ext;
                        annotation.path = widget.imgPath;
                        annotation.source = Source();
                        annotation.size = ClassSize(
                            width: CommonUtil.screenW().floor(),
                            height: CommonUtil.screenH().floor());
                        annotation.segmented = 0;
                        annotation.object = [];

                        // print(_name);
                        // print(_ext);
                        for (var rect in _workboardBloc.state.param.rectBoxes) {
                          // print(rect.rectKey.currentState!.className);
                          // print(rect.rectKey.currentState!.getRectBox());
                          ClassObject classObject = ClassObject();
                          classObject.name =
                              rect.rectKey.currentState!.className;
                          classObject.difficult = 0;
                          Bndbox bndbox = Bndbox();
                          bndbox.xmin =
                              rect.rectKey.currentState!.getRectBox()[0];
                          bndbox.ymin =
                              rect.rectKey.currentState!.getRectBox()[1];
                          bndbox.xmax =
                              rect.rectKey.currentState!.getRectBox()[2];
                          bndbox.ymax =
                              rect.rectKey.currentState!.getRectBox()[3];
                          classObject.bndbox = bndbox;
                          annotation.object!.add(classObject);
                        }
                        ImageObjs imageObjs = ImageObjs(annotation: annotation);
                        // print(imageObjs.toXmlStr());
                        if (await Permission.storage.request().isGranted) {
                          getExternalStorageDirectory().then((value) async {
                            // print(value!.path);
                            File file =
                                new File(value!.path + "/" + _name + ".xml");
                            try {
                              await file.writeAsString(imageObjs.toXmlStr());
                              xmlSavedPath = value.path + "/" + _name + ".xml";
                              Fluttertoast.showToast(
                                  msg: "保存成功",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 2,
                                  backgroundColor: Colors.blue,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            } catch (e) {
                              print(e);
                              Fluttertoast.showToast(
                                  msg: "写入文件失败",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 2,
                                  backgroundColor: Colors.blue,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }
                          });
                        }
                        Navigator.pop(context);
                      }),
                  DrawerListTile(
                    title: "切换图片",
                    svgSrc: "assets/icons/menu_task.svg",
                    press: () async {
                      if (await Permission.storage.request().isGranted) {
                        FilePickerResult? image = await FilePicker.platform
                            .pickFiles(type: FileType.image);
                        if (null != image) {
                          File file = File(image.files.single.path!);
                          String _imagePath = file.path;
                          _workboardBloc.add(RectIntial());
                          // (_workboardBloc as WorkboardBloc).state.param.imagePath =
                          _workboardBloc
                              .add(GetSingleImageRects(filename: _imagePath));

                          // setState(() {
                          // imgPath = _imagePath;
                          // });
                          Navigator.of(context).pop();
                        }
                      } else {
                        Fluttertoast.showToast(
                            msg: "需要同意权限才能使用功能",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 2,
                            backgroundColor: Colors.blue,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }
                      Navigator.pop(context);
                    },
                  ),
                  DrawerListTile(
                    title: "退回到主页",
                    svgSrc: "assets/icons/menu_setting.svg",
                    press: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                  ),
                ],
              ),
            );
          })
        : BlocBuilder<PolygonWorkboardBloc, PolygonWorkboardState>(
            builder: (context, state) {
            return Drawer(
              child: ListView(
                children: [
                  DrawerListTile(
                    title: "新建一个标注",
                    svgSrc: "assets/icons/menu_doc.svg",
                    press: () {
                      if (context.read<DrawingProvicer>().status ==
                          DrawingStatus.drawing) {
                        Fluttertoast.showToast(
                            msg: "当前绘画未完成",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 2,
                            backgroundColor: Colors.blue,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      } else {
                        context
                            .read<DrawingProvicer>()
                            .changeStatus(DrawingStatus.drawing);

                        if ((_workboardBloc as PolygonWorkboardBloc)
                                .state
                                .listPolygonEntity
                                .isEmpty ||
                            ((_workboardBloc as PolygonWorkboardBloc)
                                .state
                                .listPolygonEntity
                                .last
                                .pList
                                .isNotEmpty)) {
                          PolygonEntity polygonEntity = PolygonEntity(
                              keyList: [],
                              pList: [],
                              className: "",
                              index: (_workboardBloc as PolygonWorkboardBloc)
                                      .state
                                      .listPolygonEntity
                                      .length +
                                  1);
                          (_workboardBloc as PolygonWorkboardBloc)
                              .add(PolygonEntityAddEvent(p: polygonEntity));
                          // (_workboardBloc as PolygonWorkboardBloc)
                          //     .add(WidgetAddEvent(
                          //         w: PolygonPoint(
                          //   poffset: Offset(-1, -1),
                          //   index: -1,
                          //   isFirst: false,
                          // )));
                        } else {
                          Fluttertoast.showToast(
                              msg: "存在一个未使用的polygon",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 2,
                              backgroundColor: Colors.blue,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }
                      }

                      Navigator.pop(context);
                    },
                  ),
                  DrawerListTile(
                    title: "保存标注信息(Json)",
                    svgSrc: "assets/icons/menu_store.svg",
                    press: () async {
                      LabelmeObject labelmeObject = LabelmeObject();
                      String imgPath = (_workboardBloc as PolygonWorkboardBloc)
                          .state
                          .imgPath;

                      File _f = File(imgPath);
                      List<int> bytes = await _f.readAsBytes();
                      String m = base64.encode(bytes);

                      labelmeObject.imageData = m;
                      labelmeObject.imageHeight = CommonUtil.screenH().ceil();
                      labelmeObject.imageWidth = CommonUtil.screenW().ceil();
                      labelmeObject.flags = {};
                      labelmeObject.version = labelmeVersion;
                      List<Shapes> shapes = [];
                      for (var i in (_workboardBloc as PolygonWorkboardBloc)
                          .state
                          .listPolygonEntity) {
                        Shapes _shapes = Shapes();
                        _shapes.flags = {};
                        _shapes.label = i.className;
                        _shapes.groupId = "0";
                        _shapes.shapeType = labelmeShapeType;
                        List _ppoints = [];

                        for (var p in i.keyList) {
                          int _left = p.currentState!.defaultLeft.ceil();
                          int _top = p.currentState!.defaultTop.ceil();
                          _ppoints.add([_left, _top]);
                        }
                        _shapes.points = _ppoints;
                        shapes.add(_shapes);
                      }
                      labelmeObject.shapes = shapes;

                      // print(labelmeObject.toJson());

                      String _name, _ext;
                      _name = widget.imgPath.split("/").last.split(".").first;
                      _ext = widget.imgPath.split("/").last.split(".").last;

                      if (await Permission.storage.request().isGranted) {
                        getExternalStorageDirectory().then((value) async {
                          // print(value!.path);
                          File file =
                              new File(value!.path + "/" + _name + ".json");
                          try {
                            await file.writeAsString(
                                json.encode(labelmeObject.toJson()));
                            xmlSavedPath = value.path + "/" + _name + ".xml";
                            Fluttertoast.showToast(
                                msg: "保存成功",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 2,
                                backgroundColor: Colors.blue,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          } catch (e) {
                            print(e);
                            Fluttertoast.showToast(
                                msg: "写入文件失败",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 2,
                                backgroundColor: Colors.blue,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          }
                        });
                      }

                      Navigator.pop(context);
                    },
                  ),
                  DrawerListTile(
                    title: "切换图片",
                    svgSrc: "assets/icons/menu_profile.svg",
                    press: () {
                      Navigator.pop(context);
                    },
                  ),
                  DrawerListTile(
                    title: "退回到主页",
                    svgSrc: "assets/icons/menu_notification.svg",
                    press: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                  ),
                ],
              ),
            );
          });
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.svgSrc,
    required this.press,
  }) : super(key: key);

  final String title, svgSrc;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: SvgPicture.asset(
        svgSrc,
        color: Colors.black54,
        height: 16,
      ),
      title: Text(
        title,
        style: const TextStyle(color: Colors.black54),
      ),
    );
  }
}
