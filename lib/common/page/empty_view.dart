/**
    author:mac
    创建日期:2023/2/21
    描述:
 */
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wy/res/index.dart';
import 'package:wy/utils/index.dart';

class EmptyView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ImageUtil.assetImage('ic_dialog', width: 100, height: 100),
          40.verticalSpace,
          Container(
            child: Text(
              'no data'.tr,
              style: PageStyle.labelStyle,
            ),
          ),
        ],
      ),
    );
  }
}
