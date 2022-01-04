import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobilelabelimg/main_page_v1.dart';
import 'package:mobilelabelimg/policy_page.dart';
import 'package:mobilelabelimg/utils/common.dart';
import 'package:after_layout/after_layout.dart';
import 'package:package_info/package_info.dart';

const fontSize = 14.0;

class LaunchPage extends StatefulWidget {
  const LaunchPage({Key? key}) : super(key: key);

  @override
  _LaunchPageState createState() => _LaunchPageState();
}

class _LaunchPageState extends State<LaunchPage>
    with AfterLayoutMixin<LaunchPage> {
  bool _isSelected = false;
  // ignore: prefer_typing_uninitialized_variables
  var _futureVersionBuilder;

  @override
  void initState() {
    super.initState();
    _futureVersionBuilder = getAppInfo();

    checkFirstLogin().then((value) {
      if (value) {
        showPolicyDialog();
      }
    });
  }

  Future<String> getAppInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    // String appName = packageInfo.appName;
    // String packageName = packageInfo.packageName;
    String version = packageInfo.version;
    // String buildNumber = packageInfo.buildNumber;
    // print(version);
    return version;
  }

  showPolicyDialog() async {
    var result = await showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text("隐私政策"),
            content: SizedBox(
                height: 0.5 * CommonUtil.screenH(),
                child: PolicyPage(
                  withTitle: false,
                )),
            actions: <Widget>[
              CupertinoDialogAction(
                child: const Text('取消'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              CupertinoDialogAction(
                child: const Text('已认真阅读并同意'),
                onPressed: () {
                  Fluttertoast.showToast(
                      msg: "你已选择同意,已自动帮你勾选同意《隐私政策》",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.orange,
                      textColor: Colors.white,
                      fontSize: 16.0);
                  setState(() {
                    _isSelected = true;
                  });
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        });

    if (result) {
      await setPolicyAgreed();
      setState(() {
        _isSelected = true;
      });
    } else {
      setState(() {
        _isSelected = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              // height: CommonUtil.screenW(),
              width: CommonUtil.screenW(),
              child: Container(
                width: 0.85 * CommonUtil.screenW(),
                height: 0.85 * CommonUtil.screenW(),
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/app_icons/look.png"))),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: const Text(
                appname,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            FutureBuilder(
              future: _futureVersionBuilder,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Container(
                    margin: const EdgeInsets.only(top: 5),
                    child: Text(
                      "Version:" + snapshot.data.toString(),
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  );
                } else {
                  return Container(
                    margin: const EdgeInsets.only(top: 5),
                    child: const Text(
                      "🤪.🤪.🤪",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  );
                }
              },
            ),
            Column(
              children: [
                RawMaterialButton(
                  onPressed: () async {
                    if (_isSelected) {
                      await setPolicyAgreed();
                      debugPrint("点击了按钮");
                      // wechatAuth();
                      Navigator.pushAndRemoveUntil(context,
                          MaterialPageRoute(builder: (context) {
                        return const MainPageV1();
                      }), (route) => false);
                      // Navigator.pushAndRemoveUntil(context, newRoute, (route) => false)(context,
                      //     MaterialPageRoute(builder: (context) {
                      //   return MainPage();
                      // }));
                    } else {
                      Fluttertoast.showToast(
                          msg: "请先阅读并同意用户隐私协议",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.orange,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }
                  },
                  elevation: 2.0,
                  fillColor: Colors.white,
                  child: const Icon(
                    Icons.arrow_forward,
                    size: 35.0,
                  ),
                  padding: const EdgeInsets.all(15.0),
                  shape: const CircleBorder(),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: const Text("进入"),
                )
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: Center(
                child: getRadio(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getRadio() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  if (_isSelected) {
                    _isSelected = false;
                  } else {
                    _isSelected = true;
                  }
                });
              },
              child: Icon(
                Icons.check_circle_outline,
                size: 22,
                color: _isSelected ? Colors.blue : Colors.grey,
              ),
            ),
            const Text(
              "我已阅读并同意" + appname,
              style: TextStyle(fontSize: fontSize),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return PolicyPage(
                    withTitle: true,
                  );
                }));
              },
              child: const Text(
                "《隐私政策》",
                style: TextStyle(color: Colors.blue, fontSize: fontSize),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "以及",
              style: TextStyle(fontSize: fontSize),
            ),
            InkWell(
              onTap: () {
                showCupertinoDialog(
                    context: context,
                    builder: (context) {
                      return CupertinoAlertDialog(
                        title: const Text("用户须知"),
                        content: const SizedBox(
                          width: 200,
                          child: Text("无人工,不智能。致敬所有为人工智能付出的科研人员。"),
                        ),
                        actions: [
                          CupertinoButton(
                              child: const Text("确定"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              })
                        ],
                      );
                    });
              },
              child: const Text(
                "《其它说明》",
                style: TextStyle(color: Colors.blue, fontSize: fontSize),
              ),
            ),
          ],
        )
      ],
    );
    // child: Text("我已阅读并同意《职小侠用户隐私协议》"),
  }

  @override
  void afterFirstLayout(BuildContext context) {
    checkPolicyAgreed().then((value) {
      if (value) {
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) {
          return const MainPageV1();
        }), (route) => false);
      }
    });
  }
}
