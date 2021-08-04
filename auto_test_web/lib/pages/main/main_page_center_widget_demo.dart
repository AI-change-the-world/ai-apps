/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2021-08-03 19:04:37
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2021-08-03 20:32:25
 */
import 'package:auto_test_web/pages/main/bloc/center_widget_bloc.dart';
import 'package:auto_test_web/pages/main/main_page_provider.dart';
import 'package:auto_test_web/utils/common.dart';
import 'package:auto_test_web/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:provider/provider.dart';

class CenterWidget extends StatefulWidget {
  CenterWidget({Key? key}) : super(key: key);

  @override
  _CenterWidgetState createState() => _CenterWidgetState();
}

class _CenterWidgetState extends State<CenterWidget> {
  List tabs = [];

  late String formName;
  late CenterWidgetBloc _centerWidgetBloc;

  @override
  void initState() {
    super.initState();
    _centerWidgetBloc = context.read<CenterWidgetBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CenterWidgetBloc, CenterWidgetState>(
        builder: (context, state) {
      return SafeArea(
        child: Column(
          children: [
            Header(),
            SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    flex: 5,
                    child: Column(
                      children: [
                        if (Responsive.isDesktop(context))
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: _centerWidgetBloc.state.tabList,
                                // children:
                                //     context.watch<ListTabsController>().tabs,
                              ),
                            ),
                          ),
                        _centerWidgetBloc.state.centerWidget,
                        // context
                        //     .read<CenterWidgetController>()
                        //     .currentCenterWidget,
                      ],
                    )),
              ],
            ),
          ],
        ),
      );
    });
  }
}
