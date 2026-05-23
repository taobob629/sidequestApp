/**
    author:mac
    创建日期:2023/2/21
    描述:
 */
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmptyView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'No data',
        style: TextStyle(
          color: const Color(0xFFB2B9C9),
          fontSize: 14.sp,
        ),
      ),
    );
  }
}
