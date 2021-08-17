import 'package:flutter/material.dart';
import 'package:mobilelabelimg/utils/common.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:super_tooltip/super_tooltip.dart';

class MainPageV1 extends StatefulWidget {
  MainPageV1({Key? key}) : super(key: key);

  @override
  _MainPageV1State createState() => _MainPageV1State();
}

class _MainPageV1State extends State<MainPageV1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(appname),
      ),
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                child: InkWell(
                  onTap: () {
                    print("跳转");
                  },
                  child: Container(
                    height: 150,
                    width: 0.8 * CommonUtil.screenW(),
                    child: Center(
                      child: ListTile(
                        leading: Container(
                          width: 50,
                          height: 50,
                          child: Image.asset("assets/app_icons/labelimg.png"),
                        ),
                        title: Text("labelImg 是一个多用于目标识别的标注工具"),
                        subtitle: Text(
                            "此图标源于labelImg仓库，https://github.com/tzutalin/labelImg"),
                        trailing: TextButton(
                          child: Text("跳转仓库"),
                          onPressed: () async {
                            await launch(
                                "https://github.com/tzutalin/labelImg");
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Card(
                child: InkWell(
                  onTap: () {
                    print("跳转");
                  },
                  child: Container(
                    height: 150,
                    width: 0.8 * CommonUtil.screenW(),
                    child: Center(
                      child: ListTile(
                        leading: Container(
                          width: 50,
                          height: 50,
                          child: Image.asset("assets/app_icons/labelme.png"),
                        ),
                        title: Text("labelme 是一个多用于图像分割的标注工具"),
                        subtitle: Text(
                            "此图标源于labelImg仓库，https://github.com/wkentaro/labelme"),
                        trailing: TextButton(
                          child: Text("跳转仓库"),
                          onPressed: () async {
                            await launch("https://github.com/wkentaro/labelme");
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
