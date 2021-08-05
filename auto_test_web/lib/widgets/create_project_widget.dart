import 'dart:convert';

import 'package:auto_test_web/pages/main/bloc/center_widget_bloc.dart';
import 'package:auto_test_web/utils/common.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewProjectWidget extends StatefulWidget {
  NewProjectWidget({Key? key}) : super(key: key);

  @override
  _NewProjectWidgetState createState() => _NewProjectWidgetState();
}

class _NewProjectWidgetState extends State<NewProjectWidget> {
  final TextEditingController _projectTextController = TextEditingController();

  final TextEditingController _jsonStrController = TextEditingController();

  late CenterWidgetBloc _centerWidgetBloc;

  bool execAble = false;

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
                child: Text("输入项目名："),
              ),
              TextField(
                controller: _projectTextController,
              ),
              const SizedBox(
                height: 5,
              ),
              // const Divider(
              //   color: Colors.blue,
              // ),
              Row(
                children: [
                  const Text("请输入Json:"),
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
                                        title: const Text("json 解析错误"),
                                        actions: [
                                          CupertinoActionSheetAction(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text("确定")),
                                        ],
                                      );
                                    });
                              }
                            },
                      child: const Text("验证Json正确性")),
                  const SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                      onPressed: !execAble
                          ? null
                          : () {
                              _jsonStrController.text = "";
                            },
                      child: const Text("清空")),
                  const SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        showCupertinoDialog(
                            context: context,
                            builder: (context) {
                              return CupertinoAlertDialog(
                                title: const Text("预设的Json模板"),
                                actions: [
                                  CupertinoActionSheetAction(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("确定")),
                                ],
                                content: Column(
                                  children: [],
                                ),
                              );
                            });
                      },
                      child: const Text("查看Json模板")),
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
              ),
              const SizedBox(
                height: 20,
              ),

              ElevatedButton(
                  onPressed: !execAble ? null : () {}, child: const Text("提交")),
            ],
          ),
        ),
      );
    });
  }
}