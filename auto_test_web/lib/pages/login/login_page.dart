// ignore_for_file: deprecated_member_use

import 'dart:convert';

import 'package:auto_test_web/models/CommonRes.dart';
import 'package:auto_test_web/models/LoginModel.dart';
import 'package:auto_test_web/routers.dart';
import 'package:auto_test_web/utils/apis.dart';
import 'package:auto_test_web/utils/common.dart';
import 'package:auto_test_web/utils/dio_utils.dart';
import 'package:auto_test_web/utils/toast_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Apis apis = Apis();
  DioUtil dio = DioUtil();

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
                // width: 500,
                // // height: 400,
                constraints: BoxConstraints(
                    maxWidth: 500, maxHeight: 0.7 * CommonUtils.screenH()),
                child: Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "壹零Api测试平台",
                        style: TextStyle(fontSize: 30),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        welcomeStr,
                        style:
                            TextStyle(fontFamily: "MaShanZheng", fontSize: 20),
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
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                _posting = true;
                              });
                              // if (userEditController.text == "admin" &&
                              //     passEditController.text == "123456") {
                              //   Navigator.of(context)
                              //       .pushNamed(Routers.pageAdmin);
                              // }

                              String url = apis.loginPre;
                              LoginModel loginModel = LoginModel();
                              loginModel.password = passEditController.text;
                              loginModel.username = userEditController.text;
                              String _json = json.encode(loginModel.toJson());
                              Response response =
                                  await dio.post(url, data: _json);

                              // if (null != response) {
                              //   var data = response.data;
                              //   debugPrint(data.toString());
                              // }
                              CommenResponse commenResponse =
                                  CommenResponse.fromJson(
                                      jsonDecode(response.toString()));

                              // debugPrint(commenResponse.code.toString());

                              if (commenResponse.code != 10) {
                                showToastMessage(
                                    commenResponse.message.toString(), context);
                              } else {
                                // print(commenResponse.data);
                                LoginDataModel loginDataModel =
                                    LoginDataModel.fromJson(
                                        commenResponse.data);
                                if (loginDataModel.isRoot == 1) {
                                  showToastMessage(
                                      "管理员模块 is under construction", context);
                                } else {
                                  SharedPreferences preferences =
                                      await SharedPreferences.getInstance();
                                  await preferences.setInt(
                                      "userid", loginDataModel.userId ?? 0);
                                  Navigator.of(context)
                                      .pushNamed(Routers.pageMain);
                                }
                              }

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
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black),
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
      ),
    );
  }
}
