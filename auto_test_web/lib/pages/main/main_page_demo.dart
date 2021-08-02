/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2021-08-02 19:02:28
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2021-08-02 19:27:35
 */

import 'package:auto_test_web/pages/main/main_page_provider.dart';
import 'package:auto_test_web/utils/common.dart';
import 'package:auto_test_web/widgets/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainPageDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenu(),
      key: context.read<MenuController>().scaffoldKey,
      body: SafeArea(
          child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (Responsive.isDesktop(context))
            Expanded(
              // default flex = 1
              // and it takes 1/6 part of the screen
              child: SideMenu(),
            ),
          Expanded(
              flex: 5,
              child: Center(
                child: Text("居中"),
              ))
        ],
      )),
    );
  }
}
