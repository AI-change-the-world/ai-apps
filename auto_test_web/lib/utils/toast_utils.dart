import 'package:auto_test_web/utils/platform_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToastMessage(String message, BuildContext? context, {Color? color}) {
  if (PlatformUtils.isAndroid || PlatformUtils.isIOS || PlatformUtils.isWeb) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: color ?? Colors.orange,
        textColor: Colors.white,
        fontSize: 16.0);
  } else {
    if (null != context) {
      showCupertinoDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: Text(message),
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
  }
}
