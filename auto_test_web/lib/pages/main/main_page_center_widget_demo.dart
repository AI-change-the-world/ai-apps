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
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';

class CenterWidget extends StatefulWidget {
  const CenterWidget({Key? key}) : super(key: key);

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
      return LoadingOverlay(
        isLoading: context.watch<LoadingController>().isLoading,
        child: SafeArea(
          child: Column(
            children: [
              const Header(),
              const SizedBox(height: defaultPadding),
              if (Responsive.isDesktop(context))
                Align(
                  alignment: Alignment.centerLeft,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: _centerWidgetBloc.state.tabList,
                    ),
                  ),
                ),
              _centerWidgetBloc.state.centerWidget,
            ],
          ),
        ),
      );
      ;
    });
  }
}
