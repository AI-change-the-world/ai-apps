import 'dart:convert';

import 'package:auto_test_web/models/CommonRes.dart';
import 'package:auto_test_web/pages/main/bloc/center_widget_bloc.dart';
import 'package:auto_test_web/pages/main/main_page_provider.dart';
import 'package:auto_test_web/utils/apis.dart';
import 'package:auto_test_web/utils/common.dart';
import 'package:auto_test_web/utils/dio_utils.dart';
import 'package:auto_test_web/utils/toast_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pretty_json/pretty_json.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewProjectWidget extends StatefulWidget {
  NewProjectWidget({Key? key}) : super(key: key);

  @override
  _NewProjectWidgetState createState() => _NewProjectWidgetState();
}

class _NewProjectWidgetState extends State<NewProjectWidget> {
  final TextEditingController _projectTextController = TextEditingController();

  final TextEditingController _jsonStrController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();

  late CenterWidgetBloc _centerWidgetBloc;

  bool execAble = false;

  Apis apis = Apis();
  DioUtil dio = DioUtil();
  bool _posting = false;

  @override
  void initState() {
    super.initState();
    _centerWidgetBloc = context.read<CenterWidgetBloc>();
    _jsonStrController.addListener(() {
      if (_jsonStrController.text == "") {
        setState(() {
          execAble = false;
        });
      } else {
        setState(() {
          execAble = true;
        });
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _projectTextController.dispose();
    _jsonStrController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CenterWidgetBloc, CenterWidgetState>(
        builder: (context, state) {
      return Container(
        padding: const EdgeInsets.all(5),
        height: 0.7 * MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (!Responsive.isDesktop(context))
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    iconSize: 50,
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      _centerWidgetBloc.add(WidgetDelete(
                          widgetName: _centerWidgetBloc.state.currentTabName));
                    },
                  ),
                ),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text("??????????????????"),
              ),
              TextField(
                controller: _projectTextController,
                decoration: const InputDecoration(hintText: "????????????????????????"),
              ),
              const SizedBox(
                height: 5,
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("????????????????????????url???"),
              ),
              TextField(
                controller: _urlController,
                decoration: const InputDecoration(hintText: "???????????????url"),
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  const Text("?????????Json:"),
                  const SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                      onPressed: !execAble
                          ? null
                          : () {
                              try {
                                var _jsonStr = _jsonStrController.text;
                                var _json = jsonDecode(_jsonStr);
                              } catch (e) {
                                showCupertinoDialog(
                                    context: context,
                                    builder: (context) {
                                      return CupertinoAlertDialog(
                                        title: const Text("json ????????????"),
                                        actions: [
                                          CupertinoActionSheetAction(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text("??????")),
                                        ],
                                      );
                                    });
                              }
                            },
                      child: const Text("??????Json?????????")),
                  const SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                      onPressed: !execAble
                          ? null
                          : () {
                              _jsonStrController.text = "";
                            },
                      child: const Text("??????")),
                  const SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        showCupertinoDialog(
                            context: context,
                            builder: (context) {
                              return CupertinoAlertDialog(
                                title: const Text("?????????Json??????"),
                                actions: [
                                  CupertinoActionSheetAction(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("??????")),
                                ],
                                content: Column(
                                  children: [
                                    Text(prettyJson(templeteJson, indent: 1)),
                                  ],
                                ),
                              );
                            });
                      },
                      child: const Text("??????Json??????")),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              // const Divider(
              //   color: Colors.blue,
              // ),
              TextField(
                maxLength: null,
                controller: _jsonStrController,
                decoration: const InputDecoration(hintText: "????????????json"),
              ),
              const SizedBox(
                height: 20,
              ),

              ElevatedButton(
                  onPressed: !execAble
                      ? null
                      : () async {
                          context.read<LoadingController>().changeState(true);
                          try {
                            var _jsonStr = _jsonStrController.text;
                            var _url = _urlController.text;

                            if (_jsonStr != "" && _url != "") {
                              var _json = jsonDecode(_jsonStr);
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              var _userId = prefs.getInt("userid");
                              Map<String, dynamic> _map = {
                                "json": _json,
                                "user_id": _userId,
                                "project_url": _urlController.text,
                                "project_name": _projectTextController.text
                              };
                              String url = apis.newProjectPre;
                              Response response =
                                  await dio.post(url, data: _map);
                              // print(response.toString());
                              CommenResponse commenResponse =
                                  CommenResponse.fromJson(
                                      jsonDecode(response.toString()));
                              if (commenResponse.code != 10) {
                                showToastMessage(
                                    commenResponse.message.toString(), context);
                              } else {
                                showToastMessage("????????????", context);
                              }
                            } else {
                              showToastMessage("????????????????????????", context);
                            }
                          } catch (e) {
                            showToastMessage("Json???????????????????????????", context);
                          }

                          await Future.delayed(Duration.zero).then((value) {
                            context
                                .read<LoadingController>()
                                .changeState(false);
                          });
                        },
                  child: const Text("??????")),
            ],
          ),
        ),
      );
    });
  }
}
