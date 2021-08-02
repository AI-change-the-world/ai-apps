import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Drawer"),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text("达帮主"), //设置名字
              accountEmail: Text("www.1102465673@qq.com"), //设置邮箱
              currentAccountPicture: CircleAvatar(
                //设置头像
                backgroundImage:
                    NetworkImage("https://www.itying.com/images/flutter/3.png"),
              ),
              decoration: BoxDecoration(
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
            Container(
              child: RaisedButton(
                //按钮
                child: Text("Drawer点击跳转"),
                onPressed: () {
                  // Navigator.pop(context); //先把Drawer给关闭掉
                  // Navigator.pushNamed(context, "/search"); //然后在跳转
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
