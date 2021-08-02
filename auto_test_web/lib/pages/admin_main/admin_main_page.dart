import 'package:flutter/material.dart';

class AdminMainPage extends StatefulWidget {
  const AdminMainPage({Key? key}) : super(key: key);

  @override
  _AdminMainPageState createState() => _AdminMainPageState();
}

class _AdminMainPageState extends State<AdminMainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: const Text("超级管理员"),
              accountEmail: const Text("guchengxi1994@qq.com"),
              currentAccountPicture: const CircleAvatar(
                backgroundImage:
                    NetworkImage("https://www.itying.com/images/flutter/3.png"),
              ),
              decoration: const BoxDecoration(
                  //设置背景颜色
                  color: Colors.yellow,
                  image: DecorationImage(
                      image: NetworkImage(
                          "https://www.itying.com/images/flutter/2.png"),
                      fit: BoxFit.cover)),
              otherAccountsPictures: [
                //用来设置当前账户其他账户头像
                Image.network("https://www.itying.com/images/flutter/4.png"),
                Image.network("https://www.itying.com/images/flutter/5.png"),
                Image.network("https://www.itying.com/images/flutter/6.png"),
              ],
            ),
            ListTile(
              title: Text("个人中心"),
              leading: CircleAvatar(
                child: Icon(Icons.people),
              ),
            ),
            ListTile(
              title: Text("系统设置"),
              leading: CircleAvatar(
                child: Icon(Icons.settings),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
