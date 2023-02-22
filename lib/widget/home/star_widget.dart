/**
    author:mac
    创建日期:2023/2/20
    描述:
 */
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wy/utils/index.dart';

class StarWidget extends StatelessWidget {
  var star;

  StarWidget({this.star});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        //  ImageUtil.assetImage('score1', width: 15.w, height: 15.w),
        Icon(
          Icons.star,
          size: 15.w,
          color: Color(0xFFF4C708),
        ),
        5.horizontalSpace,
        Text(
          '$star',
          style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
