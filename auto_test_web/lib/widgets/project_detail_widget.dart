/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2021-08-07 18:27:26
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2021-08-07 18:56:40
 */

import 'package:flutter/material.dart';

class ProjectDetailedWidget extends StatefulWidget {
  final int projectId;
  ProjectDetailedWidget({Key? key, required this.projectId}) : super(key: key);

  @override
  _ProjectDetailedWidgetState createState() => _ProjectDetailedWidgetState();
}

class _ProjectDetailedWidgetState extends State<ProjectDetailedWidget> {
  var _getProjectDetailFuture;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: FutureBuilder(
          future: _getProjectDetailFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (!snapshot.hasError) {
                return Column(
                  children: [
                    const Text("项目执行状态:"),
                    const SizedBox(
                      height: 5,
                    ),
                    const Text("项目执行时间:"),
                    const SizedBox(
                      height: 5,
                    ),
                    const Text("总共次数:"),
                    const SizedBox(
                      height: 5,
                    ),
                    const Text("失败次数:"),
                    const SizedBox(
                      height: 5,
                    ),
                    const Text("下载报告:"),
                    const SizedBox(
                      height: 5,
                    ),
                    IconButton(
                      icon: const Icon(Icons.download),
                      onPressed: () {},
                    )
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
    );
  }
}
