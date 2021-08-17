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

  // String? xmlSavedPath;

  // String _filepath = "";

  @override
  void initState() {
    super.initState();
    _workboardBloc = context.read<WorkboardBloc>();
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
            Container(
              decoration: _workboardBloc.state.param.imagePath != ""
                  ? BoxDecoration(
                      image: DecorationImage(
                      fit: BoxFit.fill,
                      image:
                          FileImage(File(_workboardBloc.state.param.imagePath)),
                    ))
                  : null,
              // color: Colors.greenAccent,
              width: double.infinity,
              height: double.infinity,
              child: Stack(
                children: _workboardBloc.state.param.rectBoxes,
              ),
            ),
            DraggableButton(
              scaffoldKey: _scaffoldKey,
              type: 0,
            ),
          ],
        ),
        // floatingActionButton: Container(
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //     children: [
        // FloatingActionButton(
        //   onPressed: () {
        //     showCupertinoDialog(
        //         context: context,
        //         builder: (context) {
        //           return CupertinoAlertDialog(
        //             actions: [
        //               CupertinoActionSheetAction(
        //                   onPressed: () {
        //                     Navigator.of(context).pop();
        //                   },
        //                   child: Text("取消"))
        //             ],
        //             content: Material(
        //               child: Container(
        //                 padding: EdgeInsets.all(10),
        //                 width: 320,
        //                 child: Wrap(
        //                   spacing: 3,
        //                   children: [
        //                     ElevatedButton(
        //                       onPressed: () {
        //                         Navigator.of(context)
        //                             .popUntil((route) => route.isFirst);
        //                       },
        //                       child: Column(
        //                         mainAxisAlignment:
        //                             MainAxisAlignment.center,
        //                         children: [
        //                           Icon(Icons.chevron_left,
        //                               color: Colors.white),
        //                           Text(
        //                             "退出",
        //                             style: TextStyle(color: Colors.black),
        //                           ),
        //                         ],
        //                       ),
        //                       style: ElevatedButton.styleFrom(
        //                         minimumSize: Size(_size, _size),
        //                         shape: CircleBorder(),
        //                         padding: EdgeInsets.all(20),
        //                         primary: Colors.blue, // <-- Button color
        //                         onPrimary: Colors.red, // <-- Splash color
        //                       ),
        //                     ),
        // ElevatedButton(
        //   onPressed: () async {
        //     var result = await showCupertinoDialog(
        //         context: context,
        //         builder: (context) {
        //           return CupertinoAlertDialog(
        //             title: Text("注意！！！"),
        //             content: Text(
        //                 "本产品采用ftp进行上传服务，需输入用户名及密码。本产品不会采集任何用户信息，不过，如对安全风险存在疑问，请使用内网进行传输。"),
        //             actions: [
        //               CupertinoActionSheetAction(
        //                   onPressed: () {
        //                     Navigator.of(context)
        //                         .pop(0);
        //                   },
        //                   child: Text("取消")),
        //               CupertinoActionSheetAction(
        //                   onPressed: () {
        //                     Navigator.of(context)
        //                         .pop(1);
        //                   },
        //                   child: Text("确定")),
        //             ],
        //           );
        //         });

        //     if (result == 1) {
        //       TextEditingController urlController =
        //           TextEditingController();
        //       TextEditingController userController =
        //           TextEditingController();
        //       TextEditingController
        //           passwordController =
        //           TextEditingController();
        //       if (null == xmlSavedPath) {
        //         var value =
        //             await getExternalStorageDirectory();
        //         var _name = imgPath!
        //             .split("/")
        //             .last
        //             .split(".")
        //             .first;
        //         xmlSavedPath = value!.path +
        //             "/" +
        //             _name +
        //             ".xml";
        //       }

        //       if (await File(xmlSavedPath!)
        //           .exists()) {
        //         var _result =
        //             await showCupertinoDialog(
        //                 context: context,
        //                 builder: (context) {
        //                   return CupertinoAlertDialog(
        //                     title: Text("请填写个人信息"),
        //                     content: Material(
        //                       child: Column(
        //                           mainAxisAlignment:
        //                               MainAxisAlignment
        //                                   .start,
        //                           children: [
        //                             Text("请填写url"),
        //                             TextField(
        //                               controller:
        //                                   urlController,
        //                             ),
        //                             Text("请输入用户名"),
        //                             TextField(
        //                               controller:
        //                                   userController,
        //                             ),
        //                             Text("请输入密码"),
        //                             TextField(
        //                               controller:
        //                                   passwordController,
        //                             )
        //                           ]),
        //                     ),
        //                     actions: [
        //                       CupertinoActionSheetAction(
        //                           onPressed: () {
        //                             Navigator.of(
        //                                     context)
        //                                 .pop(0);
        //                           },
        //                           child: Text("取消")),
        //                       CupertinoActionSheetAction(
        //                           onPressed: () {
        //                             Navigator.of(
        //                                     context)
        //                                 .pop(1);
        //                           },
        //                           child: Text("确定")),
        //                     ],
        //                   );
        //                 });
        //         if (_result == 1) {
        //           FTPConnect ftpConnect = FTPConnect(
        //               urlController.text,
        //               user: userController.text,
        //               pass: passwordController.text);
        //           try {
        //             File fileToUpload =
        //                 File(xmlSavedPath!);
        //             await ftpConnect.connect();
        //             await ftpConnect
        //                 .uploadFile(fileToUpload);
        //             await ftpConnect.disconnect();
        //             Fluttertoast.showToast(
        //                 msg: "上传成功",
        //                 toastLength:
        //                     Toast.LENGTH_SHORT,
        //                 gravity: ToastGravity.CENTER,
        //                 timeInSecForIosWeb: 2,
        //                 backgroundColor:
        //                     Colors.orange,
        //                 textColor: Colors.white,
        //                 fontSize: 16.0);
        //           } catch (e) {
        //             Fluttertoast.showToast(
        //                 msg: "上传失败",
        //                 toastLength:
        //                     Toast.LENGTH_SHORT,
        //                 gravity: ToastGravity.CENTER,
        //                 timeInSecForIosWeb: 2,
        //                 backgroundColor:
        //                     Colors.orange,
        //                 textColor: Colors.white,
        //                 fontSize: 16.0);
        //           }
        //         }
        //       } else {
        //         Fluttertoast.showToast(
        //             msg: "未检测到存储文件",
        //             toastLength: Toast.LENGTH_SHORT,
        //             gravity: ToastGravity.CENTER,
        //             timeInSecForIosWeb: 2,
        //             backgroundColor: Colors.orange,
        //             textColor: Colors.white,
        //             fontSize: 16.0);
        //       }
        //     }

        //     Navigator.of(context).pop();
        //   },
        //   child: Column(
        //     mainAxisAlignment:
        //         MainAxisAlignment.center,
        //     children: [
        //       Icon(Icons.upload_file,
        //           color: Colors.white),
        //       Text(
        //         "上传",
        //         style: TextStyle(color: Colors.black),
        //       ),
        //     ],
        //   ),
        //   style: ElevatedButton.styleFrom(
        //     minimumSize: Size(_size, _size),
        //     shape: CircleBorder(),
        //     padding: EdgeInsets.all(20),
        //     primary: Colors.blue, // <-- Button color
        //     onPrimary: Colors.red, // <-- Splash color
        //   ),
        // ),
        // ElevatedButton(
        //   onPressed: () {
        //     Fluttertoast.showToast(
        //         msg: "当前模式下不支持下一张",
        //         toastLength: Toast.LENGTH_SHORT,
        //         gravity: ToastGravity.CENTER,
        //         timeInSecForIosWeb: 2,
        //         backgroundColor: Colors.blue,
        //         textColor: Colors.white,
        //         fontSize: 16.0);
        // },
        //   child: Column(
        //     mainAxisAlignment:
        //         MainAxisAlignment.center,
        //     children: [
        //       Icon(Icons.skip_next,
        //           color: Colors.white),
        //       Text(
        //         "next",
        //         style: TextStyle(color: Colors.black),
        //       ),
        //     ],
        //   ),
        //   style: ElevatedButton.styleFrom(
        //     shape: CircleBorder(),
        //     minimumSize: Size(_size, _size),
        //     padding: EdgeInsets.all(20),
        //     primary: Colors.blue, // <-- Button color
        //     onPrimary: Colors.red, // <-- Splash color
        //   ),
        // ),
        //                     ElevatedButton(
        //                       onPressed: () async {
        //                         if (await Permission.storage
        //                             .request()
        //                             .isGranted) {
        //                           FilePickerResult? image =
        //                               await FilePicker.platform.pickFiles(
        //                                   type: FileType.image);
        //                           if (null != image) {
        //                             File file =
        //                                 File(image.files.single.path!);
        //                             String _imagePath = file.path;
        //                             _workboardBloc.add(RectIntial());
        //                             _workboardBloc.add(
        //                                 GetSingleImageRects(
        //                                     filename: _imagePath));

        //                             // setState(() {
        //                             imgPath = _imagePath;
        //                             // });
        //                             Navigator.of(context).pop();
        //                           }
        //                         } else {
        //                           Fluttertoast.showToast(
        //                               msg: "需要同意权限才能使用功能",
        //                               toastLength: Toast.LENGTH_SHORT,
        //                               gravity: ToastGravity.CENTER,
        //                               timeInSecForIosWeb: 2,
        //                               backgroundColor: Colors.blue,
        //                               textColor: Colors.white,
        //                               fontSize: 16.0);
        //                         }
        //                       },
        //                       child: Column(
        //                         mainAxisAlignment:
        //                             MainAxisAlignment.center,
        //                         children: [
        //                           Icon(Icons.change_history,
        //                               color: Colors.white),
        //                           Text(
        //                             "切换",
        //                             style: TextStyle(color: Colors.black),
        //                           ),
        //                         ],
        //                       ),
        //                       style: ElevatedButton.styleFrom(
        //                         shape: CircleBorder(),
        //                         minimumSize: Size(_size, _size),
        //                         padding: EdgeInsets.all(20),
        //                         primary: Colors.blue, // <-- Button color
        //                         onPrimary: Colors.red, // <-- Splash color
        //                       ),
        //                     ),
        //                   ],
        //                 ),
        //               ),
        //             ),
        //           );
        //         });
        //   },
        //   heroTag: "tool",
        //   child: Icon(Icons.work),
        // ),
        // FloatingActionButton(
        //   heroTag: "add",
        //   onPressed: () {
        //     // addRect();
        //     currentId += 1;
        //     _workboardBloc.add(RectAdded(id: currentId));
        //   },
        //   child: Icon(Icons.add),
        // ),
        // FloatingActionButton(
        //   heroTag: "save",
        //   onPressed: () async {
        //     // print(_filepath.split("/").last);

        //     Annotation annotation = Annotation();

        //     String _name, _ext;
        //     _name = imgPath!.split("/").last.split(".").first;
        //     _ext = imgPath!.split("/").last.split(".").last;

        //     annotation.filename = _name + "." + _ext;
        //     annotation.path = imgPath;
        //     annotation.source = Source();
        //     annotation.size = ClassSize(
        //         width: CommonUtil.screenW().floor(),
        //         height: CommonUtil.screenH().floor());
        //     annotation.segmented = 0;
        //     annotation.object = [];

        //     // print(_name);
        //     // print(_ext);
        //     for (var rect in _workboardBloc.state.param.rectBoxes) {
        //       // print(rect.rectKey.currentState!.className);
        //       // print(rect.rectKey.currentState!.getRectBox());
        //       ClassObject classObject = ClassObject();
        //       classObject.name = rect.rectKey.currentState!.className;
        //       classObject.difficult = 0;
        //       Bndbox bndbox = Bndbox();
        //       bndbox.xmin = rect.rectKey.currentState!.getRectBox()[0];
        //       bndbox.ymin = rect.rectKey.currentState!.getRectBox()[1];
        //       bndbox.xmax = rect.rectKey.currentState!.getRectBox()[2];
        //       bndbox.ymax = rect.rectKey.currentState!.getRectBox()[3];
        //       classObject.bndbox = bndbox;
        //       annotation.object!.add(classObject);
        //     }
        //     ImageObjs imageObjs = ImageObjs(annotation: annotation);
        //     // print(imageObjs.toXmlStr());
        //     if (await Permission.storage.request().isGranted) {
        //       getExternalStorageDirectory().then((value) async {
        //         // print(value!.path);
        //         File file = new File(value!.path + "/" + _name + ".xml");
        //         try {
        //           await file.writeAsString(imageObjs.toXmlStr());
        //           xmlSavedPath = value.path + "/" + _name + ".xml";
        //           Fluttertoast.showToast(
        //               msg: "保存成功",
        //               toastLength: Toast.LENGTH_SHORT,
        //               gravity: ToastGravity.CENTER,
        //               timeInSecForIosWeb: 2,
        //               backgroundColor: Colors.blue,
        //               textColor: Colors.white,
        //               fontSize: 16.0);
        //         } catch (e) {
        //           print(e);
        //           Fluttertoast.showToast(
        //               msg: "写入文件失败",
        //               toastLength: Toast.LENGTH_SHORT,
        //               gravity: ToastGravity.CENTER,
        //               timeInSecForIosWeb: 2,
        //               backgroundColor: Colors.blue,
        //               textColor: Colors.white,
        //               fontSize: 16.0);
        //         }

        //         File testReadFile =
        //             File(value.path + "/" + _name + ".xml");
        //         try {
        //           String content = testReadFile.readAsStringSync();
        //           print(content);
        //         } catch (e) {
        //           print(e);
        //         }
        //       });
        //     }
        //   },
        //   child: Icon(Icons.save),
        // ),
        // ],
        // ),
      );
    });
  }
}
