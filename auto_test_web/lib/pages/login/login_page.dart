// ignore_for_file: deprecated_member_use

import 'package:auto_test_web/routers.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _posting = false;
  final TextEditingController userEditController = TextEditingController();
  final TextEditingController passEditController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    userEditController.dispose();
    passEditController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoadingOverlay(
        isLoading: _posting,
        child: Center(
          child: Card(
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              behavior: HitTestBehavior.translucent,
              child: Container(
                padding: const EdgeInsets.all(20),
                width: 500,
                height: 400,
                child: Column(
                  children: [
                    const Text(
                      "壹零Api测试平台",
                      style: TextStyle(fontSize: 30),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "自零伊始，从一而终",
                      style: TextStyle(fontFamily: "MaShanZheng", fontSize: 20),
                    ),
                    const SizedBox(height: 40),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: userEditController,
                            autofocus: false,
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                hintText: '请输入用户名',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5))),
                            validator: (value) {
                              if (null == value || "" == value) {
                                return "用户名不能为空";
                              }
                              return null;
                            },
                          ),
                          // 间隔
                          const SizedBox(height: 20),

                          // 输入密码
                          TextFormField(
                            controller: passEditController,
                            obscureText: true,
                            // 是否自动对焦
                            autofocus: false,
                            // 输入模式设置为手机号
                            keyboardType: TextInputType.visiblePassword,
                            // 装饰
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                hintText: '请输入密码',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5))),
                            validator: (value) {
                              if (null == value || "" == value) {
                                return "密码不能为空";
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              _posting = true;
                            });
                            if (userEditController.text == "admin" &&
                                passEditController.text == "123456") {
                              Navigator.of(context)
                                  .pushNamed(Routers.pageAdmin);
                            }

                            Navigator.of(context).pushNamed(Routers.pageMain);
                            setState(() {
                              _posting = false;
                            });
                          }
                        },
                        child: const SizedBox(
                          width: 200,
                          height: 50,
                          child: Center(
                            child: Text(
                              "登陆",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
