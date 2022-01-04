import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:mobilelabelimg/utils/common.dart';

Future<String> loadAsset({String? p}) async {
  return await rootBundle.loadString("assets/txts/policy.txt");
}

// ignore: must_be_immutable
class PolicyPage extends StatefulWidget {
  bool withTitle;

  PolicyPage({Key? key, required this.withTitle}) : super(key: key);

  @override
  _PolicyPageState createState() => _PolicyPageState();
}

class _PolicyPageState extends State<PolicyPage> {
  dynamic result;
  var _result = "";

  loadTxt() async {
    result = await loadAsset();
    setState(() {
      _result = result.toString();
    });
  }

  @override
  void initState() {
    super.initState();
    loadTxt();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.withTitle
          ? AppBar(
              title: const Text("隐私政策"),
              centerTitle: true,
              leading: InkWell(
                child: const Icon(Icons.chevron_left),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
            )
          : null,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          child: SizedBox(
            width: CommonUtil.screenW() * 0.9,
            child: getRenderedTxt(),
          ),
        ),
      )),
    );
  }

  Widget getRenderedTxt() {
    debugPrint("start rendering");
    return Column(
      children: _result.split('\n').map((e) {
        return renderTxt(e);
      }).toList(),
    );
  }

  Widget renderTxt(String s) {
    if (s.startsWith("[title]")) {
      return Text(
        s.replaceAll("[title]", ''),
        style: CommonUtil.jobNameStyle,
      );
    } else if (s.startsWith("[subtitle]")) {
      return Container(
          alignment: const Alignment(-1, 0),
          child: Text(
            s.replaceAll(
              "[subtitle]",
              '',
            ),
            style: CommonUtil.fontStyle,
          ));
    } else {
      return Container(
        alignment: const Alignment(-1, 0),
        child: Text(
          s,
        ),
      );
    }
  }
}
