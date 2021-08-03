import 'package:auto_test_web/pages/main/main_page_provider.dart';
import 'package:auto_test_web/utils/common.dart';
import 'package:auto_test_web/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CenterWidget extends StatefulWidget {
  CenterWidget({Key? key}) : super(key: key);

  @override
  _CenterWidgetState createState() => _CenterWidgetState();
}

class _CenterWidgetState extends State<CenterWidget> {
  List tabs = [];

  late String formName;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    formName = context.read<ListTabsController>().activateStr;
  }

  @override
  Widget build(BuildContext context) {
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
                              children:
                                  context.watch<ListTabsController>().tabs,
                            ),
                          ),
                        ),
                      context
                          .read<CenterWidgetController>()
                          .currentCenterWidget,
                    ],
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
