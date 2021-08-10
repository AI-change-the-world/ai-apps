import 'dart:convert';

import 'package:auto_test_web/models/CommonRes.dart';
import 'package:auto_test_web/models/ProjectModel.dart';
import 'package:auto_test_web/pages/main/bloc/center_widget_bloc.dart';
import 'package:auto_test_web/pages/main/main_page_provider.dart';
import 'package:auto_test_web/utils/apis.dart';
import 'package:auto_test_web/utils/common.dart';
import 'package:auto_test_web/utils/dio_utils.dart';
import 'package:auto_test_web/utils/toast_utils.dart';
import 'package:auto_test_web/widgets/project_detail_widget.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

Apis apis = Apis();
DioUtil dio = DioUtil();

class AllProjectsWidget extends StatefulWidget {
  AllProjectsWidget({Key? key}) : super(key: key);

  @override
  _AllProjectsWidgetState createState() => _AllProjectsWidgetState();
}

class _AllProjectsWidgetState extends State<AllProjectsWidget> {
  // ignore: prefer_typing_uninitialized_variables
  var _queruAllProjects;
  late CenterWidgetBloc _centerWidgetBloc;

  // ignore: prefer_final_fields
  List<ProjectModel> _list = [];
  late int _rowPerPage;
  var _sortAscending = true;
  int _totalProjectNumber = 0;
  int _start = 1;

  @override
  void initState() {
    super.initState();
    _rowPerPage = 0.7 * CommonUtils.screenH() > 500 ? 10 : 5;
    _queruAllProjects = queryProjects(_start, _rowPerPage);
    _centerWidgetBloc = context.read<CenterWidgetBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _queruAllProjects,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              showToastMessage(snapshot.error.toString(), context);
              return const Center(
                child: Text("出错了！"),
              );
            } else {
              if (null != snapshot.data) {
                // debugPrint(snapshot.data.toString());

                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: PaginatedDataTable(
                    sortAscending: _sortAscending,
                    sortColumnIndex: 0,
                    availableRowsPerPage: const [5, 10],
                    rowsPerPage: _rowPerPage,
                    onRowsPerPageChanged: (v) async {
                      if (null != v) {
                        debugPrint(_list.length.toString());
                        context.read<LoadingController>().changeState(true);
                        _rowPerPage = v;
                        _list.clear();
                        _start = 1;
                        await queryProjects(_start, _rowPerPage);
                        await Future.delayed(Duration.zero).then((value) {
                          context.read<LoadingController>().changeState(false);
                        });
                      }
                      setState(() {});
                    },
                    onPageChanged: (page) async {
                      context.read<LoadingController>().changeState(true);
                      if (page >= _list.length && _totalProjectNumber > page) {
                        _start = _start + 1;
                        await queryProjects(_start, _rowPerPage);
                        setState(() {});
                      }
                      await Future.delayed(Duration.zero).then((value) {
                        context.read<LoadingController>().changeState(false);
                      });
                    },
                    header: const Text("你的所有项目"),
                    columns: [
                      DataColumn(
                          label: const Text("项目ID"),
                          onSort: (index, sortAscending) {
                            setState(() {
                              _sortAscending = sortAscending;
                              if (sortAscending) {
                                _list.sort((a, b) =>
                                    a.projectId!.compareTo(b.projectId!));
                              } else {
                                _list.sort((a, b) =>
                                    b.projectId!.compareTo(a.projectId!));
                              }
                            });
                          }),
                      const DataColumn(label: Text("项目名")),
                      if (Responsive.isDesktop(context))
                        const DataColumn(label: Text("项目创建时间")),
                      const DataColumn(label: Text("执行")),
                      const DataColumn(label: Text("查看项目执行状态")),
                    ],
                    source: ProjectDataTableSource(_list, _totalProjectNumber,
                        context: context),
                  ),
                );
              } else {
                return const Center(
                  child: Text("data is under construction"),
                );
              }
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Future<dynamic> queryProjects(int start, int length) async {
    String url = apis.queryAllProjectPre;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var _userId = prefs.getInt("userid");
    _userId ??= -1;
    url = url + "userid=${_userId}&start=${start}&length=${length}";
    Response response = await dio.get(url);
    // debugPrint(response.toString());

    if (null != response) {
      CommenResponse commenResponse =
          CommenResponse.fromJson(jsonDecode(response.toString()));

      var data = commenResponse.data;

      // debugPrint(data['list'].runtimeType.toString());

      if (null != data) {
        List _l = data['list'];
        List<ProjectModel> _data = [];
        for (var i in _l) {
          _data.add(ProjectModel.fromJson(i));
        }
        _list.addAll(_data);
        _totalProjectNumber = data['total'];
        return _data;
      } else {
        showToastMessage(commenResponse.message ?? "数据不存在", context);
        return null;
      }
    }

    return null;
  }
}

class ProjectDataTableSource extends DataTableSource {
  ProjectDataTableSource(this.data, this.numbers, {required this.context});
  int _selectCount = 0;
  BuildContext context;
  int numbers; //当前选中的行数

  final List<ProjectModel>? data;

  @override
  DataRow? getRow(int index) {
    // debugPrint("第0层");
    if (null == data) {
      // debugPrint("第一层");
      return null;
    } else {
      // debugPrint("第2层");
      if (index >= data!.length) {
        // debugPrint("第3层");
        return null;
      } else {
        // debugPrint(data![index].toJson().toString());
        return DataRow.byIndex(index: index, cells: [
          DataCell(Text('${data![index].projectId}')),
          DataCell(Text(data![index].projectName ?? "无")),
          if (Responsive.isDesktop(context))
            DataCell(Text(data![index].createTime ?? "无")),
          DataCell(IconButton(
            icon: const Icon(
              Icons.arrow_right,
              color: Colors.green,
            ),
            onPressed: () async {
              debugPrint("Go");
              String url = apis.startProjectPre;
              SharedPreferences prefs = await SharedPreferences.getInstance();
              var _userId = prefs.getInt("userid");
              _userId ??= -1;
              ProjectStartModel projectStartModel = ProjectStartModel();
              projectStartModel.userId = _userId;
              projectStartModel.projectId = data![index].projectId;
              Map _map = projectStartModel.toJson();
              Response response = await dio.post(url, data: _map);
              // print(response);
              if (null != response) {
                CommenResponse commenResponse =
                    CommenResponse.fromJson(jsonDecode(response.toString()));
                showToastMessage(commenResponse.message ?? "失败", context);
              } else {
                showToastMessage("失败", context);
              }
            },
          )),
          DataCell(IconButton(
            icon: const Icon(Icons.file_copy),
            onPressed: () async {
              int? projectId = data![index].projectId;
              if (null != projectId) {
                showCupertinoDialog(
                    context: context,
                    builder: (context) {
                      return CupertinoAlertDialog(
                        title: const Text("项目详细信息"),
                        content: ProjectDetailedWidget(
                          projectId: projectId,
                        ),
                        actions: [
                          CupertinoActionSheetAction(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("确定"))
                        ],
                      );
                    });
              }
            },
          )),
        ]);
      }
    }
  }

  @override
  // TODO: implement isRowCountApproximate
  bool get isRowCountApproximate => false;

  @override
  // TODO: implement rowCount
  int get rowCount => numbers;

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => _selectCount;
}
