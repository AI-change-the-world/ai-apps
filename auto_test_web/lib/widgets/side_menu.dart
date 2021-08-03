/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2021-08-02 19:10:24
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2021-08-02 19:11:57
 */

import 'package:auto_test_web/pages/main/main_page_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Image.asset("assets/images/logo2.jpg"),
          ),
          DrawerListTile(
            title: "Dashboard",
            svgSrc: "assets/icons/menu_dashbord.svg",
            press: () {
              context
                  .read<ListTabsController>()
                  .addTab(MyTab(text: "Dashboard"));
              context.read<CenterWidgetController>().update("Dashboard");
            },
          ),
          DrawerListTile(
            title: "Transaction",
            svgSrc: "assets/icons/menu_tran.svg",
            press: () {
              context
                  .read<ListTabsController>()
                  .addTab(MyTab(text: "Transaction"));
              context.read<CenterWidgetController>().update("Transaction");
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
        style: TextStyle(color: Colors.white54),
      ),
    );
  }
}

class MyTab extends StatefulWidget {
  MyTab({Key? key, required this.text}) : super(key: key);
  final String text;

  @override
  _MyTabState createState() => _MyTabState();

  @override
  // TODO: implement hashCode
  int get hashCode => super.hashCode;
}

class _MyTabState extends State<MyTab> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // debugPrint(widget.text);
        setState(() {
          context.read<CenterWidgetController>().update(widget.text);
        });
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
            Text(widget.text),
            if (widget.text != "首页")
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  context.read<ListTabsController>().removeTab(widget);
                  context.read<CenterWidgetController>().update("首页");
                },
              ),
          ],
        ),
      ),
    );
  }
}
