import 'package:flutter/material.dart';
import 'package:mobilelabelimg/utils/common.dart';

const _height = 150.0;

class InkWellWidget extends StatelessWidget {
  // const InkWellWidget({Key? key}) : super(key: key);
  GestureTapCallback? onWidgetPressed;
  Widget? leading;
  Widget? title;
  Widget? trailing;
  Widget? subtitle;
  double? height;

  InkWellWidget(
      {this.onWidgetPressed,
      this.leading,
      this.title,
      this.trailing,
      this.subtitle,
      this.height});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onWidgetPressed,
        child: Container(
          height: height ?? _height,
          width: 0.8 * CommonUtil.screenW(),
          child: Center(
            child: ListTile(
              leading: Container(
                width: 50,
                height: 50,
                child: leading ?? Icon(Icons.headphones),
              ),
              title: title,
              subtitle: subtitle,
              trailing: trailing,
            ),
          ),
        ),
      ),
    );
  }
}
