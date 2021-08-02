import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:mobilelabelimg/utils/routers.dart';
import 'package:permission_handler/permission_handler.dart';

class MainPage extends StatefulWidget {
  MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // final ImagePicker _picker = ImagePicker();

  var _imgpath;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("labelImg 移动版"),
      ),
      body: Container(
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                  icon: Icon(
                    Icons.file_present,
                    size: 50,
                    color: Colors.orange,
                  ),
                  onPressed: () async {
                    if (await Permission.storage.request().isGranted) {
                      // var image =
                      //     await _picker.pickImage(source: ImageSource.gallery);
                      FilePickerResult? image = await FilePicker.platform
                          .pickFiles(type: FileType.image);

                      if (null != image) {
                        // print("==========================================");
                        // print(strs);
                        File file = File(image.files.single.path!);
                        // print(file.path);
                        // print("==========================================");
                        _imgpath = file.path;
                        Navigator.of(context).pushNamed(
                            Routers.pageAnnotationWorkboard,
                            arguments: _imgpath);
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
                  }),
              IconButton(
                  icon: Icon(
                    Icons.file_copy,
                    size: 50,
                    color: Colors.blue,
                  ),
                  onPressed: () async {
                    if (await Permission.storage.request().isGranted) {
                      // var image =
                      //     await _picker.pickImage(source: ImageSource.gallery);

                      // List<String> strs = [];

                      // List<Asset> assets = await selectImagesFromGallery(1000);

                      // for (Asset asset in assets) {
                      //   final filepath =
                      //       await FlutterAbsolutePath.getAbsolutePath(
                      //           asset.identifier);
                      //   strs.add(filepath);
                      // }

                      // print(image!.path);

                      // FilePickerResult? image = await FilePicker.platform
                      //     .pickFiles(allowMultiple: true);
                      // if (null != image) {
                      //   List<File> files =
                      //       image.paths.map((path) => File(path!)).toList();

                      //   List<String> strs = files.map((e) => e.path).toList();
                      //   _imgpath = strs;
                      // Navigator.of(context).pushNamed(
                      //     Routers.pageMultiAnnotationWorkboard,
                      //     arguments: strs);
                      // }
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
                  }),
              IconButton(
                  icon: Icon(
                    Icons.network_cell,
                    size: 50,
                    color: Colors.green,
                  ),
                  onPressed: () async {
                    var networtStatus =
                        await InternetAddress.lookup("www.baidu.com");
                    if (networtStatus.isNotEmpty &&
                        networtStatus[0].rawAddress.isNotEmpty) {
                      print("network available");
                    }
                    Fluttertoast.showToast(
                        msg: "需要同意权限才能使用功能",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 2,
                        backgroundColor: Colors.blue,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
