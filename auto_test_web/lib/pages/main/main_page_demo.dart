/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2021-08-02 19:02:28
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2021-08-03 20:45:37
 */

import 'package:auto_test_web/pages/main/bloc/center_widget_bloc.dart';
import 'package:auto_test_web/pages/main/main_page_center_widget_demo.dart';
import 'package:auto_test_web/pages/main/main_page_provider.dart';
import 'package:auto_test_web/utils/common.dart';
import 'package:auto_test_web/widgets/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => MenuController(),
          ),
          ChangeNotifierProvider(
            create: (context) => LoadingController(),
          ),
        ],
        child: MainPageDemo(),
      ),
    );
  }
}

class MainPageDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return CenterWidgetBloc()..add(WidgetInit());
      },
      child: Scaffold(
        drawer: SideMenu(),
        key: context.read<MenuController>().scaffoldKey,
        body: SafeArea(
            child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Responsive.isDesktop(context)) SideMenu(),
            Expanded(
              flex: 5,
              child: CenterWidget(),
            )
          ],
        )),
      ),
    );
  }
}
