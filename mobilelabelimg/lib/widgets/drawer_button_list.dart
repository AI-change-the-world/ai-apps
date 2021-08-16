import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobilelabelimg/entity/imageObjs.dart';
import 'package:mobilelabelimg/utils/common.dart';
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
          // onDraggableCanceled: (Velocity velocity, Offset _offset) {
          //   setState(() {
          //     defaultButtonLeft = _offset.dx;
          //     defaultButtonTop = _offset.dy;
          //   });
          // },
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
  late WorkboardBloc _workboardBloc;
  late int currentId;
  String? xmlSavedPath;

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
    return BlocBuilder<WorkboardBloc, WorkboardState>(
        builder: (context, state) {
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
              },
            ),
            DrawerListTile(
                title: "保存标注",
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
                      // print(value!.path);
                      File file = new File(value!.path + "/" + _name + ".xml");
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
                }),
            DrawerListTile(
              title: "退回到主页",
              svgSrc: "assets/icons/menu_task.svg",
              press: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
            // DrawerListTile(
            //   title: "Documents",
            //   svgSrc: "assets/icons/menu_doc.svg",
            //   press: () {},
            // ),
            // DrawerListTile(
            //   title: "Store",
            //   svgSrc: "assets/icons/menu_store.svg",
            //   press: () {},
            // ),
            // DrawerListTile(
            //   title: "Notification",
            //   svgSrc: "assets/icons/menu_notification.svg",
            //   press: () {},
            // ),
            // DrawerListTile(
            //   title: "Profile",
            //   svgSrc: "assets/icons/menu_profile.svg",
            //   press: () {},
            // ),
            // DrawerListTile(
            //   title: "Settings",
            //   svgSrc: "assets/icons/menu_setting.svg",
            //   press: () {},
            // ),
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
