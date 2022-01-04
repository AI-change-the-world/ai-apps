/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2021-08-17 19:07:04
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2021-08-17 19:23:47
 */
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobilelabelimg/utils/common.dart';

const _height = 150.0;

// ignore: must_be_immutable
class InkWellWidget extends StatelessWidget {
  // const InkWellWidget({Key? key}) : super(key: key);
  GestureTapCallback? onWidgetPressed;
  Widget? leading;
  Widget? title;
  Widget? trailing;
  Widget? subtitle;
  double? height;

  InkWellWidget(
      {Key? key,
      this.onWidgetPressed,
      this.leading,
      this.title,
      this.trailing,
      this.subtitle,
      this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 15.0,
      child: InkWell(
        onTap: onWidgetPressed,
        child: SizedBox(
          height: height ?? _height,
          width: 0.8 * CommonUtil.screenW(),
          child: Center(
            child: ListTile(
              leading: SizedBox(
                width: 50,
                height: 50,
                child: leading ??
                    SvgPicture.asset(
                      "assets/icons/Search.svg",
                      color: Colors.black54,
                      height: 16,
                    ),
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
