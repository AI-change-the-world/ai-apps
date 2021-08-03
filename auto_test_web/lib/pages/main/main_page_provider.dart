/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2021-08-02 19:00:01
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2021-08-02 19:01:57
 */

import 'dart:convert';
import 'dart:io';

import 'package:auto_test_web/utils/common.dart';
import 'package:auto_test_web/utils/platform_utils.dart';
import 'package:auto_test_web/widgets/side_menu.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MenuController extends ChangeNotifier {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  void controlMenu() {
    if (!_scaffoldKey.currentState!.isDrawerOpen) {
      _scaffoldKey.currentState!.openDrawer();
    }
  }
}

class ListTabsController extends ChangeNotifier {
  List<Widget> _tabs = [
    MyTab(text: "首页"),
  ];
  List<Widget> get tabs => _tabs;
  List<String> _tabNames = ["首页"];
  String _activateStr = "首页";
  String get activateStr => _activateStr;

  addTab(MyTab tab) {
    if (!_tabNames.contains(tab.text)) {
      _tabs.add(tab);
      _tabNames.add(tab.text);
      _activateStr = tab.text;
      notifyListeners();
    }
  }

  removeTab(MyTab tab) {
    int id = _tabNames.indexOf(tab.text);
    _tabs.removeAt(id);
    _tabNames.removeAt(id);
    _activateStr = "首页";
    notifyListeners();
  }
}

class CenterWidgetController extends ChangeNotifier {
  // String _former = "首页";
  String _activateStr = "首页";
  String get activateStr => _activateStr;
  Widget get currentCenterWidget => MainCenterWidget(widgetName: _activateStr);

  update(String val) {
    debugPrint(val);
    _activateStr = val;
    notifyListeners();
  }
}

class MainCenterWidget extends StatefulWidget {
  String widgetName;
  MainCenterWidget({Key? key, required this.widgetName}) : super(key: key);

  @override
  MainCenterWidgetState createState() => MainCenterWidgetState();
}

class MainCenterWidgetState extends State<MainCenterWidget> {
  final TextEditingController _textEditingController = TextEditingController();

  bool execAble = false;

  @override
  void dispose() {
    // TODO: implement dispose
    if (!mounted) {
      _textEditingController.dispose();
    }

    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _textEditingController.addListener(() {
      if (_textEditingController.text == "") {
        setState(() {
          execAble = false;
        });
      } else {
        setState(() {
          execAble = true;
        });
      }
    });
  }

  void refresh() {
    setState(() {
      debugPrint(widget.widgetName);
    });
  }

  @override
  Widget build(BuildContext context) {
    late Widget body;

    switch (widget.widgetName) {
      case "首页":
        body = getMainForm();
        break;
      case "Dashboard":
        body = getUploadForm();
        break;
      default:
        body = const Center(
          child: Text("这是个测试表格"),
        );
        break;
    }

    return body;
  }

  Widget getMainForm() {
    return Container(
      height: 0.7 * CommonUtils.screenH(),
      child: const Center(
        child: Text("自零伊始，从壹而终"),
      ),
    );
  }

  Widget getUploadForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text("输入json:"),
              const SizedBox(
                width: 30,
              ),
              ElevatedButton(
                  onPressed: !execAble
                      ? null
                      : () {
                          try {
                            var _jsonStr = _textEditingController.text;
                            var _json = jsonDecode(_jsonStr);
                          } catch (e) {
                            showCupertinoDialog(
                                context: context,
                                builder: (context) {
                                  return CupertinoAlertDialog(
                                    title: const Text("json 解析错误"),
                                    actions: [
                                      CupertinoActionSheetAction(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text("确定")),
                                    ],
                                  );
                                });
                          }
                        },
                  child: const Text("验证json正确性"))
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: _textEditingController,
            keyboardType: TextInputType.multiline,
            maxLines: null,
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
              onPressed: () async {
                FilePickerResult? result =
                    await FilePicker.platform.pickFiles();

                if (result != null) {
                  if (PlatformUtils.isWeb) {
                    debugPrint(result.files.first.bytes.toString());
                  }
                  // debugPrint(result.files.single.path!);
                  // File file = File(result.files.single.path!);
                  // try {
                  //   var contents = await file.readAsString();
                  //   var _json = jsonDecode(contents);
                  //   debugPrint(_json.toString());
                  // } catch (e) {
                  //   debugPrint(e.toString());
                  //   debugPrint("文件读取错误");
                  // }
                  // debugPrint(result.files.single.path!);
                } else {
                  // User canceled the picker
                }
              },
              child: const Text("选择文件上传"))
        ],
      ),
    );
  }
}
