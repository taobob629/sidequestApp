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
  static var itemPaddingNormal = EdgeInsets.all(15.r);
}

BoxDecoration itemDecoration() =>
    BoxDecoration(color: AppColor.itemBg, borderRadius: BorderRadius.circular(16.r));
