/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2021-08-02 19:10:24
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2021-08-03 20:59:58
 */

import 'package:auto_test_web/pages/main/bloc/center_widget_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  _SideMenuState createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  late CenterWidgetBloc _centerWidgetBloc;
  @override
  void initState() {
    super.initState();
    _centerWidgetBloc = context.read<CenterWidgetBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CenterWidgetBloc, CenterWidgetState>(
        builder: (context, state) {
      return Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Image.asset("assets/images/logo2.jpg"),
            ),
            DrawerListTile(
              title: "创建一个新项目",
              svgSrc: "assets/icons/menu_dashbord.svg",
              press: () {
                _centerWidgetBloc.add(const WidgetAdd(widgetName: "创建一个新项目"));
              },
            ),
            DrawerListTile(
              title: "Transaction",
              svgSrc: "assets/icons/menu_tran.svg",
              press: () {
                _centerWidgetBloc
                    .add(const WidgetAdd(widgetName: "Transaction"));
              },
            ),
            DrawerListTile(
              title: "Task",
              svgSrc: "assets/icons/menu_task.svg",
              press: () {},
            ),
            DrawerListTile(
              title: "Documents",
              svgSrc: "assets/icons/menu_doc.svg",
              press: () {},
            ),
            DrawerListTile(
              title: "Store",
              svgSrc: "assets/icons/menu_store.svg",
              press: () {},
            ),
            DrawerListTile(
              title: "Notification",
              svgSrc: "assets/icons/menu_notification.svg",
              press: () {},
            ),
            DrawerListTile(
              title: "Profile",
              svgSrc: "assets/icons/menu_profile.svg",
              press: () {},
            ),
            DrawerListTile(
              title: "Settings",
              svgSrc: "assets/icons/menu_setting.svg",
              press: () {},
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
        color: Colors.white54,
        height: 16,
      ),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white54),
      ),
    );
  }
}

class MyTab extends StatefulWidget {
  MyTab({Key? key, required this.text}) : super(key: key);
  final String text;

  @override
  _MyTabState createState() => _MyTabState();
}

class _MyTabState extends State<MyTab> {
  late CenterWidgetBloc _centerWidgetBloc;

  @override
  void initState() {
    super.initState();
    _centerWidgetBloc = context.read<CenterWidgetBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CenterWidgetBloc, CenterWidgetState>(
        builder: (context, state) {
      return GestureDetector(
        onTap: () {
          // debugPrint(widget.text);
          _centerWidgetBloc.add(WidgetAdd(widgetName: widget.text));
        },
        child: Container(
          margin: const EdgeInsets.only(left: 10, right: 10),
          padding: const EdgeInsets.only(left: 20, right: 20),
          height: 50,
          decoration: const BoxDecoration(
            color: Colors.blueAccent,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          ),
          // width: 100,
          child: Row(
            children: [
              Text(
                widget.text,
                style: _centerWidgetBloc.state.currentTabName == widget.text
                    ? const TextStyle(color: Colors.red)
                    : null,
              ),
              if (widget.text != "首页")
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    _centerWidgetBloc
                        .add(WidgetDelete(widgetName: widget.text));
                  },
                ),
            ],
          ),
        ),
      );
    });
  }
}
