/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2021-08-07 18:27:26
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2021-08-07 18:56:40
 */

import 'dart:convert';

import 'package:auto_test_web/models/CommonRes.dart';
import 'package:auto_test_web/models/ProjectStatusModel.dart';
import 'package:auto_test_web/utils/apis.dart';
import 'package:auto_test_web/utils/dio_utils.dart';
import 'package:auto_test_web/utils/toast_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ProjectDetailedWidget extends StatefulWidget {
  final int projectId;
  ProjectDetailedWidget({Key? key, required this.projectId}) : super(key: key);

  @override
  _ProjectDetailedWidgetState createState() => _ProjectDetailedWidgetState();
}

class _ProjectDetailedWidgetState extends State<ProjectDetailedWidget> {
  Apis apis = Apis();
  DioUtil dio = DioUtil();

  Future<StatusModel?> getRunningStatus() async {
    String url =
        apis.projectDetailPre + "project_id=" + widget.projectId.toString();
    Response response = await dio.get(url);

    if (null != response) {
      CommenResponse commenResponse =
          CommenResponse.fromJson(jsonDecode(response.toString()));

      if (commenResponse.code != 10) {
        showToastMessage(commenResponse.message!, context);
        return null;
      } else {
        StatusModel statusModel = StatusModel.fromJson(commenResponse.data);
        // debugPrint(statusModel.toJson().toString());
        return statusModel;
      }
    } else {
      return null;
    }
  }

  var _getProjectDetailFuture;

  @override
  void initState() {
    super.initState();
    _getProjectDetailFuture = getRunningStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.blue,
      child: SingleChildScrollView(
        child: FutureBuilder(
            future: _getProjectDetailFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (!snapshot.hasError && null != snapshot.data) {
                  StatusModel model = snapshot.data as StatusModel;
                  return Column(
                    children: [
                      const Text("项目执行状态:"),
                      model.resultPath == null
                          ? const Text("进行中")
                          : const Text("已完成"),
                      const SizedBox(
                        height: 5,
                      ),
                      const Text("项目执行时间:"),
                      model.endTime == null
                          ? const Text("无")
                          : Text(model.endTime.toString()),
                      const SizedBox(
                        height: 5,
                      ),
                      const Text("总共次数:"),
                      model.testTimes == null
                          ? const Text("0")
                          : Text(model.testTimes.toString()),
                      const SizedBox(
                        height: 5,
                      ),
                      const Text("失败次数:"),
                      model.failTimes == null
                          ? const Text("0")
                          : Text(model.failTimes.toString()),
                      const SizedBox(
                        height: 5,
                      ),
                      const Text("下载报告:"),
                      IconButton(
                        icon: const Icon(Icons.download),
                        onPressed: model.resultPath == null ? null : () {},
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                    ],
                  );
                } else {
                  return Center(
                    child: Text("出错了，${snapshot.error}"),
                  );
                }
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ),
    );
    ;
  }
}
