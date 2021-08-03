import 'package:auto_test_web/routers.dart';
import 'package:auto_test_web/utils/common.dart';
import 'package:flutter/material.dart';

class LoginPageDemo extends StatefulWidget {
  @override
  _LoginPageDemoState createState() {
    return _LoginPageDemoState();
  }
}

class _LoginPageDemoState extends State<LoginPageDemo> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget buildGesture() {
    return GestureDetector(
      // 可以点击空白收起键盘
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode()); // 收起键盘
      },
      child: Center(
          child: Scaffold(
        appBar: AppBar(title: const Text('登录')),
        body: Container(
          // 所有内容都设置向内55

          padding: const EdgeInsets.all(55),
          // 垂直布局
          child: Column(
            children: <Widget>[
              // 使用Form将两个输入框包起来 做控制
              Form(
                key: _formKey,
                // Form里面又是一个垂直布局
                child: Column(
                  children: <Widget>[
                    // 输入手机号
                    TextFormField(
                      // 是否自动对焦
                      autofocus: false,
                      // 输入模式设置为手机号
                      keyboardType: TextInputType.phone,
                      // 装饰
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          hintText: '请输入手机号',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5))),
                      // 输入框校验
                      validator: (value) {
                        RegExp reg = new RegExp(r'^\d{11}$');
                        if (!reg.hasMatch(value!)) {
                          return '请输入11位手机号码';
                        }
                        return null;
                      },
                    ),

                    // 间隔
                    SizedBox(height: 20),

                    // 输入密码
                    TextFormField(
                      obscureText: true,
                      // 是否自动对焦
                      autofocus: false,
                      // 输入模式设置为手机号
                      keyboardType: TextInputType.visiblePassword,
                      // 装饰
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          hintText: '请输入密码',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5))),
                      // 输入框校验
                      validator: (value) {
                        if (value!.length < 6) {
                          return '请输入正确的密码';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              Row(
                children: <Widget>[
                  SizedBox(width: MediaQuery.of(context).size.width - 200),
                  FlatButton(
                    child: Text(
                      '找回密码',
                      style: TextStyle(color: Colors.black54),
                    ),
                    onPressed: () {
                      print('找回密码');
                    },
                  ),
                ],
              ),
              Container(
                height: 44,
                width: MediaQuery.of(context).size.width - 110,
                decoration: BoxDecoration(
                    // color: MTColors.main_color,
                    borderRadius: BorderRadius.circular(5)),
                child: FlatButton(
                  child: Text(
                    '登录',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.of(context).pushNamed(Routers.pageMain);
                      print('登录啊啊啊啊');
                    }
                  },
                ),
              ),
              Container(
                child: Center(
                  child: FlatButton(
                    child:
                        Text('注册账号', style: TextStyle(color: Colors.black54)),
                    onPressed: () {
                      print('注册');
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildGesture();
  }
}
