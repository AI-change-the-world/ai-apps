// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobilelabelimg/utils/routers.dart';
import 'package:mobilelabelimg/widgets/inkwell_widget.dart';
import 'package:permission_handler/permission_handler.dart';

class LabelmeOpenningPage extends StatefulWidget {
  const LabelmeOpenningPage({Key? key}) : super(key: key);

  @override
  _LabelmeOpenningPageState createState() => _LabelmeOpenningPageState();
}

class _LabelmeOpenningPageState extends State<LabelmeOpenningPage> {
  var _imgpath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("labelme 移动版"),
      ),
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 50,
              ),
              InkWellWidget(
                height: 80,
                onWidgetPressed: () async {
                  debugPrint("点击了选取图片");
                  if (await Permission.storage.request().isGranted) {
                    FilePickerResult? image = await FilePicker.platform
                        .pickFiles(type: FileType.image);
                    if (null != image) {
                      // print("==========================================");
                      // print(strs);
                      File file = File(image.files.single.path!);
                      // print(file.path);
                      // print("==========================================");
                      _imgpath = file.path;

                      Navigator.of(context).pushNamed(Routers.pagePolygonPage,
                          arguments: _imgpath);
                    } else {
                      Fluttertoast.showToast(
                          msg: "文件未选择",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 2,
                          backgroundColor: Colors.blue,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }
                  } else {
                    Fluttertoast.showToast(
                        msg: "需要同意权限才能使用功能",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 2,
                        backgroundColor: Colors.blue,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  }
                },
                leading: const Icon(
                  Icons.file_present,
                  color: Colors.blue,
                ),
                title: const Text("选取图片进行标注（单张）"),
                trailing: const Icon(Icons.chevron_right),
              ),
              const SizedBox(
                height: 25,
              ),
              InkWellWidget(
                height: 80,
                onWidgetPressed: () {
                  debugPrint("点击了返回");
                  Navigator.of(context).pop();
                },
                leading: const Icon(
                  Icons.backspace,
                  color: Colors.orange,
                ),
                title: const Text("返回"),
                trailing: const Icon(Icons.chevron_right),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
