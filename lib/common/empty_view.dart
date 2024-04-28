/**
    author:mac
    创建日期:2023/2/21
    描述:
 */
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sq_hub_app/image_utils.dart';

class EmptyView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        ImageUtils.empty,
        width: 115.w,
        height: 115.w,
      ),
    );
  }
}
