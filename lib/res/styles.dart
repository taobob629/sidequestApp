/*
  styles
  sidequest_hub_app
  desc:
  Created by chunma on .
  Copyright © sidequest_hub_app. All rights reserved.
*/
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wy/config/app_color.dart';

class PageStyle {
  static var ts_FFFFFF_15sp = TextStyle(
    fontSize: 15.sp,
    color: Color(0xFFFFFFFF),
  );
  static var ts_FFFFFF_16sp = TextStyle(
    fontSize: 16.sp,
    color: Color(0xFFFFFFFF),
  );
  static var labelStyle = TextStyle(
    fontSize: 15.sp,
    fontWeight: FontWeight.bold,
    color: Color(0xFFFFFFFF),
  );
}

var itemPaddingNormal = EdgeInsets.all(15.r);

inputHint() => TextStyle(color: Color(0xFFB2B9C9), fontSize: 14.sp);

BoxDecoration itemDecoration() =>
    BoxDecoration(color: AppColor.itemBg, borderRadius: BorderRadius.circular(16.r));

ShapeDecoration inputDecoration() => ShapeDecoration(
    color: Color(0xFF313033),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10).r));

BoxDecoration pageDecoration() => BoxDecoration(
        gradient: LinearGradient(
      colors: [
        Color(0xFFFA9B83),
        Color(0xFF312D47),
        AppColor.background,
      ],
      stops: [0.1, 0.3, 0.6],
      begin: Alignment(-2, -1),
      end: Alignment(2, 1),
    ));
