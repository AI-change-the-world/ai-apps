import 'dart:convert';

import 'package:auto_test_web/models/CommonRes.dart';
import 'package:auto_test_web/models/ProjectModel.dart';
import 'package:auto_test_web/pages/main/bloc/center_widget_bloc.dart';
import 'package:auto_test_web/pages/main/main_page_provider.dart';
import 'package:auto_test_web/utils/apis.dart';
import 'package:auto_test_web/utils/common.dart';
import 'package:auto_test_web/utils/dio_utils.dart';
import 'package:auto_test_web/utils/toast_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllProjectsWidget extends StatefulWidget {
  AllProjectsWidget({Key? key}) : super(key: key);

  @override
  _AllProjectsWidgetState createState() => _AllProjectsWidgetState();
}

class _AllProjectsWidgetState extends State<AllProjectsWidget> {
  // ignore: prefer_typing_uninitialized_variables
  var _queruAllProjects;
  late CenterWidgetBloc _centerWidgetBloc;
  Apis apis = Apis();
  DioUtil dio = DioUtil();

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

                return Container(
                  constraints: BoxConstraints(
                      minHeight: 0.7 * MediaQuery.of(context).size.height,
                      minWidth: 0.5 * MediaQuery.of(context).size.width),
                  child: SingleChildScrollView(
                    child: PaginatedDataTable(
                      sortAscending: _sortAscending,
                      sortColumnIndex: 0,
                      availableRowsPerPage: const [5, 10],
                      rowsPerPage: _rowPerPage,
                      onRowsPerPageChanged: (v) {
                        setState(() {
                          if (null != v) {
                            debugPrint(_list.length.toString());
                            _rowPerPage = v;
                          }
                        });
                      },
                      onPageChanged: (page) async {
                        context.read<LoadingController>().changeState(true);
                        if (page >= _list.length &&
                            _totalProjectNumber > page) {
                          _start += 1;
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
                        const DataColumn(label: Text("项目创建时间")),
                        const DataColumn(label: Text("项目名")),
                        const DataColumn(label: Text("执行")),
                      ],
                      source:
                          ProjectDataTableSource(_list, _totalProjectNumber),
                    ),
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
  ProjectDataTableSource(this.data, this.numbers);
  int _selectCount = 0;
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
          DataCell(Text(data![index].createTime ?? "无")),
          DataCell(IconButton(
            icon: const Icon(
              Icons.arrow_right,
              color: Colors.green,
            ),
            onPressed: () {
              debugPrint("Go");
            },
          ))
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
