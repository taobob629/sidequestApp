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
      child: ImageUtil.assetImage('empty', width: 115.w, height: 115.w),
    );
  }
}
