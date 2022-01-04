/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2021-08-17 19:07:04
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2021-08-17 19:38:31
 */
import 'package:flutter/material.dart';
import 'package:mobilelabelimg/utils/common.dart';
import 'package:mobilelabelimg/utils/routers.dart';
import 'package:flip_card/flip_card.dart';
import 'package:mobilelabelimg/widgets/inkwell_widget.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:super_tooltip/super_tooltip.dart';

class MainPageV1 extends StatefulWidget {
  const MainPageV1({Key? key}) : super(key: key);

  @override
  _MainPageV1State createState() => _MainPageV1State();
}

class _MainPageV1State extends State<MainPageV1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(appname),
      ),
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 50,
              ),
              FlipCard(
                back: InkWellWidget(
                  // onWidgetPressed: () {
                  //   print("跳转");
                  //   Navigator.of(context).pushNamed(Routers.pageLabelimgMain);
                  // },
                  // leading: Container(
                  //   width: 50,
                  //   height: 50,
                  //   child: Image.asset("assets/app_icons/labelimg.png"),
                  // ),
                  title: const Text("图标源于labelImg仓库"),
                  // subtitle: Text(
                  //     "此图标源于labelImg仓库，https://github.com/tzutalin/labelImg"),
                  trailing: TextButton(
                    child: const Text("跳转仓库"),
                    onPressed: () async {
                      await launch("https://github.com/tzutalin/labelImg");
                    },
                  ),
                ),
                front: InkWellWidget(
                  // onWidgetPressed: () {
                  //   print("跳转");
                  //   Navigator.of(context).pushNamed(Routers.pageLabelimgMain);
                  // },
                  leading: SizedBox(
                    width: 50,
                    height: 50,
                    child: Image.asset("assets/app_icons/labelimg.png"),
                  ),
                  title: const Text("labelImg 是一个多用于目标识别的标注工具"),
                  // subtitle: Text(
                  //     "此图标源于labelImg仓库，https://github.com/tzutalin/labelImg"),
                  // trailing: TextButton(
                  //   child: Text("跳转仓库"),
                  //   onPressed: () async {
                  //     await launch("https://github.com/tzutalin/labelImg");
                  //   },
                  // ),
                  trailing: TextButton(
                    child: const Text("点此尝试"),
                    onPressed: () {
                      Navigator.of(context).pushNamed(Routers.pageLabelimgMain);
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              FlipCard(
                  front: InkWellWidget(
                    // onWidgetPressed: () {
                    //   print("跳转");
                    //   Navigator.of(context).pushNamed(Routers.pageLabelmeMain);
                    // },
                    leading: SizedBox(
                      width: 50,
                      height: 50,
                      child: Image.asset("assets/app_icons/labelme.png"),
                    ),
                    title: const Text("labelme 是一个多用于图像分割的标注工具"),
                    // subtitle:
                    //     Text("此图标源于labelImg仓库，https://github.com/wkentaro/labelme"),
                    // trailing: TextButton(
                    //   child: Text("跳转仓库"),
                    //   onPressed: () async {
                    //     await launch("https://github.com/wkentaro/labelme");
                    //   },
                    // ),

                    trailing: TextButton(
                      child: const Text("点此尝试"),
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(Routers.pageLabelmeMain);
                      },
                    ),
                  ),
                  back: InkWellWidget(
                    // onWidgetPressed: () {
                    //   print("跳转");
                    //   Navigator.of(context).pushNamed(Routers.pageLabelmeMain);
                    // },
                    // leading: Container(
                    //   width: 50,
                    //   height: 50,
                    //   child: Image.asset("assets/app_icons/labelme.png"),
                    // ),
                    title: const Text("图标源于labelImg仓库"),
                    // subtitle:
                    //     Text("此图标源于labelImg仓库，https://github.com/wkentaro/labelme"),
                    trailing: TextButton(
                      child: const Text("跳转仓库"),
                      onPressed: () async {
                        await launch("https://github.com/wkentaro/labelme");
                      },
                    ),

                    // trailing: TextButton(
                    //   child: Text("点此尝试"),
                    //   onPressed: () {
                    //     Navigator.of(context)
                    //         .pushNamed(Routers.pageLabelmeMain);
                    //   },
                    // ),
                  )),
              const SizedBox(
                height: 25,
              ),
              InkWellWidget(
                onWidgetPressed: () async {
                  await launch("https://guchengxi1994.github.io");
                },
                leading: SizedBox(
                  width: 50,
                  height: 50,
                  child: Image.asset("assets/app_icons/me.jpg"),
                ),
                title: const Text("关于我"),
                // subtitle: Text("此头像为黑暗之魂3防火女"),
              ),
              const SizedBox(
                height: 25,
              ),
              InkWellWidget(
                onWidgetPressed: () async {
                  Navigator.of(context).pushNamed(Routers.policyPage);
                },
                leading: const SizedBox(
                  width: 50,
                  height: 50,
                  child: Icon(
                    Icons.ac_unit,
                    color: Colors.greenAccent,
                  ),
                ),
                title: const Text("隐私政策"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
