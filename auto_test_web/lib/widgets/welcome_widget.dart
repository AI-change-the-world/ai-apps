/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2021-08-03 19:35:26
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2021-08-03 19:39:19
 */

import 'package:auto_test_web/utils/common.dart';
import 'package:flutter/material.dart';

class WelcomeWidget extends StatelessWidget {
  const WelcomeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.7 * CommonUtils.screenH(),
      child: const Center(
        child: Text("自零伊始，从壹而终"),
      ),
    );
  }
}
