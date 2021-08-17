import 'package:flutter/material.dart';
import 'package:mobilelabelimg/widgets/inkwell_widget.dart';

class LabelImgOpenningPage extends StatefulWidget {
  LabelImgOpenningPage({Key? key}) : super(key: key);

  @override
  _LabelImgOpenningPageState createState() => _LabelImgOpenningPageState();
}

class _LabelImgOpenningPageState extends State<LabelImgOpenningPage> {
  var _imgpath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("labelImg 移动版"),
      ),
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWellWidget(
                height: 80,
                onWidgetPressed: () {
                  print("点击了选取图片");
                },
                leading: Icon(
                  Icons.file_present,
                  color: Colors.blue,
                ),
                title: Text("选取图片进行标注（单张）"),
                trailing: Icon(Icons.chevron_right),
              ),
              InkWellWidget(
                height: 80,
                onWidgetPressed: () {
                  print("点击了返回");
                  Navigator.of(context).pop();
                },
                leading: Icon(
                  Icons.backspace,
                  color: Colors.orange,
                ),
                title: Text("返回"),
                trailing: Icon(Icons.chevron_right),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
