import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:scaffold_responsive/scaffold_responsive.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String tab = '';

  List<Widget> tabs = [];
  List<Widget> tabbarViews = [];
  List<String> currentTabStrs = [];

  void setTab(String newTab) {
    setState(() {
      tabs.add(buildTab(text: newTab));
      tabbarViews.add(Center(
        child: Text(newTab),
      ));
    });
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      tabs.add(buildTab(text: "主页"));
      tabbarViews.add(const Center(
        child: Text("主页"),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    const _textStyle = TextStyle(color: Colors.black, fontSize: 26.0);
    return ResponsiveScaffold(
      title: const Text('Responsive Scaffold Demo'),
      body: buildTabbarWidget(),
      tabs: const [
        {
          'title': 'Chapter A',
          'children': [
            {'title': 'Chapter A1'},
            {'title': 'Chapter A2'},
          ],
        },
        {
          'title': 'Chapter B',
          'children': [
            {'title': 'Chapter B1'},
            {
              'title': 'Chapter B2',
              'children': [
                {'title': 'Chapter B2a'},
                {'title': 'Chapter B2b'},
              ],
            },
          ],
        },
        {
          'title': 'Chapter C',
        },
      ],
      onTabChanged: setTab,
    );
  }

  Widget buildTabbarWidget() {
    debugPrint(tabs.length.toString());
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        body: TabBarView(
          children: tabbarViews,
        ),
        appBar: AppBar(
            bottom: PreferredSize(
                child: TabBar(
                  tabs: tabs,
                ),
                preferredSize: Size.fromHeight(48))),
      ),
    );
  }

  Widget buildTab({required String text}) {
    return SizedBox(
      height: 50,
      width: 100,
      child: Row(
        children: [
          Text(text),
          InkWell(
            child: const Icon(Icons.delete),
            onTap: () {
              debugPrint("我这里要删掉这个tab");
              // ignore: list_remove_unrelated_type
              // tabs.remove(this);
            },
          ),
        ],
      ),
    );
  }
}
