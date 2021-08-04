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
import 'package:auto_test_web/widgets/create_project_widget.dart';
import 'package:auto_test_web/widgets/side_menu.dart';
import 'package:auto_test_web/widgets/welcome_widget.dart';
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

class MainCenterWidget extends StatelessWidget {
  String widgetName;
  MainCenterWidget({Key? key, required this.widgetName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late Widget body;

    switch (widgetName) {
      case "首页":
        body = const WelcomeWidget();
        break;
      case "Dashboard":
        body = NewProjectWidget();
        break;
      default:
        body = const Center(
          child: Text("这是个测试表格"),
        );
        break;
    }

    return body;
  }
}
